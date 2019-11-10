variable "servers" {
  type = list(object({
    address: string
    user: string
    role: list(string)
    ssh_key_path: string
    port: number
    ssh_key: string
    taints: list(object({
      key: string
      value: string
      effect: string
    }))
  }))
}

variable "ssh_agent_auth" {
  type = bool
}
variable "cluster_name" {
  type = string
}

variable "ingress-enabled" {
  type = bool
}

variable "extra_binds" {
  type = list(string)
  default = []
}

resource "template_file" "nodes" {
  template = <<NODES
nodes:
%{ for server in var.servers ~}
- address: ${server.address}
  user: ${server.user}
  port: ${server.port}
  role:
  %{for role in server.role}
    - ${role}
  %{endfor }
%{if server.ssh_key_path != ""}
  ssh_key_path: ${server.ssh_key_path}
%{ endif }
%{if server.ssh_key != ""}
  ssh-key: |-
        ${server.ssh_key}
%{ endif }
%{ endfor ~}
ssh_agent_auth: ${var.ssh_agent_auth}
%{if var.ingress-enabled}
ingress:
  provider: nginx
  node_selector:
    app: ingress
%{else}
ingress:
  provider: none
%{endif}
services:
 kubelet:
  # Base domain for the cluster
  cluster_domain: cluster.local
  # IP address for the DNS service endpoint
  cluster_dns_server: 10.43.0.10
  # Fail if swap is on
  fail_swap_on: false
  # Set max pods to 250 instead of default 110
  extra_args:
    max-pods: 250
  # Optionally define additional volume binds to a service
  extra_binds:
    - "/usr/libexec/kubernetes/kubelet-plugins:/usr/libexec/kubernetes/kubelet-plugins"
    %{for bind in var.extra_binds ~}
    - ${bind}
    %{endfor }
NODES

}

output "rke_config" {
  value = template_file.nodes.rendered
}

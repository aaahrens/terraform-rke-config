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


resource "template_file" "nodes" {
  template = <<NODES
nodes:
%{ for server in var.servers ~}
- address: ${server.address}
  user: ${server.user}
  port: ${server.port}
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
NODES

}

output "rke_config" {
  value = template_file.nodes.rendered
}

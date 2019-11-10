servers = [{address = "meow1", labels = [{key = "app", value = "ingress"}], port = 22, user: "root", role = ["controlplane"], ssh_key = "", taints  = [], ssh_key_path = ""}]

ssh_agent_auth = true

ingress-enabled = false
cluster_name = "workboards_hydra"

extra_binds = ["/mnt:/mnt"]
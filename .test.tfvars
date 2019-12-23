servers = [{address = "meow1",
  labels = [{key = "app", value = "ingress"}],
  port = 22,
  user: "root",
  role = ["controlplane"],
  ssh_key = "",
  ssh_key_path = "",
  taints= [{key = "a", value= "b", effect = "c"}] }]

ssh_agent_auth = true

ingress-enabled = false
cluster_name = "workboards_hydra"

extra_binds = ["/mnt:/mnt"]
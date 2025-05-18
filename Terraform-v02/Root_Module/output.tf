output "aks_config" {
  value     = module.AKS.kube_config
  sensitive = true
}

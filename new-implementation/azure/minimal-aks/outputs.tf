output "client_key" {
  value = module.aks.client_key
}

output "client_certificate" {
  value = module.aks.client_certificate
}

output "cluster_ca_certificate" {
  value = module.aks.cluster_ca_certificate
}

output "host" {
  value = module.aks.host
}

output "username" {
  value = module.aks.username
}

output "password" {
  value = module.aks.password
}

// output "raw_kube_config" {
//   value = module.kubernetes.raw_kube_config
// }

output "node_resource_group" {
  value = module.aks.node_resource_group
}

output "location" {
  value = module.aks.location
}



// output "master-url" {
//   value = "${module.eks-public.master-url}"
// }
// 
// output "cluster-auth-config" {
//   value = "${module.eks-public.cluster-auth-config}"
// }
// 
// output "cluster-config" {
//   value = "${module.eks-public.cluster-config}"
// }
// 
// output "vpc_id" {
//   value = "${module.eks-public.vpc_id}"
// }
// output "vpc_public_subnets" {
//   value = "${module.eks-public.vpc_public_subnets}"
// }
// 
// output "vpc_database_subnets" {
//   value = "${module.eks-public.vpc_database_subnets}"
// }
// 
// output "worker_node_security_group_id" {
//   value = "${module.eks-public.worker_node_security_group_id}"
// }
// 
// 
// 
// 

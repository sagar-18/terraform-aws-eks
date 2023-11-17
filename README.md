# AWS EKS Terraform module


<br>
This module simplifies the deployment of EKS clusters with dual stack mode for Cluster IP family like IPv6 and IPv4, allowing users to quickly create and manage a production-grade Kubernetes cluster on AWS. The module is highly configurable, allowing users to customize various aspects of the EKS cluster, such as the Kubernetes version, worker node instance type, number of worker nodes, and now with added support for EKS version 1.27.
<br>
●   A new feature simplifies cluster setup by allowing users to create a default node group if the <strong>default_addon_enabled</strong> value is set. The module now integrates default addons like <strong>CoreDNS</strong>, <strong>Kube-proxy</strong>, <strong>VPC CNI</strong>, and <strong>EBS CSI Driver</strong>, ensuring essential components are included for optimal performance and functionality from the start.  <br>
<br>


## Usage Example

```hcl
module "eks" {
  source                               = "saturnops/eks/aws"
  name                                 = "skaf"
  vpc_id                               = "vpc-xyz425342176"
  environment                          = "prod"
  kms_key_arn                          = "arn:aws:kms:us-east-2:222222222222:key/kms_key_arn"
  cluster_version                      = "1.27"
  cluster_log_types                    = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  private_subnet_ids                   = ["subnet-abc123" , "subnet-xyz12324"]
  default_addon_enabled                = true
  cluster_log_retention_in_days        = 30
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  create_aws_auth_configmap            = true
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::222222222222:role/service-role"
      username = "username"
      groups   = ["system:masters"]
    }
  ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::222222222222:user/aws-user"
      username = "aws-user"
      groups   = ["system:masters"]
    },
  ]
  additional_rules = {
    ingress_port_mgmt_tcp = {
      description = "mgmt vpc cidr"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["10.10.0.0/16"]
    }
  }
}

module "managed_node_group_production" {
  source                 = "saturnops/eks/aws//modules/managed-nodegroup"
  depends_on             = [module.eks]
  name                   = "Infra"
  min_size               = 1
  max_size               = 3
  desired_size           = 1
  subnet_ids             = ["subnet-abc123"]
  environment            = "prod"
  kms_key_arn            = "arn:aws:kms:us-east-2:222222222222:key/kms_key_arn"
  capacity_type          = "ON_DEMAND"
  instance_types         = ["t3a.large", "t2.large", "t2.xlarge", "t3.large", "m5.large"]
  kms_policy_arn         = module.eks.kms_policy_arn
  eks_cluster_name       = module.eks.cluster_name
  worker_iam_role_name   = module.eks.worker_iam_role_name
  default_addon_enabled  = true
  eks_nodes_keypair_name = "key-pair-name"
  k8s_labels = {
    "Infra-Services" = "true"
  }
  tags = {
    Name = "prod-cluster"
  }
}

```
Refer [examples](https://github.com/saturnops/terraform-aws-eks/tree/main/examples/complete) for more details.

## IAM Permissions
The required IAM permissions to create resources from this module can be found [here](https://github.com/saturnops/terraform-aws-eks/blob/main/IAM.md)




## Secure Configuration


In this module, we have implemented the followingchecks for EKS:

| Benchmark | Description | Status |
|--------|---------------|----------|
| Ensure EKS Control Plane Audit Logging is enabled for all log types | Control plane logging enabled and correctly configured for EKS cluster | &#x2714; |
| Ensure Kubernetes Secrets are encrypted using Customer Master Keys (CMKs) | Encryption for Kubernetes secrets is configured for EKS cluster | &#x2714; |
| Ensure EKS Clusters are created with Private Endpoint Enabled and Public Access Disabled | Cluster endpoint access is private for EKS cluster  | &#x2714; |
| Restrict Access to the EKS Control Plane Endpoint | Cluster control plane access is restricted for EKS cluster | &#x2714; |


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.47 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_addon"></a> [eks\_addon](#module\_eks\_addon) | terraform-aws-modules/eks/aws | 19.15.2 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 19.15.2 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_node_group.default_ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_policy.eks_cni_ipv6_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.kubernetes_pvc_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.node_autoscaler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.SSMManagedInstanceCore_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_kms_cluster_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_kms_worker_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_worker_ecr_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_worker_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_autoscaler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.eks_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_ami.launch_template_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy.SSMManagedInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [template_file.launch_template_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment identifier for the EKS cluster, such as dev, qa, prod, etc. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Specify the name of the EKS cluster. | `string` | `""` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Specifies the Kubernetes version (major.minor) to use for the EKS cluster. | `string` | `""` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Whether the Amazon EKS public API server endpoint is enabled or not. | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | CIDR blocks that can access the Amazon EKS public API server endpoint. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the EKS cluster will be deployed. | `string` | `""` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of the KMS key used to encrypt EKS resources. | `string` | `""` | no |
| <a name="input_cluster_log_types"></a> [cluster\_log\_types](#input\_cluster\_log\_types) | A list of desired control plane logs to enable for the EKS cluster. Valid values include: api, audit, authenticator, controllerManager, scheduler. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_cluster_log_retention_in_days"></a> [cluster\_log\_retention\_in\_days](#input\_cluster\_log\_retention\_in\_days) | Retention period for EKS cluster logs in days. Default is set to 90 days. | `number` | `90` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnets of the VPC which can be used by EKS | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Controls if a KMS key for cluster encryption should be created | `bool` | `false` | no |
| <a name="input_additional_rules"></a> [additional\_rules](#input\_additional\_rules) | List of additional security group rules to add to the cluster security group created. | `any` | `{}` | no |
| <a name="input_create_aws_auth_configmap"></a> [create\_aws\_auth\_configmap](#input\_create\_aws\_auth\_configmap) | Determines whether to manage the aws-auth configmap | `bool` | `false` | no |
| <a name="input_aws_auth_users"></a> [aws\_auth\_users](#input\_aws\_auth\_users) | List of user maps to add to the aws-auth configmap | `any` | `[]` | no |
| <a name="input_aws_auth_roles"></a> [aws\_auth\_roles](#input\_aws\_auth\_roles) | List of role maps to add to the aws-auth configmap | `list(any)` | `[]` | no |
| <a name="input_ipv6_enabled"></a> [ipv6\_enabled](#input\_ipv6\_enabled) | Enable cluster IP family as Ipv6 | `bool` | `false` | no |
| <a name="input_default_addon_enabled"></a> [default\_addon\_enabled](#input\_default\_addon\_enabled) | Enable deafult addons(vpc-cni, ebs-csi) at the time of cluster creation | `bool` | `false` | no |
| <a name="input_eks_nodes_keypair_name"></a> [eks\_nodes\_keypair\_name](#input\_eks\_nodes\_keypair\_name) | The public key to be used for EKS cluster worker nodes. | `string` | `""` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster | `string` | `""` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | The instance types to be used for the EKS node group (e.g., t2.medium). | `list(any)` | <pre>[<br>  "t3a.medium"<br>]</pre> | no |
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | The capacity type for the EKS node group (ON\_DEMAND or SPOT). | `string` | `"ON_DEMAND"` | no |
| <a name="input_image_high_threshold_percent"></a> [image\_high\_threshold\_percent](#input\_image\_high\_threshold\_percent) | The percentage of disk usage at which garbage collection should be triggered. | `number` | `60` | no |
| <a name="input_image_low_threshold_percent"></a> [image\_low\_threshold\_percent](#input\_image\_low\_threshold\_percent) | The percentage of disk usage at which garbage collection took place. | `number` | `40` | no |
| <a name="input_eventRecordQPS"></a> [eventRecordQPS](#input\_eventRecordQPS) | The maximum number of events created per second. | `number` | `5` | no |
| <a name="input_kms_policy_arn"></a> [kms\_policy\_arn](#input\_kms\_policy\_arn) | The KMS policy ARN used for encrypting Kubernetes PVC. | `string` | `""` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Set to true to enable network interface for launch template. | `bool` | `false` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Specify whether to enable monitoring for nodes. | `bool` | `true` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum number of nodes for the node group. | `string` | `"1"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum number of nodes that can be added to the node group. | `string` | `"3"` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | The desired number of nodes for the node group. | `string` | `"1"` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | The type of EBS volume for nodes. | `string` | `"50"` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | Specify the type of EBS volume for nodes. | `string` | `"gp3"` | no |
| <a name="input_ebs_encrypted"></a> [ebs\_encrypted](#input\_ebs\_encrypted) | Specify whether to encrypt the EBS volume for nodes. | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The IDs of the subnets in the VPC that can be used by EKS. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the node group. | `any` | `{}` | no |
| <a name="input_k8s_labels"></a> [k8s\_labels](#input\_k8s\_labels) | Labels to be applied to the Kubernetes node groups. | `map(any)` | `{}` | no |
| <a name="input_worker_iam_role_arn"></a> [worker\_iam\_role\_arn](#input\_worker\_iam\_role\_arn) | The ARN of the worker role for EKS. | `string` | `""` | no |
| <a name="input_worker_iam_role_name"></a> [worker\_iam\_role\_name](#input\_worker\_iam\_role\_name) | The name of the EKS Worker IAM role. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the Kubernetes cluster. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint URL for the EKS control plane. |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | Security group IDs that are attached to the control plane of the EKS cluster. |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of the EKS Cluster. |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | URL of the OpenID Connect identity provider on the EKS cluster. |
| <a name="output_worker_iam_role_arn"></a> [worker\_iam\_role\_arn](#output\_worker\_iam\_role\_arn) | ARN of the IAM role assigned to the EKS worker nodes. |
| <a name="output_worker_iam_role_name"></a> [worker\_iam\_role\_name](#output\_worker\_iam\_role\_name) | Name of the IAM role assigned to the EKS worker nodes. |
| <a name="output_kms_policy_arn"></a> [kms\_policy\_arn](#output\_kms\_policy\_arn) | ARN of the KMS policy that is used by the EKS cluster. |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64 encoded certificate data required to communicate with the cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->






##        





Please give our GitHub repository a ⭐️ to show your support and increase its visibility.






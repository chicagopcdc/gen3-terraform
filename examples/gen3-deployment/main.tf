provider "aws" {

  region = "us-east-1"

  default_tags {
    tags = local.default_tags
  }
}

data "aws_caller_identity" "current" {}

terraform {
  backend "s3" {
    # The bucket to store the Terraform state file in.
    bucket = "cdis-state-ac009732147623-gen3"
    # The location of the Terraform state file within the bucket. Notice the bucket has to exist beforehand.
    key = "gen3-commons/terraform1.tfstate" # Update to represent your environment
    encrypt = "true"
    # The region where the S3 bucket is located.
    region = "us-east-1"
  }
}

locals {
  # This will be the name of the VPC, and will be used to identify most resources created within the module
  vpc_name                      = "pcdc-dev-1"
  # The account number where the resources will be created in. This should be populated automatically through the AWS user/role you are using to run this module.
  account_number                = data.aws_caller_identity.current.account_id
  # The AWS region where the resources will be created in
  aws_region                    = "us-east-1"
  # The namespace your gen3 deployment will use. Default is good for first time deployments.
  ## If you want another deployment in the same cluster, copy paste the gen3 module block, create a new namespace local variable or manually update the namespace within the second instance of the module.
  kubernetes_namespace          = "default"
  # The availability zones where the resources will be created in. There should be 3 availability zones
  ## You can run aws ec2 describe-availability-zones --region <region> to get the list of availability zones in your region.
  availability_zones            = ["us-east-1a", "us-east-1c", "us-east-1d"]
  # The hostname for your gen3 deployment. If you are creating another instance of the gen3 module set the hostname in it accordingly
  hostname                      = "portal-dev.pedscommons.org"
  # Service linked roles can only be created once per account. If you see an error that it is already created, set this to false.
  es_linked_role                = false
  # The arn of the certificate in ACM
  revproxy_arn                  = "arn:aws:acm:us-east-1:009732147623:certificate/8f00318a-90dd-4601-9059-244274cedd08"
  # Whether or not to create users/buckets needed for useryaml gitops management.
  create_gitops_infra           = true
  # The name of the S3 bucket where the user.yaml file will be stored. Notice this will be created by terraform, so you don't need to create it beforehand.
  user_yaml_bucket_name = "<update with your user yaml bucket name>"
  # Your ssh key name to access the nodes in the EKS cluster
  ssh_key                = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4nQGkUh4jAiyLbTQ0/sxJo6T7sMYePHWn0RWwbtIhoD6WJ9CzzWYVvkFB7mvl38WZIoxPNCTU2ZMNE+V2Be6UfbB/69BimXBiFQEhGBdn0YnaMOnyuK1+2jz9/Z3MQic7Nap3Vnkm8AcGAgb8HToQHggrfJjsgLPaW/0Lf7qch6OLT5XtwsrwTq/NSebf50Hi6Kvso5pH+oZjkLCVHfaWpXspPILP1BSaIPAGDUU2j7cPJMEDzBe9flRl0DZuUolWA2H3lDXTnGgfH0T/jyMaL6raGkI4EHKBm0fKR4OPQo7jwm9aTGRE9sf4n0oqK49N3xYCE5+Q0KbJrp5KQ5XJ Luca"
  # Set any tags you want to apply to all resources created by this module.
  default_tags = {
    Environment = local.vpc_name
  }

}

module "commons" {
  #source = "git::github.com/uc-cdis/gen3-terraform.git//tf_files/aws/commons?ref=3c4d2c810953e5d6fe0bd2a670b8c5f481fb5e68"
  source = "git::github.com/chicagopcdc/gen3-terraform.git//tf_files/aws/commons?ref=a898f0896f13d5372da18d1a4ea9e8f5e8bf23cc"

  aurora_snapshot_identifier     = "rds:pcdc-dev-aurora-cluster-2025-11-13-02-01"
  vpc_name                       = local.vpc_name
  vpc_cidr_block                 = "10.10.0.0/20"
  aws_region                     = local.aws_region
  hostname                       = local.hostname
  kube_ssh_key                   = local.ssh_key
  ami_account_id                 = "amazon"
  squid_image_search_criteria    = "amzn2-ami-hvm-*-x86_64-gp2"
  eks_version			 = "1.33"
  ha-squid_instance_drive_size   = 30
  ha_squid_single_instance       = true
  deploy_ha_squid                = true
  deploy_sheepdog_db             = false
  deploy_fence_db                = false
  deploy_indexd_db               = false
  network_expansion              = true
  users_policy                   = "dev"
  availability_zones             = local.availability_zones
  es_version                     = "7.10"
  es_linked_role                 = local.es_linked_role
  deploy_aurora                  = true
  deploy_rds                     = false
  use_asg                        = false
  use_karpenter                  = true
  deploy_karpenter_in_k8s        = true
  send_logs_to_csoc              = false
  secrets_manager_enabled        = true
  force_delete_bucket            = true
  enable_vpc_endpoints           = false
  cluster_engine_version         = "13"
}

module "gen3" {
  #source = "git::github.com/uc-cdis/gen3-terraform.git//tf_files/gen3?ref=9938e841ffcbc81171a2eb64431db8a7a0fc28eb"
  source = "git::github.com/chicagopcdc/gen3-terraform.git//tf_files/gen3?ref=a898f0896f13d5372da18d1a4ea9e8f5e8bf23cc"
  vpc_name                 = local.vpc_name
  aurora_username          = module.commons.aurora_cluster_master_username
  aurora_password          = module.commons.aurora_cluster_master_password
  aurora_hostname          = module.commons.aurora_cluster_writer_endpoint
  dictionary_url           = "https://s3.amazonaws.com/dictionary-artifacts/datadictionary/develop/schema.json"
  es_endpoint              = module.commons.es_endpoint
  hostname                 = local.hostname
  namespace		   = "pcdcdev1"
  cluster_endpoint         = module.commons.eks_cluster_endpoint
  cluster_ca_cert          = module.commons.eks_cluster_ca_cert
  cluster_name             = module.commons.eks_cluster_name
  oidc_provider_arn        = module.commons.eks_oidc_arn
  fence_access_key         = module.commons.fence-bot_user_id
  fence_secret_key         = module.commons.fence-bot_user_secret
  upload_bucket            = module.commons.data-bucket_name
  amanuensis_access_key    = module.commons.amanuensis-bot_user_id
  amanuensis_secret_key    = module.commons.amanuensis-bot_user_secret
  data_release_bucket      = module.commons.data-bucket_name
  revproxy_arn             = local.revproxy_arn
  useryaml_s3_path         = "s3://${local.user_yaml_bucket_name}/dev/user.yaml"
  deploy_external_secrets  = true
  deploy_gen3              = false
  create_dbs               = false

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }

  depends_on = [
    module.commons,
  ]
}

module "gen3_staging" {
  source = "git::github.com/uc-cdis/gen3-terraform.git//tf_files/gen3?ref=9938e841ffcbc81171a2eb64431db8a7a0fc28eb"
  vpc_name                 = local.vpc_name
  aurora_username          = module.commons.aurora_cluster_master_username
  aurora_password          = module.commons.aurora_cluster_master_password
  aurora_hostname          = module.commons.aurora_cluster_writer_endpoint
  dictionary_url           = "https://s3.amazonaws.com/dictionary-artifacts/datadictionary/develop/schema.json"
  es_endpoint              = module.commons.es_endpoint
  hostname                 = "portal-staging.pedscommons.org"
  namespace                = "staging"
  cluster_endpoint         = module.commons.eks_cluster_endpoint
  cluster_ca_cert          = module.commons.eks_cluster_ca_cert
  cluster_name             = module.commons.eks_cluster_name
  oidc_provider_arn        = module.commons.eks_oidc_arn
  fence_access_key         = module.commons.fence-bot_user_id
  fence_secret_key         = module.commons.fence-bot_user_secret
  upload_bucket            = module.commons.data-bucket_name
  revproxy_arn             = "arn:aws:acm:us-east-1:009732147623:certificate/c76213f3-2ce1-4a5c-a947-9465fdfbd248"
  useryaml_s3_path         = "s3://${local.user_yaml_bucket_name}/dev/user.yaml"
  deploy_external_secrets  = true
  deploy_gen3              = false
  create_dbs               = false

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }

  depends_on = [
    module.commons,
  ]
}

module "gen3" {
  source = "../../../../tf_files/gen3"

  vpc_name                   = var.vpc_name
  aurora_username            = var.aurora_username
  aurora_hostname            = var.aurora_hostname
  aurora_password            = var.aurora_password
  dictionary_url             = var.dictionary_url
  es_endpoint                = var.es_endpoint
  hostname                   = var.hostname
  cluster_endpoint           = var.cluster_endpoint
  cluster_ca_cert            = var.cluster_ca_cert
  cluster_name               = var.cluster_name
  oidc_provider_arn          = var.oidc_provider_arn
  fence_access_key           = var.fence_access_key
  fence_secret_key           = var.fence_secret_key
  upload_bucket              = var.upload_bucket
  revproxy_arn               = var.revproxy_arn
  deploy_external_secrets    = var.deploy_external_secrets
  useryaml_s3_path           = var.useryaml_s3_path
  deploy_gen3                = var.deploy_gen3
  create_dbs                 = var.create_dbs
  cognito_discovery_url      = var.cognito_discovery_url
  cognito_client_id          = var.cognito_client_id
  cognito_client_secret      = var.cognito_client_secret
  audit_enabled              = var.audit_enabled
  indexd_enabled             = var.indexd_enabled
  metadata_enabled           = var.metadata_enabled
  ambassador_enabled         = var.ambassador_enabled
  guppy_enabled              = var.guppy_enabled
  hatchery_enabled           = var.hatchery_enabled
  netpolicy_enabled          = var.netpolicy_enabled
  tier_access_limit          = var.tier_access_limit
  usersync_enabled           = var.usersync_enabled


}

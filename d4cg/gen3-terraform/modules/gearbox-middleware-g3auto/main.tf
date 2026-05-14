resource "aws_secretsmanager_secret" "gearbox_middleware_g3auto" {
  name = "${var.vpc_name}-default-gearbox-middleware-g3auto"
}

resource "aws_secretsmanager_secret_version" "gearbox_middleware_g3auto" {
  secret_id     = aws_secretsmanager_secret.gearbox_middleware_g3auto.id
  secret_string = var.gearbox_middleware_g3auto_config_path != "" ? file(var.gearbox_middleware_g3auto_config_path) : templatefile("${path.module}/templates/gearbox-middleware-g3auto.tftpl", {
    gearbox_middleware_g3auto_access_key = var.gearbox_middleware_g3auto_access_key
    gearbox_middleware_g3auto_secret_key = var.gearbox_middleware_g3auto_secret_key
  })
}

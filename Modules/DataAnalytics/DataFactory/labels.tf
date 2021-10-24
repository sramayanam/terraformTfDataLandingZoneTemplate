module "labels" {
  source      = "../../Nulllabel"
  name        = var.name
  context     = var.labels_context
  environment = var.environment

  names = flatten([
    join("-", compact([var.name, "adf"])),
    keys(var.alerts)
  ])

  tags = {
    terraform-module = "datafactory"
  }
}

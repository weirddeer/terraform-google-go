resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "functions_bucket" {
  name                        = "${random_id.default.hex}-${var.project}-${var.service}-${var.stage}-functions"
  location                    = var.region
  uniform_bucket_level_access = true
}

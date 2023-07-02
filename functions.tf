locals {
  root = "../functions"
}

// get a list of all folders in the functions directory only go one level deep
locals {
  functions = fileset(local.root, "*/*")
  prefix    = "${var.service}-${var.stage}-"
}

// split on the first slash to get the function name
locals {
  function_dirs = [for f in local.functions : "../functions/${split("/", f)[0]}"]
}

// loop over function dirs and zip them
resource "null_resource" "function_archive" {
  for_each = toset(local.function_dirs)

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "cd ${each.value} && zip -r ../${split("/functions", each.value)[1]}.zip ."
  }
}

// upload the zips to the bucket
resource "google_storage_bucket_object" "function_deploy_archive" {
  for_each = fileset(local.root, "*.zip")

  name   = "${local.prefix}-${each.value}"
  bucket = google_storage_bucket.functions_bucket.name
  source = "${local.root}/${each.value}"
}

// create the cloud functions
resource "google_cloudfunctions_function" "functions_deploy" {
  for_each = fileset(local.root, "*.zip")

  name                  = "${local.prefix}-${element(split(".", each.value), 0)}"
  description           = "Cloud Function ${each.value}"
  runtime               = "go120"
  source_archive_bucket = google_storage_bucket.functions_bucket.name
  source_archive_object = each.value
  entry_point           = element(split(".", each.value), 0)
  available_memory_mb   = 128
  trigger_http          = true
}

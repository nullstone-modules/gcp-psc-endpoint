data "google_client_config" "this" {}
data "google_project" "this" {}

locals {
  project_id = data.google_project.this.project_id
  region     = data.google_client_config.this.region
}

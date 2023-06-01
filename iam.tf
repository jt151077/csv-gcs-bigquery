/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


# Service account for the running Cloud Run
resource "google_service_account" "run_sa" {
  depends_on = [
    google_project_service.gcp_services
  ]
  project      = local.project_id
  account_id   = "run-sa"
  display_name = "Service Account Cloud Run"
}

resource "google_project_iam_member" "run_sa_invoker" {
  depends_on = [
    google_project_service.gcp_services
  ]

  project = local.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}

resource "google_project_iam_member" "run_sa_eventreceiver" {
  depends_on = [
    google_project_service.gcp_services
  ]

  project = local.project_id
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}

resource "google_project_iam_member" "run_artifactregistry_reader" {
  depends_on = [
    google_project_service.gcp_services
  ]
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}

resource "google_project_iam_member" "run_logs_writer" {
  depends_on = [
    google_project_service.gcp_services
  ]
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}


# Service account for the CloudBuild trigger listening to github
resource "google_service_account" "cloudbuild_service_account" {
  depends_on = [
    google_project_service.gcp_services
  ]
  project    = local.project_id
  account_id = "deployer-sa"
}

resource "google_project_iam_member" "act_as" {
  depends_on = [
    google_project_service.gcp_services
  ]
  project = local.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "logs_writer" {
  depends_on = [
    google_project_service.gcp_services
  ]
  project = local.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "storage_admin" {
  depends_on = [
    google_project_service.gcp_services
  ]
  project = local.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "serviceusage_serviceUsageViewer" {
  depends_on = [
    google_project_service.gcp_services
  ]
  project = local.project_id
  role    = "roles/serviceusage.serviceUsageViewer"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "artifactregistry_reader" {
  depends_on = [
    google_project_service.gcp_services
  ]
  project = local.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "containeranalysis_occurrences_viewer" {
  depends_on = [
    google_project_service.gcp_services
  ]
  project = local.project_id
  role    = "roles/containeranalysis.occurrences.viewer"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

# Service account for the CloudBuild trigger listening to github
resource "google_project_iam_member" "storage_pubsub_publisher" {
  depends_on = [
    google_project_service.gcp_services
  ]
  project = local.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:service-${local.project_number}@gs-project-accounts.iam.gserviceaccount.com"
}

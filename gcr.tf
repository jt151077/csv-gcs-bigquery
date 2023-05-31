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


resource "google_artifact_registry_repository" "run-repo" {
  depends_on = [
    google_project_service.gcp_services
  ]

  provider      = google-beta
  project       = local.project_id
  location      = local.project_default_region
  repository_id = "run-image"
  description   = "Docker repository"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "repo-iam" {
  depends_on = [
    google_project_service.gcp_services
  ]

  provider   = google-beta
  project    = local.project_id
  location   = google_artifact_registry_repository.run-repo.location
  repository = google_artifact_registry_repository.run-repo.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}
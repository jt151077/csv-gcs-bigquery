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


resource "google_eventarc_trigger" "trigger-load-csv" {
  depends_on = [
    google_project_service.gcp_services
  ]

  provider = google-beta
  name     = "trigger-load-csv"
  location = local.project_default_region
  project  = local.project_id

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.storage.object.v1.finalized"
  }
  matching_criteria {
    attribute = "bucket"
    value     = google_storage_bucket.csv_bucket.name
  }

  destination {
    cloud_run_service {
      service = google_cloud_run_service.run.name
      region  = google_cloud_run_service.run.location
    }
  }
  service_account = google_service_account.run_sa.email

}

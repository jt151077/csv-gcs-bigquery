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

resource "google_bigquery_dataset" "data_raw" {
  depends_on = [
    google_project_service.gcp_services
  ]
  project       = local.project_id
  dataset_id    = "data_raw"
  friendly_name = "data_raw"
  location      = local.project_default_region
}

resource "google_bigquery_table" "load_csv_data" {
  depends_on = [
    google_bigquery_dataset.data_raw
  ]
  project             = local.project_id
  dataset_id          = google_bigquery_dataset.data_raw.dataset_id
  table_id            = "loadCsvData"
  deletion_protection = false

  schema = <<EOF
[
  {
    "description": "",
    "type": "STRING",
    "name": "firstname",
    "mode": "NULLABLE"
  },
  {
    "description": "",
    "type": "STRING",
    "name": "lastname",
    "mode": "NULLABLE"
  }
]
EOF
}
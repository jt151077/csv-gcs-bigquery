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


resource "google_cloud_run_service" "run" {
  name     = "load-csv"
  project  = local.project_id
  location = local.project_default_region

  template {
    spec {
      service_account_name = google_service_account.run_sa.email
      containers {
        image = "europe-west1-docker.pkg.dev/jeremy-tkuhscmw/run-image/load-csv@sha256:b379f006b2169df8fd48b586800868552a178e9bc25ab3cd3d0ccb71de8a925f"

        /* env {
          name  = "MSG_SRC"
          value = "cloudrun"
        }
        env {
          name  = "POSTGRES_PASSWORD"
          value = data.google_kms_secret.sql_user_password.plaintext
        }
        env {
          name  = "POSTGRES_USER"
          value = var.db_user
        }*/
      }
    }
  }
}
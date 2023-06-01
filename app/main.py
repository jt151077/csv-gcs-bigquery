# Copyright 2020 Google, LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START eventarc_audit_storage_server]

import os
import pandas as pd
from io import StringIO
from google.cloud import storage

from flask import Flask, request


app = Flask(__name__)
# [END eventarc_audit_storage_server]


def read_csv_from_gcs(bucket_name, file_path):
  # Create a GCS client
  storage_client = storage.Client()

  # Get the bucket and blob objects
  bucket = storage_client.get_bucket(bucket_name)
  blob = bucket.blob(file_path)

  # Download the contents of the blob as a string
  csv_data = blob.download_as_text()

  # Read the CSV data into a Pandas DataFrame
  dataframe = pd.read_csv(StringIO(csv_data))
  return dataframe



# [START eventarc_audit_storage_handler]
@app.route('/', methods=['POST'])
def index():
    # Gets the GCS bucket name from the CloudEvent header
    # Example: "storage.googleapis.com/projects/_/buckets/my-bucket"
    bucket = request.headers.get('Ce-Bucket')
    fil = (request.headers.get('Ce-Subject')).split('/')[1]

    print(f"bucket: {bucket}")
    print(f"fil: {fil}")


    # Read the CSV file and load it into a DataFrame
    df = read_csv_from_gcs(bucket, fil)

    # Print the DataFrame
    print(df)

    print(f"Detected change in Cloud Storage bucket: {bucket}")
    return (f"Detected change in Cloud Storage bucket: {bucket}", 200)
# [END eventarc_audit_storage_handler]


# [START eventarc_audit_storage_server]
if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
# [END eventarc_audit_storage_server]
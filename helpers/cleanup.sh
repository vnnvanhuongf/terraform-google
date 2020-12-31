#!/bin/bash
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


PROJECT_ID="$1"
ORG_ID="$(gcloud projects describe ${PROJECT_ID} --flatten=parent.id | grep -Eo "\d+")"
SERVICE_ACCOUNT_ID="$2"
STAGING_DIR="$(echo ${PWD}/staging)"

echo "...removing permissions..."

gcloud organizations remove-iam-policy-binding ${ORG_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/resourcemanager.organizationAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/compute.instanceAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/compute.networkViewer" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/compute.securityAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/deploymentmanager.editor" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/serviceusage.serviceUsageAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/iam.serviceAccountAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/storage.admin" \
    --user-output-enabled false

gcloud iam service-accounts delete ${SERVICE_ACCOUNT_ID} \
    --quiet

rm -rf "staging"

echo "...done..."



#!/usr/bin/env bash

# Copyright 2021 METRO Digital GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# do not allow unset variables
set -u
# exit script on any error
set -e

function check_program() {
  set +e # next command my fail - allow failure
  PRG="$(command -v "$1" 2>/dev/null)"
  set -e # exit script on any error again
  if [ -z "$PRG" ] ; then
    echo "ERROR - \"$1\" not found" >&2
    exit 1
  fi
}

check_program jq
check_program gcloud

eval "$(jq -r '@sh "PROJECT_ID=\(.project_id)"')"

# List active roles in project iam policy
gcloud projects get-iam-policy "$PROJECT_ID" --flatten "bindings[].role" --format "json" | jq -c '{roles: . | join(",")}'
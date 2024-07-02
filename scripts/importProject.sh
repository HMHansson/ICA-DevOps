#!/bin/bash
#############################################################################
#                                                                           #
## importProject.sh : Import all assets for a project                       #
#                                                                           #
#############################################################################
wmio_endpoint=$1
wmio_user=$2
wmio_password=$3
wmio_projectName=$4
github_home=$5

if [ -z "$wmio_endpoint" ]; then
  echo "Missing template parameter wmio_endpoint"
  exit 1
fi

if [ -z "$wmio_user" ]; then
  echo "Missing template parameter wmio_user"
  exit 1
fi

if [ -z "$wmio_password" ]; then
  echo "Missing template parameter wmio_password"
  exit 1
fi

if [ -z "$wmio_projectName" ]; then
  echo "Missing template parameter wmio_projectName"
  exit 1
fi

if [ -z "$github_home" ]; then
  echo "Missing template parameter github_home"
  exit 1
fi

urlDecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

# ----------------------------------------------------------
# Main
# ----------------------------------------------------------
PROJECT_ASSETS_DIR="${github_home}/assets"
cd "${PROJECT_ASSETS_DIR}"

# Generate filename
project_file="$(dirname "$github_home")"  # Current path
project_file=${project_file%%+(/)}        # Remove trailing ///
project_file=${project_file##*/}          # Get parent path name
project_file=${project_file}.zip          # Add zip extension
echo "Project ZIP File: ${project_file}"
ls -ltr

PROJECT_NAME="$(urlDecode "${wmio_projectName}")"
echo "Importing project ${PROJECT_NAME} ..."

PROJECT_URL=${wmio_endpoint}/apis/v1/rest/project-import

importResponse=$(curl --location --request POST ${PROJECT_URL} \
    --header 'Accept: application/json' \
    --form 'project=@'"./${project_file}" \
    -u ${wmio_user}:${wmio_password})

echo $importResponse
respName=$(echo "$importResponse" | jq '.output.message // empty')
if [ -z "$respName" ]; then
  echo "Import failed:" ${importResponse}
  exit 1
else
  echo "Import Succeeded:" ${importResponse}
fi
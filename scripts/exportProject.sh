#!/bin/bash
#############################################################################
##                                                                          #
## exportProject.sh : Export all assets for a project                       #
##                                                                          #
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

# ----------------------------------------------------------
# Main
# ----------------------------------------------------------
PROJECT_URL=${wmio_endpoint}/apis/v1/rest/projects/${wmio_projectName}/export

wmioRequest=$(curl  --location --request POST ${PROJECT_URL} \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  -u ${wmio_user}:${wmio_password})
downloadURL=$(echo "$wmioRequest" | jq -r '.output.download_link')
    
regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'

if [[ $downloadURL =~ $regex ]]; then 
  echo "Valid Download link generated:"${downloadURL}
else
  echo "Invalid Download link generated:" ${linkJson}
  exit 1
fi

# -----------------------------------------------------------------------------
# Export project to local file (based on a more static github project name)
# -----------------------------------------------------------------------------
project_file="$(dirname "$github_home")"  # Current path
project_file=${project_file%%+(/)}        # Remove trailing ///
project_file=${project_file##*/}          # Get parent path name
project_file=${project_file}.zip          # Add zip extension
echo "Project ZIP File: ${project_file}"
exportRequest=$(curl --location --request GET "${downloadURL}" --output ${project_file})

FILE=./${project_file}
if [ -f "$FILE" ]; then
    echo "Download succeeded:" ls -ltr ./${project_file}
else
    echo "Download failed:"${exportRequest}
fi

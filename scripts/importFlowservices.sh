#!/bin/bash
#############################################################################
#                                                                           #
## importFlowservices.sh : Import all flow services for a project           #
#                                                                           #
#############################################################################
wmio_endpoint=$1
wmio_user=$2
wmio_password=$3
wmio_projectName=$4

function importFlowservice() {
  wmio_endpoint=$1
  wmio_user=$2
  wmio_password=$3
  wmio_projectName=$4
  zipFile=$5

  IMPORT_URL=${wmio_endpoint}/apis/v1/rest/projects/${wmio_projectName}/flow-import

  importResponse=$(curl --location --request POST ${IMPORT_URL} --header 'Content-Type: multipart/form-data' \
      --header 'Accept: application/json' --form "recipe=@"./${zipFile} --form overwrite=true -u ${wmio_user}:${wmio_password})

  respName=$(echo "$importResponse" | jq '.output.name // empty')
  if [ -z "$respName" ]; then
    echo "Import failed:" ${importResponse}
    exit 1
  else
    echo "Import Succeeded:" ${importResponse}
  fi

}

# ----------------------------------------------------------
# Main
# ----------------------------------------------------------
echo "Retrieving all Flowservices from project directory ..."
for filename in ./*.zip; do
  importFlowservice ${wmio_endpoint} ${wmio_user} ${wmio_password} ${wmio_projectName} ${filename} 
done
set +x
#!/bin/bash
#############################################################################
##                                                                          #
## exportFlowservices.sh : Export all flow services for a project           #
##                                                                          #
#############################################################################
wmio_endpoint=$1
wmio_user=$2
wmio_password=$3
wmio_projectName=$4

function exportFlowservice(){
  wmio_endpoint=$1
  wmio_user=$2
  wmio_password=$3
  wmio_projectName=$4
  assetId=$5
 
  # ----------------------------
  # Get Download URL for this asset
  # ----------------------------
  EXPORT_URL=${wmio_endpoint}/apis/v1/rest/projects/${wmio_projectName}/flows/${assetId}/export
  echo "Flow service export:" ${EXPORT_URL}
  linkJson=$(curl  --location --request POST ${EXPORT_URL} --header 'Content-Type: application/json' --header 'Accept: application/json' -u ${wmio_user}:${wmio_password})
  downloadURL=$(echo "$linkJson" | jq -r '.output.download_link')
    
  regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
  if [[ $downloadURL =~ $regex ]]; then 
    echo "Valid Download link generated:"${downloadURL}
  else
    echo "Invalid Download link generated:" ${linkJson}
    exit 1
  fi

  # ----------------------------
  # Export asset to local file
  # ----------------------------
  exportRequest=$(curl --location --request GET "${downloadURL}" --output ${assetId}.zip)

  FILE=./${assetId}.zip
  if [ -f "$FILE" ]; then
      echo "Download succeeded:" ls -ltr ./${assetId}.zip
  else
      echo "Download failed:"${exportRequest}
  fi
}  

# ----------------------------------------------------------
# Main
# ----------------------------------------------------------
echo "Retrieving all Flowservices ..."
PROJECT_LIST_URL=${wmio_endpoint}/apis/v1/rest/projects/${wmio_projectName}/assets

projectListJson=$(curl  --location --request GET ${PROJECT_LIST_URL} \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  -u ${wmio_user}:${wmio_password})
  
# Exporing Workflows
for item in $(jq  -c -r '.output.flows[]' <<< "$projectListJson"); do
  echo Workflow Loop: $item
  exportFlowservice ${wmio_endpoint} ${wmio_user} ${wmio_password} ${wmio_projectName} $item
done


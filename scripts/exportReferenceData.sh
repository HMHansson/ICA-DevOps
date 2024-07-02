#!/bin/bash
#############################################################################
##                                                                          #
## exportReferenceData.sh : Export all reference data for a project         #
##                                                                          #
#############################################################################
wmio_endpoint=$1
wmio_user=$2
wmio_password=$3
wmio_projectName=$4

function exportReferenceData(){
  wmio_endpoint=$1
  wmio_user=$2
  wmio_password=$3
  wmio_projectName=$4
  assetId=$5
 
  # ----------------------------
  # Get Reference Data Json
  # ----------------------------
  EXPORT_URL=${wmio_endpoint}/apis/v1/rest/projects/${wmio_projectName}/referencedata/${assetId}
  echo "Reference Data URL:" ${EXPORT_URL}
  refDataJson=$(curl  --location --request GET ${EXPORT_URL} --header 'Content-Type: application/json' --header 'Accept: application/json' -u ${wmio_user}:${wmio_password})
    
  # ----------------------------
  # Export asset to local file
  # ----------------------------
  rdExport=$(echo "$refDataJson" | jq '.output // empty')
  if [ -z "$rdExport" ];   then
    echo "Empty reference data defined for the name:" ${assetId}
  else
    echo "$refDataJson" > ${assetId}.json
    echo "Download succeeded:" ls -ltr ./${assetId}.json
  fi
}

# ----------------------------------------------------------
# Main
# ----------------------------------------------------------
echo "Retrieving all Reference Data items ..."
PROJECT_LIST_URL=${wmio_endpoint}/apis/v1/rest/projects/${wmio_projectName}/referencedata

exportListJson=$(curl  --location --request GET ${PROJECT_LIST_URL} \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  -u ${wmio_user}:${wmio_password})

listExport=$(echo "$exportListJson" | jq -r -c '.output[].name // empty')

if [ -z "$listExport" ];   then
  echo "No reference data defined for the project" 
else
  # Exporting Reference Data
  for item in $(jq -r '.output[] | .name' <<< "$exportListJson"); do
    exportReferenceData ${wmio_endpoint} ${wmio_user} ${wmio_password} ${wmio_projectName} $item
  done
fi

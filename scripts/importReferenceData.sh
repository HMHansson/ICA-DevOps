#!/bin/bash
#############################################################################
#                                                                           #
## importReferenceData.sh : Import reference data for a project             #
#                                                                           #
#############################################################################
wmio_endpoint=$1
wmio_user=$2
wmio_password=$3
wmio_projectName=$4
github_home=$5

function importReferenceData() {
  wmio_endpoint=$1
  wmio_user=$2
  wmio_password=$3
  wmio_projectName=$4
  jsonFile=$5

  # Read File Content
  jsonRefData=$(<${jsonFile})

  # Extract parameters for API
  filename=$(basename -- "$jsonFile")
  refName="${filename%.json}"
  refDesc=$(echo "$jsonRefData" | jq -c -r '.output.description')
  refEncoding=$(echo "$jsonRefData" | jq -c -r '.output.encodingType')
  refFieldSep=$(echo "$jsonRefData" | jq -c -r '.output.columnDelimiter')
  refTxtQual=$(echo "$jsonRefData" | jq -c -r '.output.releaseCharacter')

  # Create local csv file for upload
  refColNames=$(echo "$jsonRefData" | jq -c -r '.output.columnNames')
  refDataRecords=$(echo "$jsonRefData" | jq -c -r '.output.dataRecords')
  if [[ "$refFieldSep" == "," ]]; then
    csvData=$(echo "$refDataRecords" | jq -c -r '(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv')
  else
    csvData=$(echo "$refDataRecords" | jq -c -r '(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' | sed "s/\",\"/\"${columnDelimiter}\"/g")
  fi
  echo "$csvData" > ${refName}.csv

  # ----------------------------
  # Find out if exists already
  # ----------------------------
  REFDATA_URL=${wmio_endpoint}/apis/v1/rest/projects/${wmio_projectName}/referencedata/${refName}
  echo "Reference Data URL:" ${REFDATA_URL}
  refDataRespCode=$(curl --request GET ${REFDATA_URL} -o /dev/null -s -w "%{http_code}\n" --location --header 'Content-Type: application/json' --header 'Accept: application/json' -u ${wmio_user}:${wmio_password})
  if [[ "$refDataRespCode" =~ "200" ]]; then 
    echo Ref Data ${refName} already exists...
    HTTP_METHOD=PUT
  else 
    echo Ref Data ${refName} does not exist, creating new...
    HTTP_METHOD=POST
    REFDATA_URL=${wmio_endpoint}/apis/v1/rest/projects/${wmio_projectName}/referencedata
  fi

  # ----------------------------
  # Send API Request
  # ----------------------------
  refDataAPI=$(curl --location --request ${HTTP_METHOD} ${REFDATA_URL} \
      --header 'Accept: application/json' \
      --form 'name='"$refName" \
      --form 'description='"$refDesc" \
      --form 'file_encoding='"$refEncoding" \
      --form 'field_separator='"$refFieldSep" \
      --form 'text_qualifier='"$refTxtQual" \
      --form 'file=@'"${refName}"'.csv' \
      -u ${wmio_user}:${wmio_password})  

  refDataOutput=$(echo "$refDataAPI" | jq -r -c '.integration.message.description')
  if [ "$refDataOutput"=="Success" ];   then
    echo "Reference Data created/updated successfully"
  else
    echo "Adding Reference Data failed:" ${refDataAPI}
    exit 1
  fi

}

# ----------------------------------------------------------
# Main
# ----------------------------------------------------------
echo "Retrieving all Reference Data items from project directory ..."
for jsonFile in ./*.json; do
    importReferenceData ${wmio_endpoint} ${wmio_user} ${wmio_password} ${wmio_projectName} ${jsonFile}
done
set +x
#!/bin/bash
#############################################################################
##                                                                          #
## importAllAssets.sh : Import all assets for a project                     #
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

# ----------------------------------------------------------
# Import Workflows...
# ----------------------------------------------------------
WORKFLOW_DIR="${github_home}/assets/workflows"

if [ -d "${WORKFLOW_DIR}" ]; then
  cd "${WORKFLOW_DIR}"
  ${github_home}/devops/scripts/importWorkflows.sh \
    ${wmio_endpoint} \
    ${wmio_user} \
    ${wmio_password} \
    ${wmio_projectName}
else 
  echo No Workflows exist for this project...
fi

# ----------------------------------------------------------
# Import Flow Services...
# ----------------------------------------------------------
FLOWSVCS_DIR="${github_home}/assets/flowservices"
if [ -d "${FLOWSVCS_DIR}" ]; then
  cd "${FLOWSVCS_DIR}"

  ${github_home}/devops/scripts/importFlowservices.sh \
    ${wmio_endpoint} \
    ${wmio_user} \
    ${wmio_password} \
    ${wmio_projectName}
else 
  echo No Flow Services exist for this project...
fi

# ----------------------------------------------------------
# Import Reference Data...
# ----------------------------------------------------------
REFDATA_DIR="${github_home}/assets/referenceData"
if [ -d "${REFDATA_DIR}" ]; then
  cd "${REFDATA_DIR}"

  ${github_home}/devops/scripts/importReferenceData.sh \
    ${wmio_endpoint} \
    ${wmio_user} \
    ${wmio_password} \
    ${wmio_projectName}
else 
  echo No Reference data exist for this project...
fi

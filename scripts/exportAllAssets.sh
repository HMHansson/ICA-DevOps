#!/bin/bash
#############################################################################
##                                                                          #
## exportAllAssets.sh : Export all assets for a project                     #
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
# Export Workflows...
# ----------------------------------------------------------
WORKFLOW_DIR="${github_home}/workflows"
if [ ! -d "${WORKFLOW_DIR}" ]; then
  echo Creating workflows directory "${WORKFLOW_DIR}"...
  mkdir "${WORKFLOW_DIR}"
fi
cd "${WORKFLOW_DIR}"
${github_home}/scripts/wmio/exportWorkflows.sh \
  ${wmio_endpoint} \
  ${wmio_user} \
  ${wmio_password} \
  ${wmio_projectName}

# ----------------------------------------------------------
# Export Flow Services...
# ----------------------------------------------------------
FLOWSVCS_DIR="${github_home}/flowservices"
if [ ! -d "${FLOWSVCS_DIR}" ]; then
  echo Creating flow services directory "${FLOWSVCS_DIR}"...
  mkdir "${FLOWSVCS_DIR}"
fi
cd "${FLOWSVCS_DIR}"

${github_home}/scripts/wmio/exportFlowservices.sh \
  ${wmio_endpoint} \
  ${wmio_user} \
  ${wmio_password} \
  ${wmio_projectName}

# ----------------------------------------------------------
# Export Reference Data...
# ----------------------------------------------------------
REFDATA_DIR="${github_home}/referenceData"
if [ ! -d "${REFDATA_DIR}" ]; then
  echo Creating reference data directory "${REFDATA_DIR}"...
  mkdir "${REFDATA_DIR}"
fi
cd "${REFDATA_DIR}"

${github_home}/scripts/wmio/exportReferenceData.sh \
  ${wmio_endpoint} \
  ${wmio_user} \
  ${wmio_password} \
  ${wmio_projectName}

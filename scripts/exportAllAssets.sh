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
# Init
# ----------------------------------------------------------
ASSETS_DIR="${github_home}/assets"
if [ ! -d "${ASSETS_DIR}" ]; then
  echo Creating assets directory "${ASSETS_DIR}"...
  mkdir "${ASSETS_DIR}"
fi

# ----------------------------------------------------------
# Export Project...
# ----------------------------------------------------------
ASSET_DIR="${github_home}/assets/project"
if [ ! -d "${ASSET_DIR}" ]; then
  echo Creating project directory "${ASSET_DIR}"...
  mkdir "${ASSET_DIR}"
fi
cd "${ASSET_DIR}"
${github_home}/devops/scripts/exportProject.sh \
  ${wmio_endpoint} \
  ${wmio_user} \
  ${wmio_password} \
  ${wmio_projectName}

# ----------------------------------------------------------
# Export Workflows...
# ----------------------------------------------------------
ASSET_DIR="${github_home}/assets/workflows"
if [ ! -d "${ASSET_DIR}" ]; then
  echo Creating workflows directory "${ASSET_DIR}"...
  mkdir "${ASSET_DIR}"
fi
cd "${ASSET_DIR}"
${github_home}/devops/scripts/exportWorkflows.sh \
  ${wmio_endpoint} \
  ${wmio_user} \
  ${wmio_password} \
  ${wmio_projectName}

# ----------------------------------------------------------
# Export Flow Services...
# ----------------------------------------------------------
ASSET_DIR="${github_home}/assets/flow_services"
if [ ! -d "${ASSET_DIR}" ]; then
  echo Creating flow services directory "${ASSET_DIR}"...
  mkdir "${ASSET_DIR}"
fi
cd "${ASSET_DIR}"

${github_home}/devops/scripts/exportFlowservices.sh \
  ${wmio_endpoint} \
  ${wmio_user} \
  ${wmio_password} \
  ${wmio_projectName}

# ----------------------------------------------------------
# Export Reference Data...
# ----------------------------------------------------------
ASSET_DIR="${github_home}/assets/reference_data"
if [ ! -d "${ASSET_DIR}" ]; then
  echo Creating reference data directory "${ASSET_DIR}"...
  mkdir "${ASSET_DIR}"
fi
cd "${ASSET_DIR}"

${github_home}/devops/scripts/exportReferenceData.sh \
  ${wmio_endpoint} \
  ${wmio_user} \
  ${wmio_password} \
  ${wmio_projectName}

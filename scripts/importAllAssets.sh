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
# Init
# ----------------------------------------------------------
ASSETS_DIR="${github_home}/assets"
if [ ! -d "${ASSETS_DIR}" ]; then
  echo No assets for this project. Exiting ...
  exit 0
fi

# ----------------------------------------------------------
# Import Project...
# ----------------------------------------------------------
ASSETS_DIR="${github_home}/assets/project"

if [ -d "${ASSETS_DIR}" ]; then
  cd "${ASSETS_DIR}"
  ${github_home}/devops/scripts/importProject.sh \
    ${wmio_endpoint} \
    ${wmio_user} \
    ${wmio_password} \
    ${wmio_projectName} \
    ${github_home}

else 
  echo No Project archive exists for this project...
fi

# ----------------------------------------------------------
# Import Workflows...
# ----------------------------------------------------------
ASSETS_DIR="${github_home}/assets/workflows"

if [ -d "${ASSETS_DIR}" ]; then
  cd "${ASSETS_DIR}"
  ${github_home}/devops/scripts/importWorkflows.sh \
    ${wmio_endpoint} \
    ${wmio_user} \
    ${wmio_password} \
    ${wmio_projectName} \
    ${github_home}
else 
  echo No Workflows exist for this project...
fi

# ----------------------------------------------------------
# Import Flow Services...
# ----------------------------------------------------------
ASSETS_DIR="${github_home}/assets/flow_services"
if [ -d "${ASSETS_DIR}" ]; then
  cd "${ASSETS_DIR}"

  ${github_home}/devops/scripts/importFlowservices.sh \
    ${wmio_endpoint} \
    ${wmio_user} \
    ${wmio_password} \
    ${wmio_projectName} \
    ${github_home}
else 
  echo No Flow Services exist for this project...
fi

# ----------------------------------------------------------
# Import Reference Data...
# ----------------------------------------------------------
ASSETS_DIR="${github_home}/assets/reference_data"
if [ -d "${ASSETS_DIR}" ]; then
  cd "${ASSETS_DIR}"

  ${github_home}/devops/scripts/importReferenceData.sh \
    ${wmio_endpoint} \
    ${wmio_user} \
    ${wmio_password} \
    ${wmio_projectName} \
    ${github_home}
else 
  echo No Reference data exist for this project...
fi

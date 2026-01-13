#!/bin/bash
set -euo pipefail

# ----------------------------
# Simple Bicep dry-run (what-if) script
# ----------------------------

# Usage: ./deploy-dryrun.sh <environment>
# Example: ./deploy-dryrun.sh dev

ENV=${1:-dev}  # default to dev if not provided

# Map environment to parameter file
# PARAM_FILE="${ENV}.parameters.json"
PARAM_FILE="${ENV}.bicepparam"

if [[ ! -f "$PARAM_FILE" ]]; then
  echo "Parameter file $PARAM_FILE not found!"
  exit 1
fi

# Choose a location (used only for subscription-level deployment)
LOCATION="westeurope"

# Dry run / what-if deployment
echo "Performing Bicep dry-run (what-if) for environment: $ENV"
az deployment sub what-if \
    --name "bicep-whatif-$ENV-$(date +%Y%m%d%H%M%S)" \
    --location $LOCATION \
    --template-file main.bicep \
    --parameters "$PARAM_FILE" \
    --result-format FullResourcePayloads

echo "Dry run completed successfully!"

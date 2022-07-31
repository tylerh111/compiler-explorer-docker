#!/bin/bash
# ./build_ce_infra.sh [revision]
#   This script builds the compiler-explorer-infra docker image.
#   This script must be run from the root directory (where the Dockerfile exists).

echo "Building compiler-explorer-infra:latest"
docker build -f dockerfile.ce_infra -t compiler-explorer-infra:latest .
echo "Successfully tagged compiler-explorer-infra:latest"

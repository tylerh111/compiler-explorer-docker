#!/bin/bash
# ./build.sh [revision]
#   This script builds the compiler-explorer docker image. It does not install any compilers.
#   This script must be run from the root directory (where the Dockerfile exists).
#   Arguments:
#       - [revision] : optional, specify which revision to use when cloning compiler-explorer
#           It is advised to use a commit hash or tag as this is used in tagging the docker image
cd $(dirname $0)

ce_commit=main
if [ ! -z $1 ]; then
    ce_commit=$1
fi

echo "Building compiler-explorer:$ce_commit"
docker build -t compiler-explorer:latest --build-arg commit=$ce_commit .
docker tag compiler-explorer:latest compiler-explorer:$ce_commit
echo "Successfully tagged compiler-explorer:$ce_commit"

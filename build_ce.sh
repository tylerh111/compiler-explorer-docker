#!/bin/bash
# ./build_ce.sh [revision]
#   This script builds the compiler-explorer docker image. It does not install any compilers.
#   This script must be run from the root directory (where dockerfile.ce exists).
#   Arguments:
#       - [revision] : optional, specify which revision to use when cloning compiler-explorer
#           It is advised to use a commit hash or tag as this is used in tagging the docker image

ce_commit=main
if [ ! -z $1 ]; then
    ce_commit=$1
fi

echo "Building compiler-explorer:$ce_commit"
docker build -f dockerfile.ce -t compiler-explorer:$ce_commit --build-arg commit=$ce_commit .
docker tag compiler-explorer:$ce_commit compiler-explorer:latest
echo "Successfully tagged compiler-explorer:$ce_commit"

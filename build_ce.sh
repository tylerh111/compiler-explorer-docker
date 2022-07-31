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

git -C compiler-explorer/ fetch
if ! ce_commit_hash=$(git -C compiler-explorer/ log -1 --format="%H" $ce_commit); then
    exit -1
fi

docker_repo=compiler-explorer
docker_tag=$ce_commit

echo "Building $docker_repo:$docker_tag #$ce_commit_hash"
docker build -f dockerfile.ce -t $docker_repo:$docker_tag --build-arg commit=$ce_commit_hash .
docker tag $docker_repo:$docker_tag $docker_repo:latest
echo "Successfully tagged compiler-explorer:$ce_commit #$ce_commit_hash"

#!/bin/bash
# ./run_ce_infra.sh [revision]
#   This script runs the compiler-explorer-infra docker image.
#   Arguments:
#       - [ce-volume] : optional, specify which docker volume to use when running the docker image
#       - [extra-volume] : optional, specify extra volume to use when running the docker image
#

docker_vol=compiler-explorer
extra_vol=`pwd`

[ ! -z $1 ] && docker_vol=$1
[ ! -z $2 ] && extra_vol=$2

if [ -z $(docker volume ls -q -f name=$docker_vol 2> /dev/null) ]; then
    echo "Docker volume '$docker_vol' does not exist, creating empty volume"
    docker volume create $docker_vol
fi

if [ -z $extra_vol ]; then
    echo "Directory $extra_vol does not exist"
    exit 1
fi

echo "Running $docker_img:$docker_tag with $docker_vol"
docker run -it --rm -v $extra_vol:/workspace -v $docker_vol:/opt/compiler-explorer compiler-explorer-infra




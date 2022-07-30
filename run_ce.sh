#!/bin/bash
# ./run_ce.sh [revision]
#   This script runs the compiler-explorer docker image.
#   Requires the compiler-explorer docker image to exist
#   Requires the compiler-explorer docker volume to exist
#   Arguments:
#       - [tag] : optional, specify which docker tag to use when running the docker image
#       - [volume] : optional, specify which docker volume to use when running the docker image
#

docker_img=compiler-explorer
docker_tag=latest
docker_vol=compiler-explorer

[ ! -z $1 ] && docker_tag=$1
[ ! -z $2 ] && docker_vol=$2

if [ -z $(docker images -q $docker_img:$docker_tag 2> /dev/null) ]; then
    echo "Docker image '$docker_img:$docker_tag' does not exist"
    exit 1
fi

if [ -z $(docker volume ls -q -f name=$docker_vol 2> /dev/null) ]; then
    echo "Docker volume '$docker_vol' does not exist"
    exit 2
fi

echo "Running $docker_img:$docker_tag with $docker_vol"
docker run -d -p 10240:10240 --restart=on-failure -v $docker_vol:/opt/compiler-explorer $docker_img:$docker_tag




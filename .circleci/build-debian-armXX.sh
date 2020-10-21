#!/usr/bin/env bash

#
# Build for Debian ARM in a docker container
#

# bailout on errors and echo commands.
set -xe

DOCKER_SOCK="unix:///var/run/docker.sock"

echo "DOCKER_OPTS=\"-H tcp://127.0.0.1:2375 -H $DOCKER_SOCK -s devicemapper\"" | sudo tee /etc/default/docker > /dev/null
sudo service docker restart
sleep 5;

if [ "$CONTAINER_DISTRO" = "raspbian" ]; then
    docker run --rm --privileged multiarch/qemu-user-static:register --reset
else
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
fi

docker run --privileged -d -ti -e "container=docker"  -v $(pwd):/ci-source:rw $DOCKER_IMAGE /bin/bash
DOCKER_CONTAINER_ID=$(docker ps --last 8 | grep $CONTAINER_DISTRO | awk '{print $1}')

docker exec -ti $DOCKER_CONTAINER_ID apt-get update
docker exec -ti $DOCKER_CONTAINER_ID apt-get -y install libevdev2 libevdev-dev libinput-dev debhelper

docker exec -ti $DOCKER_CONTAINER_ID pwd

docker exec -ti $DOCKER_CONTAINER_ID /bin/bash -xec \
    "dpkg-buildpackage -rfakeroot -b -uc -us"

echo "Stopping"
docker ps -a
docker stop $DOCKER_CONTAINER_ID
docker rm -v $DOCKER_CONTAINER_ID

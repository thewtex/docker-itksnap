#!/bin/bash

if test $# -lt 1; then
  echo "Please pass in the images to view."
  exit 1
fi
images="$@"


version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" == "$1"; }
docker_version=$(docker version | grep 'Client version' | awk '{split($0,a,":"); print a[2]}' | tr -d ' ')
# Docker 1.3.0 or later is required for --device
if ! version_gt "${docker_version}" "1.2.0"; then
	echo "Docker version 1.3.0 or greater is required"
	exit 1
fi


XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -


docker run \
	-v $XSOCK:$XSOCK:rw \
	-v $XAUTH:$XAUTH:rw \
        --device=/dev/dri/card0:/dev/dri/card0 \
	-e DISPLAY=$DISPLAY \
	-e XAUTHORITY=$XAUTH \
        -i -t \
        --rm \
        -v ${PWD}:/tmp/images:ro \
        --workdir=/tmp/images \
        $(docker images | grep ^itksnap | head -n 1 | awk '{ print $1":"$2 }') \
        /opt/bin/itksnap-Release/ITK-SNAP \
        $images

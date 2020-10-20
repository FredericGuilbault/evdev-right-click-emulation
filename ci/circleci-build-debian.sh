#!/bin/bash

sudo apt-get -y install libevdev2 libevdev-dev libinput-dev

dpkg-buildpackage -rfakeroot -b -uc -us


#!/bin/bash

sudo apt update
sudo apt-get -y install libevdev2 libevdev-dev libinput-dev debhelper

dpkg-buildpackage -rfakeroot -b -uc -us


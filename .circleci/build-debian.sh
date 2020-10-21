#!/usr/bin/env bash

sudo apt-get update
sudo apt-get -y install libevdev2 libevdev-dev libinput-dev debhelper

dpkg-buildpackage -rfakeroot -b -uc -us; mkdir dist; mv ../*.deb dist

find dist -name \*.deb


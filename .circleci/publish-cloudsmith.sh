#!/usr/bin/env bash

for pkg_file in dist/*.deb; do
  cloudsmith push deb bbn-projects/bbn-repo/raspbian/buster $pkg_file
done
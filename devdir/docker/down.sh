#!/bin/sh

docker container stop $(docker container ls -aq)

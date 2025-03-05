#!/bin/sh

USERNAME=nonroot

HOST_UID=$(id -u) HOST_GID=$(id -g) HOST_UNAME=$(uname -s) LOGIN_USERNAME=$USERNAME docker compose -f docker-compose.yml up --build  -d

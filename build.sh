#!/bin/bash
set -e

docker build -t deluge .
docker tag deluge:latest cburger/deluge:latest
docker push cburger/deluge:latest

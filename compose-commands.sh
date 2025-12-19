#!/bin/bash

# Stoping the container
docker image prune --all --force
# docker system prune --all --force

# Downloading and overwriting the compose file
wget -O compose.yaml https://raw.githubusercontent.com/juronja/ori-the-shrimpcat/refs/heads/main/compose.yaml

# Starting the container
docker compose up -d --remove-orphans
#!/bin/bash

PURPLE="\033[35m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${GREEN} ~~  INSTALLING EVERY TOOLS ~~ ${RESET}"
sudo apt-get update -y
sudo apt-get install vim git curl ncdu ansible python3-pip -y 

echo -e "${GREEN} ~~  INSTALLING DOCKER ~~ ${RESET}"
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo chmod 666 /var/run/docker.sock
rm get-docker.sh


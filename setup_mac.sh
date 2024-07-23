#!/bin/bash

PURPLE="\033[35m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${GREEN} ~~  INSTALLING EVERY TOOLS ~~ ${RESET}"
brew install update
brew install terraform 
brew install aws
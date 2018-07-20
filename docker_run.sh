#!/bin/bash

# Build changes (if necessary)
./docker_build.sh

# Run a container
#docker run -p 0.0.0.0:27016:27016/tcp -p 0.0.0.0:27016:27016/udp -p 0.0.0.0:27017:27017/tcp -v "$(pwd)/colonysurvival_data:/steamcmd/colonysurvival" --name colony-survival-server -it --rm didstopia/colony-survival-server:latest
docker run -e SERVER_NAME="Test 2" -e SERVER_PASSWORD="docker" -p 0.0.0.0:27016:27016/tcp -p 0.0.0.0:27016:27016/udp -p 0.0.0.0:27017:27017/tcp -v "$(pwd)/colonysurvival_data:/steamcmd/colonysurvival" --name colony-survival-server -it --rm didstopia/colony-survival-server:latest

# Edit unit tests
#dgoss edit -p 0.0.0.0:27016:27016/tcp -p 0.0.0.0:27016:27016/udp -p 0.0.0.0:27017:27017/tcp -v "$(pwd)/colonysurvival_data:/steamcmd/colonysurvival" --name colony-survival-server -d didstopia/colony-survival-server:latest

# Run unit tests (production)
#GOSS_WAIT_OPTS="--retry-timeout 300s --sleep 1s > /dev/null" GOSS_SLEEP="15" dgoss run -p 0.0.0.0:27016:27016/tcp -p 0.0.0.0:27016:27016/udp -p 0.0.0.0:27017:27017/tcp -v "$(pwd)/colonysurvival_data:/steamcmd/colonysurvival" --name colony-survival-server -d didstopia/colony-survival-server

#!/usr/bin/env bash

# Setup error handling
set -e
set -o pipefail

# Enable debugging
# set -x

# Print the user we're currently running as
echo "Running as user: $(whoami)"

# Remove the old cached app info if it exists
if [ -f "$HOME/Steam/appcache/appinfo.vdf" ]; then
	rm -fr $HOME/Steam/appcache/appinfo.vdf
fi

# Setup and start scheduled jobs
echo "Setting up scheduled jobs.."
sudo service rsyslog start
crontab -u $(whoami) /app/update.cron
sudo service cron start
echo "Scheduled jobs now running!"

# Check that Colony Survival exists in the first place
if [ ! -f "/steamcmd/colonysurvival/colonyserver.x86_64" ]; then
	# Install Colony Survival from install.txt
	echo ""
	echo "Installing Colony Survival.."
	echo ""
	bash /steamcmd/steamcmd.sh +runscript /app/install.txt
else
	# Update Colony Survival from install.txt
	echo ""
	echo "Updating Colony Survival.."
	echo ""
	bash /steamcmd/steamcmd.sh +runscript /app/install.txt
fi

# Colony Survival includes a 64-bit version of steamclient.so, so we need to tell the OS where it exists
mkdir -p $HOME/.steam/sdk64
cp -f /steamcmd/linux64/steamclient.so $HOME/.steam/sdk64/steamclient.so
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.steam/sdk64

# Set the working directory
cd /steamcmd/colonysurvival || exit

# Run the server
echo ""
echo "Starting Colony Survival.."
echo ""
if [ ! -z "$SERVER_PASSWORD" ]; then
	exec /steamcmd/colonysurvival/colonyserver.x86_64 ${SERVER_STARTUP_ARGS} +server.world "${SERVER_NAME}" +server.name "${SERVER_NAME}" +server.password ${SERVER_PASSWORD} 2>&1
else
	exec /steamcmd/colonysurvival/colonyserver.x86_64 ${SERVER_STARTUP_ARGS} +server.world "${SERVER_NAME}" +server.name "${SERVER_NAME}" 2>&1
fi

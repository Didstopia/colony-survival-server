#!/usr/bin/env bash

# Remove the old cached app info if it exists
if [ -f "/root/Steam/appcache/appinfo.vdf" ]; then
	rm -fr /root/Steam/appcache/appinfo.vdf
fi

# Setup and start scheduled jobs
echo "Setting up scheduled jobs.."
service rsyslog start
crontab -u root /update.cron
service cron start
echo "Scheduled jobs now running!"

# Check that Colony Survival exists in the first place
if [ ! -f "/steamcmd/colonysurvival/colonyserver.x86_64" ]; then
	# Install Colony Survival from install.txt
	echo ""
	echo "Installing Colony Survival.."
	echo ""
	bash /steamcmd/steamcmd.sh +runscript /install.txt
else
	# Update Colony Survival from install.txt
	echo ""
	echo "Updating Colony Survival.."
	echo ""
	bash /steamcmd/steamcmd.sh +runscript /install.txt
fi

# Colony Survival includes a 64-bit version of steamclient.so, so we need to tell the OS where it exists
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/steamcmd/colonysurvival/linux64

# Set the working directory
cd /steamcmd/colonysurvival || exit

# Run the server
echo ""
echo "Starting Colony Survival.."
echo ""
if [ ! -z "$SERVER_PASSWORD" ]; then
	exec /steamcmd/colonysurvival/colonyserver.x86_64 -batchmode -nographics start_server +server.gameport 27016 +server.world "${SERVER_NAME}" +server.name "${SERVER_NAME}" +server.networktype SteamOnline +server.password ${SERVER_PASSWORD} 2>&1
else
	exec /steamcmd/colonysurvival/colonyserver.x86_64 -batchmode -nographics start_server +server.gameport 27016 +server.world "${SERVER_NAME}" +server.name "${SERVER_NAME}" +server.networktype SteamOnline 2>&1
fi

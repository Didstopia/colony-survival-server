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

# Set the working directory
cd /steamcmd/colonysurvival || exit

# Run the server
echo ""
echo "Starting Colony Survival.."
echo ""
exec /server.sh 2>&1

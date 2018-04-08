#!/usr/bin/env bash

## FIXME: Graceful shutdown isn't working, afaik?
# Define the exit handler
exit_handler()
{
	echo ""
	echo "Waiting for server to shutdown.."
	echo ""
	kill -SIGINT "$child"

	## TODO: Use fifo to send the "send" and "stop_server" commands to the server process
	#mono /steamcmd/colonysurvival/colonyserverdedicated.exe send "Shutting down.."
	#mono /steamcmd/colonysurvival/colonyserverdedicated.exe stop_server
	sleep 5

	echo ""
	echo "Terminating.."
	echo ""
	exit
}

# Trap specific signals and forward to the exit handler
trap 'exit_handler' SIGHUP SIGINT SIGQUIT SIGTERM

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
mono /steamcmd/colonysurvival/colonyserverdedicated.exe start_server +server.world "${SERVER_NAME}" +server.name "${SERVER_NAME}" +server.networktype SteamOnline ${SERVER_EXTRA_ARGS} 2>&1 &
#mono /steamcmd/colonysurvival/colonyserverdedicated.exe 2>&1 &

child=$!
wait "$child"

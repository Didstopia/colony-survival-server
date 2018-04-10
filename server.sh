#!/usr/bin/expect -f

# Set a global timeout
set timeout 120

# Configure the exit handler
exit -onexit {
  #send_user "\nExit called\n"
}
trap {
  #send_user "\Trap called\n"
  send -- "\rstop_server\r"
  expect "Succesfully closed server\r"
  send -- "\rquit\r"
} SIGHUP SIGINT SIGQUIT SIGTERM

# Start the server process
spawn mono /steamcmd/colonysurvival/colonyserverdedicated.exe start_server +server.world "$::env(SERVER_NAME)" +server.name "$::env(SERVER_NAME)" +server.networktype SteamOnline $::env(SERVER_EXTRA_ARGS) 2>&1

# End of file (server exited)
expect eof

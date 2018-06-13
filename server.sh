#!/usr/bin/expect -f

# Set a global timeout
set timeout -1

# Configure the exit handler
exit -onexit {
  #send_user "\nExit called\n"
}
trap {
  send -- "\rstop_server\r"
  expect "Logging thread stopped\r"
  send -- "\rquit\r"
} {SIGHUP SIGINT SIGQUIT SIGTERM}

# Start the server process
if { [string trim $::env(SERVER_PASSWORD)] != "" } {
  spawn mono /steamcmd/colonysurvival/colonyserverdedicated.exe start_server +server.world "$::env(SERVER_NAME)" +server.name "$::env(SERVER_NAME)" +server.networktype SteamOnline +server.password $::env(SERVER_PASSWORD) 2>&1
} else {
  spawn mono /steamcmd/colonysurvival/colonyserverdedicated.exe start_server +server.world "$::env(SERVER_NAME)" +server.name "$::env(SERVER_NAME)" +server.networktype SteamOnline 2>&1
}

# End of file (server exited)
expect eof

# Colony Survival Server

Provides a dedicated linux server for Colony Survival running inside a Docker container. 

**NOTE: WORK IN PROGRESS**

**NOTE**: This image will install/update on startup. The path ```/steamcmd/colonysurvival``` can be mounted on the host for data persistence.

# How to run the server
1. Set the environment variables you wish to modify from below (note the Steam credentials)
2. Optionally mount ```/steamcmd/colonysurvival``` somewhere on the host or inside another container to keep your data safe
3. Enjoy!

*Be sure to edit `starbound_server.config` to further customize your installation.*

The following environment variables are available:
```
STEAM_USERNAME (DEFAULT: "" - Required for installing/updating Starbound)
STEAM_PASSWORD (DEFAULT: "" - Required for installing/updating Starbound)
SKIP_STEAMCMD  (DEFAULT: "" - Optional for skipping updating Starbound)
```

# Updating the server

As long as you have both your `STEAM_USERNAME` and `STEAM_PASSWORD` set, simply restarting the container should trigger the update procedure.

# Anything else

If you need help, have questions or bug submissions, feel free to contact me **@Dids** on Twitter.

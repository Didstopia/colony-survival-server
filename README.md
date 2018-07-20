# Colony Survival Server

*Show your support for this project by signing up for a [free Bitrise account!](https://app.bitrise.io?referrer=02c20c56fa07adcb)*

Provides a dedicated linux server for Colony Survival running inside a Docker container. 

**NOTE**: This image will install/update on startup. The path ```/steamcmd/colonysurvival``` can be mounted on the host for data persistence.

# How to run the server
1. Set the environment variables you wish to modify from below (note the Steam credentials)
2. Optionally mount ```/steamcmd/colonysurvival``` somewhere on the host or inside another container to keep your data safe
3. Enjoy!

The following environment variables are available:
```
SERVER_NAME (DEFAULT: "Docker" - Sets the publicly visible name of the server)
SERVER_PASSWORD (DEFAULT: "" - Optional password for the server)
```

# Updating the server

Simply restart the container to trigger the update procedure.

# Anything else

If you need help, have questions or bug submissions, feel free to contact me **@Dids** on Twitter.

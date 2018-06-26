#!/usr/bin/env bash

set -e
#set -o pipefail
#set -x

echo "Checking for updates.."

# Remove the old cached app info if it exists
if [ -f "/root/Steam/appcache/appinfo.vdf" ]; then
	rm -fr /root/Steam/appcache/appinfo.vdf
fi

# Use "steamer" to get the Steam app info as valid JSON
APPINFO=$(steamer --appinfo 748090)

# Validate $APPINFO as valid JSON using jq
if echo ${APPINFO} | jq -e . >/dev/null 2>&1; then
  echo "Parsed app info successfully"
else
  echo "Failed to parse app info"
  exit 1
fi

# Use jq to get the latest build id
BUILDID=$(echo ${APPINFO} | jq '.depots.branches.public.buildid')

## TODO: Further validate that the build id is a number

# Validate $BUILDID as a non-empty string
if [ -n "$BUILDID" ]; then
  echo "Parsed build id successfully: $BUILDID"
else
  echo "Failed to parse build id"
  exit 1
fi

# Check if an existing build id is found, keeping track of whether this is a fresh install or not
BUILDID_PATH="/steamcmd/colonysurvival/build.id"
FRESH_INSTALL="false"
if [ ! -f "$BUILDID_PATH" ]; then FRESH_INSTALL="true"; fi

# Get the existing build id (if any)
BUILDID_OLD=$(cat "$BUILDID_PATH" || true)
echo "Existing build id: $BUILDID_OLD"

# Check between if the build id has changed
if [ "$BUILDID" != "$BUILDID_OLD" ]; then
  echo "New build id $BUILDID does not match old build id $BUILDID_OLD"

  # Store the build id in a file, overwriting any existing file
  echo $BUILDID > "$BUILDID_PATH"
  cat "$BUILDID_PATH"

  # Gracefully shutdown the server to apply the updates (if necessary)
  if [ $FRESH_INSTALL == "true" ]; then
    echo "Fresh install detected, skipping update.."
  else
    echo "Shutting down to install the update.."
    kill -INT $(pidof expect)
  fi
else
  echo "New build id $BUILDID matches the old build id $BUILDID_OLD, skipping.."
fi

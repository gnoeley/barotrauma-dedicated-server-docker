#!/bin/bash

# Check that the game is up-to-date
"${STEAMCMDDIR}/steamcmd.sh" "${STEAMCMDDIR}/steamcmd.sh" \
		@ShutdownOnFailedCommand \
		@NoPromptForPassword \
		+login anonymous \
		+force_install_dir ${STEAMAPPDIR} \
		+app_update ${STEAMAPPID} \
		+'quit'

# Update settings.xml using ENV varaibles
SETTINGS_XML=${STEAMAPPDIR}/serversettings.xml
sed -i 's/password=.*/password="'"$BAR_PASSWORD"'"/' "${SETTINGS_XML}"
sed -i 's/name=.*/name="'"$BAR_NAME"'"/' "${SETTINGS_XML}"
sed -i 's/ServerMessage=.*/ServerMessage="'"$BAR_SERVERMESSAGE"'"/' "${SETTINGS_XML}"
sed -i 's/startwhenclientsready=.*/startwhenclientsready="'"$BAR_START_WHEN_CLIENTS_READY"'"/' "${SETTINGS_XML}"
sed -i 's/startwhenclientsreadyratio=.*/startwhenclientsreadyratio="'"$BAR_START_WHEN_CLIENTS_READY_RATIO"'"/' "${SETTINGS_XML}"
sed -i 's/public=.*/public="true"/' "${SETTINGS_XML}"


# Create client Permissions
# <Name>:<SteamID>:<Permissions>:<Commands>
# <InGameName1>:<SteamID1>:<Permission1.1>,<Permission1.2>,<Permission1.3>:<Command1.1>,<Command1.2>;<InGameName2>:<SteamID2>:<Permission2.1>,<Permission2.2>:;<InGameName3>:<SteamID3>:<Permission3.1>:<Command3.1>,<Command3.2>;
# Commands are optional
CLIENT_PERMISSIONS_XML=${STEAMAPPDIR}/Data/clientpermissions.xml
IFS=$";"
echo \
'<?xml version="1.0" encoding="utf-8"?>
<ClientPermissions>' \
> $CLIENT_PERMISSIONS_XML

for permission in $BAR_PERMISSIONS
do
    IFS=$":"
    arr=( $permission )
    cmdstr=${arr[3]}
    commands=""
    clientend=""
    if [ ! -z "$cmdstr" ];then
      clientend=">"
      IFS=","
      read -a cmdarr <<< "$cmdstr"
      for cmd in "${cmdarr[@]}"
      do
        commands="${commands} <command name=\"${cmd}\" />"
      done
    fi
    echo '<Client
        name="'"${arr[0]}"'"
        steamid="'"${arr[1]}"'"
        permissions="'"${arr[2]}"'"'"${clientend}"'
        '"${commands}"'
    </Client>' \
    >> $CLIENT_PERMISSIONS_XML
done

echo '</ClientPermissions>' >> $CLIENT_PERMISSIONS_XML


# Run the server!
"${STEAMAPPDIR}/DedicatedServer"

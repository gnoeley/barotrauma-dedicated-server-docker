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
sed -i 's/public=.*/public="true"/' "${SETTINGS_XML}"

# Creat client Persmissions
IFS=$","
echo \
'<?xml version="1.0" encoding="utf-8"?>
<ClientPermissions>' \
> clientpermissions.xml

for permission in $BAR_PERMISSIONS
do
    IFS=$":"
    arr=( $permission )
    echo '<Client
        name="'"${arr[0]}"'"
        steamid="'"${arr[1]}"'"
        preset="'"${arr[2]}"'" />' \
    >> clientpermissions.xml
done

echo '</ClientPermissions>' >> clientpermissions.xml

# Run the server!
"${STEAMAPPDIR}/DedicatedServer"

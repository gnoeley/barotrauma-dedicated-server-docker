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

# Run the server!
"${STEAMAPPDIR}/DedicatedServer"

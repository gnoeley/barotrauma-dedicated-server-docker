Barotrauma Dedicated Server (Docker)
------------------------------------
Docker container which runs a [Barotrauma](https://store.steampowered.com/app/602960/Barotrauma/) dedicated server using [SteamCMD](https://developer.valvesoftware.com/wiki/Command_Line_Options#SteamCMD).
The server uses the default ports (27015/udp & 27016/udp) and is exposed as public by default.

# How to run
Just run the command...
```sh
  docker run \
    --env BAR_PASSWORD=changeme! \
    --env BAR_NAME=ServerNameHere \
    --env BAR_SERVERMESSAGE="Put ServerMessage here." \
    --env BAR_START_WHEN_CLIENTS_READY=True \
    --env BAR_START_WHEN_CLIENTS_READY_RATIO=0.8 \
    --env BAR_PERMISSIONS=InGameUsername1:Steam64ID1:Perm1,Perm2:Command1,Command2;InGameUsername2:Steam64ID2:Perm2.1:InGameUsername3:Steam64ID3:Perm3.1:Command3.1,Command3.2,Command3.3 \
    -p 27015:27015/udp \
    -p 27016:27016/udp \
    -v submarines:/home/steam/barotrauma-dedicated/Submarines/github \
    -v saves:"/home/steam/.local/share/Daedalic Entertainment GmbH/Barotrauma/Multiplayer" \
    --name barotrauma-server \
    goldfish92/barotrauma-dedicated-server
```

Change the environment variables for password and server name to customize your server.

# Subamarines
Mount a volume when running the container to include additional custom submarines. For example
```sh
-v submarines:/home/steam/barotrauma-dedicated/Submarines/github
```
mounts the volume `submarines` on the host into the Barotrauma Submarine directory into a subdirectory called `github`.

# Multiplayer Saves
Mount a volume when running the container to persist multiplayer saves between container starts. For example
```sh
-v saves:"/home/steam/.local/share/Daedalic Entertainment GmbH/Barotrauma/Multiplayer"
```
mounts the volume `saves` on the host into the Barotrauma Multiplayer directory where saves are created. These save files can then be accessed on the host or mounted between container restarts.

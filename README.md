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
    -p 27015:27015/udp \
    -p 27016:27016/udp \
    --label barotrauma-server \
    goldfish92/barotrauma-dedicated-server
```

Change the environment variables for password and server name to customize your server.

# TODO
- More serversettings.xml customization exposed as ENV variables.
- Instructions for using volumes for persistent server state.

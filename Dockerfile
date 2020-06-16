###########################################################
# Dockerfile that builds a Barotrauma server
###########################################################
FROM cm2network/steamcmd:root

LABEL maintainer="leon.pelech@gmail.com"

ENV STEAMAPPID 1026340
ENV STEAMAPPDIR /home/steam/barotrauma-dedicated

# Install DOT.NET Rutime dependencies
# Install game files
# Remove packages and tidy up
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget=1.20.1-1.1 \
		ca-certificates=20190110 \
  && wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
	&& dpkg -i packages-microsoft-prod.deb \
	&& apt-get update \
	&& apt-get install -y apt-transport-https \
	&& apt-get update \
	&& apt-get install -y dotnet-runtime-3.1 \
	&& "${STEAMCMDDIR}/steamcmd.sh" \
			@ShutdownOnFailedCommand \
			@NoPromptForPassword \
			+login anonymous \
			+force_install_dir ${STEAMAPPDIR} \
			+app_update ${STEAMAPPID} validate \
			+'quit' \
	&& apt-get remove --purge -y \
		wget \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

# Create directory to hold steamclient.so symlink
RUN set -x \
  && mkdir -p /home/steam/.steam/sdk64 \
	&& chown -R steam:steam /home/steam/.steam \
	&& ln -s ${STEAMAPPDIR}/steamclient.so /home/steam/.steam/sdk64/steamclient.so

# Create Multiplayer save directory for volume mount
ENV BAR_MULTIPLAYER_SAVE_DIR "/home/steam/.local/share/Daedalic Entertainment GmbH/Barotrauma/Multiplayer"
RUN set -x \
  && mkdir -p "$BAR_MULTIPLAYER_SAVE_DIR" \
  && chown -R steam:steam "$BAR_MULTIPLAYER_SAVE_DIR/../.."

# Copy custom files for server
COPY --chown=steam:steam entry.sh ${STEAMAPPDIR}/entry.sh
RUN chmod 755 ${STEAMAPPDIR}/entry.sh

# Update these ENV values...
ENV BAR_PASSWORD=changeme! \
  BAR_NAME=UnnamedServer

USER steam

WORKDIR $STEAMAPPDIR

VOLUME $STEAMAPPDIR
VOLUME $BAR_MULTIPLAYER_SAVE_DIR

ENTRYPOINT ${STEAMAPPDIR}/entry.sh

# Expose ports
EXPOSE 27015/tcp 27015/udp
EXPOSE 27016/tcp 27016/udp

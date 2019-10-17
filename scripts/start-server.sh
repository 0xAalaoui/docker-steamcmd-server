#!/bin/bash
if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
    echo "SteamCMD not found!"
    wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
    tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
    rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

echo "---Update SteamCMD---"
if [ "${USERNAME}" == "" ]; then
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +quit
else
		if [ "${STEAM_GUARD}" == "" }; then
    		${STEAMCMD_DIR}/steamcmd.sh \
    		+login ${USERNAME} ${PASSWRD} \
    		+quit
        else
    		echo "${STEAM_GUARD}" | ${STEAMCMD_DIR}/steamcmd.sh \
    		+login ${USERNAME} ${PASSWRD} \
    		+quit
        fi
fi

echo "---Update Server---"
if [ "${USERNAME}" == "" ]; then
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +login anonymous \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +login anonymous \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} \
        +quit
    fi
else
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        if [ "${STEAM_GUARD}" == "" }; then
            ${STEAMCMD_DIR}/steamcmd.sh \
            +login ${USERNAME} ${PASSWRD} \
            +force_install_dir ${SERVER_DIR} \
            +app_update ${GAME_ID} validate \
            +quit
        else
            echo "${STEAM_GUARD}" | ${STEAMCMD_DIR}/steamcmd.sh \
            +login ${USERNAME} ${PASSWRD} \
            +force_install_dir ${SERVER_DIR} \
            +app_update ${GAME_ID} validate \
            +quit
        fi
    else
        if [ "${STEAM_GUARD}" == "" }; then
            ${STEAMCMD_DIR}/steamcmd.sh \
            +login ${USERNAME} ${PASSWRD} \
            +force_install_dir ${SERVER_DIR} \
            +app_update ${GAME_ID} \
            +quit
        else
            echo "${STEAM_GUARD}" | ${STEAMCMD_DIR}/steamcmd.sh \
            +login ${USERNAME} ${PASSWRD} \
            +force_install_dir ${SERVER_DIR} \
            +app_update ${GAME_ID} \
            +quit
        fi
    fi
fi

echo "---Prepare Server---"
if [ ! -f ${SERVER_DIR}/storage/starbound_server.config ]; then
	if [ ! -d ${SERVER_DIR}/storage ]; then
    	mkdir ${SERVER_DIR}/storage
    fi
	echo "---Starbound server configuration not found, downloading---"
    cd ${SERVER_DIR}/storage
	wget -qi - https://raw.githubusercontent.com/ich777/docker-steamcmd-server/starbound/config/starbound_server.config
    if [ ! -f ${SERVER_DIR}/storage/starbound_server.config ]; then
    	echo "---Something went wrong, can't download Starbound server configuration!---"
        sleep infinity
    fi
else
	echo "---Starbound server configuration found!---"
fi
chmod -R 770 ${DATA_DIR}
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/starbound_server ${GAME_PARAMS}
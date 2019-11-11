#!/bin/bash
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}
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
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login ${USERNAME} ${PASSWRD} \
    +quit
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
        ${STEAMCMD_DIR}/steamcmd.sh \
        +login ${USERNAME} ${PASSWRD} \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +login ${USERNAME} ${PASSWRD} \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} \
        +quit
    fi
fi

#echo "---Prepare Server---"
#echo "---Checking for 'Server.cfg'---"
#if [ ! -f ${SERVER_DIR}/Server.cfg ]; then
#	echo "---'Server.cfg' not found, downloading...---"
#	cd ${SERVER_DIR}
#    wget -qi Server.cfg https://raw.githubusercontent.com/ich777/docker-steamcmd-server/squad/config/Server.cfg
#	if [ ! -f ${SERVER_DIR}/Server.cfg ]; then
#		echo "-----------------------------------------------------------------------------------------"
#		echo "---Something went wrong can't download 'Server.cfg' Putting server in sleep mode!---"
#		echo "-----------------------------------------------------------------------------------------"
#		sleep infinity
#	fi
#else
#	echo "---'Server.cfg' folder found---"
#fi

chmod -R 777 ${DATA_DIR}
echo "---Server ready---"

echo "---Sleep zZz...---"
sleep infinity

echo "---Start Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/SquadGameServer.sh ${GAME_PARAMS}
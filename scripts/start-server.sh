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
        +@sSteamCmdForcePlatformType windows \
        +login anonymous \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +login anonymous \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} \
        +quit
    fi
else
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +login ${USERNAME} ${PASSWRD} \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +login ${USERNAME} ${PASSWRD} \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} \
        +quit
    fi
fi

if [ ! -z "${WS_CONTENT}" ]; then
	echo "---Installing Workshop Content with ID('s): ${WS_CONTENT}---"
	${STEAMCMD_DIR}/steamcmd.sh \
	+@sSteamCmdForcePlatformType windows \
	+login ${USERNAME} ${PASSWRD} \
    +force_install_dir ${SERVER_DIR} \
	+workshop_download_item 440900 ${WS_CONTENT// / +workshop_download_item 440900  } \
	+quit
fi

echo "---Prepare Server---"
chmod -R 777 ${DATA_DIR}
#echo "---Checking if WINE workdirectory is present---"
#if [ ! -d ${DATA_DIR}/.wine ]; then
#	echo "---WINE workdirectory not found, creating please wait...---"
#    winecfg > /dev/null 2>&1
#    sleep 15
#else
#	echo "---WINE workdirectory found---"
#fi
echo "---Server ready---"

echo "---Sleep zZz...---"
sleep infinity

wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
apt-get install cabextract


echo "---Start Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/srcds_run -game ${GAME_NAME} ${GAME_PARAMS} -console +port ${GAME_PORT}
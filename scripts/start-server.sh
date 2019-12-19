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

echo "---Prepare Server---"
echo "---Checking for 'server.cfg'---"
if [ ! -f ${SERVER_DIR}/swarm/cfg/server.cfg ]; then
    cd ${SERVER_DIR}/swarm/cfg
    wget -qi ${SERVER_DIR}/swarm/cfg/server.cfg https://raw.githubusercontent.com/ich777/docker-steamcmd-server/alienswarm/config/server.cfg
    if [ -f ${SERVER_DIR}/swarm/cfg/server.cfg ]; then
    	echo "---'server.cfg' successfully downloaded---"
    else
    	echo "---Something went wrong, can't download 'server.cfg'---"
        sleep infinity
    fi
fi
export WINEARCH=win32
export WINEPREFIX=/serverdata/serverfiles/WINE
export DISPLAY=:99
echo "---Checking if WINE workdirectory is present---"
if [ ! -d ${SERVER_DIR}/WINE ]; then
	echo "---WINE workdirectory not found, creating please wait...---"
    mkdir ${SERVER_DIR}/WINE
else
	echo "---WINE workdirectory found---"
fi
echo "---Checking if WINE is properly installed---"
if [ ! -d ${SERVER_DIR}/WINE/drive_c/windows ]; then
	echo "---Setting up WINE---"
    cd ${SERVER_DIR}
    winecfg > /dev/null 2>&1
    sleep 15
else
	echo "---WINE properly set up---"
fi
echo "---Checking for old display lock files---"
find /tmp -name ".X99*" -exec rm -f {} \; > /dev/null 2>&1
echo "---Checking for old logfiles---"
find ${SERVER_DIR} -name "XvfbLog.*" -exec rm -f {} \; > /dev/null 2>&1
chmod -R 777 ${DATA_DIR}
echo "---Server ready---"

echo "---Starting Xvfb server---"
screen -S Xvfb -L -Logfile ${SERVER_DIR}/XvfbLog.0 -d -m /opt/scripts/start-Xvfb.sh
sleep 5

echo "---Start Server---"
cd ${SERVER_DIR}
xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine start srcds.exe -console -game ${GAME_NAME} ${GAME_PARAMS} +port ${GAME_PORT}
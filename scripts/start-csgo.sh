#!/bin/bash
if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
    echo "Steamcmd not found!"
    wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
    tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
    rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
    chmod -R 774 ${STEAMCMD_DIR}/steamcmd.sh ${STEAMCMD_DIR}/linux32/steamcmd
    ln -s ${STEAMCMD_DIR}/linux32/steamclient.so ~/.steam/sdk32/steamclient.so
fi

echo "---Update steamcmd---"
${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +quit
    
echo "---Update server---"
${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +force_install_dir $SERVER_DIR \
    +app_update $GAME_ID \
    +quit
    
echo "---Start Server---"
${SERVER_DIR}/srcds_run -game $GAME_NAME -usercon -console $GAME_PARAMS +ip 0.0.0.0 +port 27015 +sv_lan 0

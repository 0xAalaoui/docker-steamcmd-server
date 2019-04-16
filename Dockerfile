FROM ubuntu

MAINTAINER ich777

RUN apt-get update
RUN apt-get -y install lib32gcc1 libc6-i386 wget language-pack-en

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="template"
ENV GAME_NAME="template"
ENV GAME_PARAMS="template"
ENV GAME_PORT=27015
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR
RUN mkdir $STEAMCMD_DIR
RUN mkdir $SERVER_DIR
RUN useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID steam
RUN chown -R steam $DATA_DIR

# RUN wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz \
#  &&  tar --directory ${STEAMCMD_DIR} -xvzf ${STEAMCMD_DIR}/steamcmd_linux.tar.gz \
#  &&  rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz \
#  &&  chmod -R 774 $STEAMCMD_DIR  $SERVER_DIR 
RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 774 /opt/scripts/
RUN chown -R steam /opt/scripts

USER steam

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]

#!/bin/bash

printf "\033[0;32m==> \033[0m"
printf "\033[1mStart docker containers\033[0m\n"
sudo docker run -d --name=qbittorrent -e TZ=Asia/Shanghai \
                -e PUID=$(id -u serveradmin) -e PGID=$(id -g serveradmin) -e UMASK_SET=002 \
                -e WEBUI_PORT=8080 -p 20915:20915 -p 20915:20915/udp -p 8080:8080 \
                -v /home/serveradmin/.config/qbittorrent:/config \
                -v /home/serveradmin/Downloads:/downloads --restart unless-stopped \
                linuxserver/qbittorrent
printf "\033[1mqBittorrent run at port 8080\033[0m\n"
sudo docker run -d --name=plex --net=host --device=/dev/dri:/dev/dri \
                -e PUID=$(id -u serveradmin) -e PGID=$(id -g serveradmin) -e UMASK_SET=002 \
                -v /home/serveradmin/Plex:/config -v /home/serveradmin/Downloads/TV:/tv \
                -v /home/serveradmin/Downloads/Movies:/movies --restart unless-stopped \
                linuxserver/plex
printf "\033[1mPlex run at port 32400\033[0m\n"
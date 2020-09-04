#!/bin/bash
# -*- coding:utf-8 -*-

CONTAINER_NAME="kali_env"
sudo docker build ./ -t kali-env:latest
read -p "enter name of new container (leave empty for default [kali_env]): " CONTAINER_NAME
read -p "enter username: " USERNAME
if [ "$(echo -n $USERNAME | wc -m)" -gt "0" ]; then
    read -p "Do you want to share directory of host with container? [Y/N]" q0
    if [ "$q0" = "Y" -o "$q0" = "y" ];then
        read -p "Enter path of directory to share [default: $HOME/.docker/kali-env/volume]: " SHAREPATH
        if [ "$(echo -n $SHAREPATH | wc -m)" -gt 0 ];then
            if [ $(ls -l "$SHAREPATH" | grep $USER) -gt 0 ];then
                mkdir -p $SHAREPATH
                sudo docker run --name $CONTAINER_NAME -u $USERNAME -it -v $SHAREPATH:/home/$USERNAME/share kali-env:latest
            fi
        else
            mkdir -p $HOME/.docker/kali-env/volume
            sudo docker run --name $CONTAINER_NAME -u $USERNAME -it -v $HOME/.docker/kali-env/volume:/home/$USERNAME/share kali-env:latest
        fi
    else
        sudo docker --name $CONTAINER_NAME -u $USERNAME -it kali-env:latest
    fi
else
    echo "InvalidUsername: username connot be blank"
fi
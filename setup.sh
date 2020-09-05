#!/bin/sh
# -*- coding:utf-8 -*-

CMDNAME=$(basename $0)

while getopts rup OPT
do
    case $OPT in
        "r" ) FLG_A="True" ;;
        "u" ) FLG_B="True" ;;
        "p" ) FLG_C="True" ;;
          * ) echo "How to use \"setup.sh\" for kali-env Dockerfile:"
              echo "  [-r ] set password for root user. (leave blank for empty password. NOT RECOMMENDED)"
              echo "  [-u ]      set name for new user."
              echo "  [-p ] set password for new user. (leave blank for empty password. NOT RECOMMENDED)" 1>&2
              exit 1;;
    esac
done

if [ "$FLG_A" = "True" ]; then
    read -p "Enter password for root: " ROOTPASSWORD
    sed -i.bak -e "s#root_passwd#$ROOTPASSWORD#" Dockerfile
    echo -e "root password has been set with:\\n    $ROOTPASSWORD"
fi

if [ "$FLG_B" = "True" ]; then
    read -p "Enter name of new user: " USERNAME
    if [ "$(echo -n $USERNAME | wc -m)" -gt "0" ]; then
        sed -i.bak -e "s#username#$USERNAME#" Dockerfile
        echo -e "username set with\\n    $USERNAME"
    fi
fi

if [ "$FLG_C" = "True" ]; then
    read -p "Enter password for new user: " USERPASSWORD
    if [ "$(echo -n $USERPASSWORD | wc -m)" -gt "0" ];then
        sed -i.bak "s/user_passwd/$USERPASSWORD/" Dockerfile
        echo -e "password for new user has been set with \\n    $USERPASSWORD"
    fi
fi

exit 0

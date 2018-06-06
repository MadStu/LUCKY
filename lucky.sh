#!/bin/bash
# MadStu's Small Install Script
cd ~
wget https://raw.githubusercontent.com/MadStu/LUCKY/master/newluckymn.sh
chmod 777 newluckymn.sh
sed -i -e 's/\r$//' newluckymn.sh
./newluckymn.sh

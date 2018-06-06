#!/bin/bash
clear
sleep 1
if [ -e getinfo.json ]
then
	echo " "
	echo "Script running already?"
	echo " "

else
echo "blah" > getinfo.json

sudo apt-get install jq pwgen -y

#killall luckybitd
#rm -rf luck*
#rm -rf .luck*

mkdir ~/luckybit
cd ~/luckybit
wget https://github.com/luckybitcoin/luckycore/releases/download/v1.0/Ubuntu-16-04.tar.gz
tar -xvzf Ubuntu-16-04.tar.gz
rm Ubuntu-16-04.tar.gz
cd ~

mkdir ~/.luckybitcore
RPCU=$(pwgen -1 4 -n)
PASS=$(pwgen -1 14 -n)
EXIP=$(curl ipinfo.io/ip)
printf "rpcuser=rpc$RPCU\nrpcpassword=$PASS\nrpcport=7617\nrpcthreads=8\nrpcallowip=127.0.0.1\nbind=$EXIP:7717\nmaxconnections=32\ngen=0\nexternalip=$EXIP\ndaemon=1\n\naddnode=13.56.185.101:7717\naddnode=159.203.16.103:7717\naddnode=18.218.69.144:7717\naddnode=185.242.112.192:7717\naddnode=199.247.22.101:7717\naddnode=207.148.85.0:7717\naddnode=45.76.230.247:7717\naddnode=54.219.56.214:7717\naddnode=85.121.196.197:7717\naddnode=159.65.27.95:7717\naddnode=193.242.150.251:7717\naddnode=199.247.13.36:7717\naddnode=185.243.131.37:7717\naddnode=108.61.99.182:7717\n\n\n" > ~/.luckybitcore/luckybit.conf

~/luckybit/luckybitd -daemon
sleep 20
MKEY=$(~/luckybit/luckybit-cli masternode genkey)

~/luckybit/luckybit-cli stop
printf "masternode=1\nmasternodeprivkey=$MKEY\n\n" >> ~/.luckybitcore/luckybit.conf
sleep 10
~/luckybit/luckybitd -daemon







sleep 10
ARRAY=$(~/luckybit/luckybit-cli getinfo)
echo "$ARRAY" > getinfo.json
BLOCKCOUNT=$(curl http://178.62.73.188:3001/api/getblockcount)
WALLETBLOCKS=$(jq '.blocks' getinfo.json)
while [ "$menu" != 1 ]; do
	case "$WALLETBLOCKS" in
		"$BLOCKCOUNT" )      
			echo "Complete!"
			menu=1
			break
			;;
		* )
			clear
			echo " "
			echo " "
			echo "  Keep waiting..."
			echo " "
			echo "  Blocks required: $BLOCKCOUNT"
			echo "    Blocks so far: $WALLETBLOCKS"
			echo " "
			echo " "
			echo " "
			echo "  - If you see any errors or 'Blocks required' is blank,"
			echo "    you are safe to exit from this screen by holding:"
			echo "    CTRL + C"
			echo " "
			echo "  - Holding CTRL + C will exit this script and the block"
			echo "    sync will then continue in the background."
			echo " "
			echo "  - If you exit this script early, you'll need to grab the"
			echo "    masternode genkey yourself from the race.conf file."
			echo " "
			sleep 20
			BLOCKCOUNT=$(curl http://178.62.73.188:3001/api/getblockcount)
			ARRAY=$(~/luckybit/luckybit-cli getinfo)
			echo "$ARRAY" > getinfo.json
			WALLETBLOCKS=$(jq '.blocks' getinfo.json)
			;;
	esac
done
#echo "Now wait for AssetID: 999..."
sleep 1
MNSYNC=$(~/luckybit/luckybit-cli mnsync status)
echo "$MNSYNC" > mnsync.json
ASSETID=$(jq '.AssetID' mnsync.json)
echo "Current Asset ID: $ASSETID"
ASSETTARGET=999
while [ "$meanu" != 1 ]; do
	case "$ASSETID" in
		"$ASSETTARGET" )      
			clear
			echo " "
			echo " "
			echo "  No more waiting :) "
			echo " "
			echo "  AssetID: $ASSETID"
			sleep 2
			meanu=1
			break
			;;
		* )
			clear
			echo " "
			echo " "
			echo "  Keep waiting... "
			echo " "
			echo "  Looking for: 999"
			echo "      AssetID: $ASSETID"
			echo " "
			echo " "
			echo " "
			echo "  - If you see any errors, you are safe"
			echo "    to exit from this screen by holding:"
			echo "    CTRL + C"
			echo " "
			echo "  - Holding CTRL + C will exit this script and the"
			echo "    block sync will then continue in the background."
			echo " "
			echo "  - If you exit this script early, you'll need to grab the"
			echo "    masternode genkey yourself from the race.conf file."
			echo " "
			sleep 5
			MNSYNC=$(~/luckybit/luckybit-cli mnsync status)
			echo "$MNSYNC" > mnsync.json
			ASSETID=$(jq '.AssetID' mnsync.json)
			;;
	esac
done
rm mnsync.json
echo " "
echo " "
~/luckybit/luckybit-cli mnsync status
echo " "




sleep 3 
echo " "
echo " "
echo "Now would be a good time to setup your Transaction ID and VOUT from your windows wallet"
echo " "
sleep 3
echo "You'll need the Masternode Key which is:"
echo "$MKEY"
echo " "
sleep 3
echo "You'll also need your server IP which is:"
echo "$EXIP"
echo " "
sleep 2
echo "=================================="
echo " "
echo "So your masternode.conf should start with:"
echo " "
THISHOST=$(hostname -f)
echo "$THISHOST $EXIP:7717 $MKEY TXID VOUT"
echo " "
echo "=================================="
echo " "
echo "Your server hostname is $THISHOST and you can change it to MN1 or MN2 or whatever you like"
echo " "
sleep 3
echo " "
echo "  - You can now Start Alias in the windows wallet!"
echo " "
echo "       Thanks for using MadStu's Install Script"
echo " "


rm getinfo.json

fi


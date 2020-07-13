#!/bin/sh

set -e

ROUTER_ID=`ip -4 -o a | while read num intf inet addr; do
    case $intf in
	# Allow for "eth0", "ens5", "enp0s3" etc.; avoid "lo" and
	# "docker0".
	e*)
	    echo ${addr%/*}
	    break
	    ;;
    esac
done`

if [ -z "$ROUTER_ID" ]; then
    ROUTER_ID='127.0.0.1'
fi

# Update bird.conf and bird6.conf
sed -i "s/BIRD_ROUTERID/${ROUTER_ID}/g" /etc/bird.conf
sed -i "s/BIRD_ROUTERID/${ROUTER_ID}/g" /etc/bird6.conf

# Start bird and bird6 (which will both daemonize)
bird
bird6

# Loop sleeping
while true; do
    sleep 60
done

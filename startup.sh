#!/bin/bash

echo "* start ssh daemon"
/etc/init.d/ssh start

echo "* setuid root tcpdump"
chmod 4755 /usr/sbin/tcpdump

echo "* enable run traccia"
chmod a+x /usr/local/sbin/traccia

# Stay up forever
tail -f /dev/null




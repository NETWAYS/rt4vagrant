#!/bin/bash

RTHOME=${RTHOME:-/vagrant/vendor/rt}
RTCACHE=${RTCACHE:-$RTHOME/var/mason_data/obj}
SCRIPT=${SCRIPT:-$RTHOME/sbin/rt-server}

if [ ! -d $RTHOME ]; then
    echo "RTHOME does not exist: $RTHOME"
    exit 1
fi

if [ ! -d $RTCACHE ]; then
    mkdir -p $RTCACHE
fi

if [ ! -x $SCRIPT ]; then
    echo "Start script does not exist: $SCRIPT"
    exit 1
fi

rm -rf $RTCACHE/*

cd $DIR

exec $SCRIPT

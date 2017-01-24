#!/bin/bash

DIR=/vagrant/vendor/rt
SCRIPT=$DIR/sbin/rt-server

cd $DIR

exec $SCRIPT

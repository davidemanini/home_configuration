#! /bin/bash

# Share the configuration files contained in the config/ directory.

# Written by Davide Manini
# Last update: Oct 19, 2019

destinations="ant lll.fisica.unimi.it mac2 10.8.0.10 zorn.maths sam-usb asd"


function copy_locally () {
    rsync -rv config/ $HOME
}

function copy_remote () {
    echo "Sending to " $i ...
    rsync -rv -e ssh config/ $1:
}

copy_locally

for i in $destinations
do
    if test $i != $HOSTNAME
    then
        copy_remote $i
    fi
done

       

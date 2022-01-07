#! /bin/bash

echo pippo

case $1 in
    Shutdown)
        if zenity --question --text="Shutdown?"
        then
	    dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop
	    exit $?
        else
            exit 0
        fi
        ;;
    Reboot)
        if zenity --question --text="Reboot?"
        then
	    dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart
	    exit $?
        else
            exit 0
        fi
        ;;
    Suspend)
	if zenity --question --text="Suspend?"
	then
	    dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend || dbus-send --print-reply --system --dest=org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager.Suspend boolean:true
	    a="$?"
#	    killall pulseaudio; start-pulseaudio-x11

	    exit $a
	else
	    exit 0
	fi
	;;
    Hibernate)
        if zenity --question --text="Hibernate?"
        then
            dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Hibernate || dbus-send --print-reply --system --dest=org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager.Hibernate boolean:true
	    exit $?
        else
            exit 0
        fi
        ;;
    *)
	echo "Usage: $0 <Shutdown|Reboot|Suspend|Hibernate>"
	exit 1
	;;
esac

#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        # shellcheck source=/dev/null
        [ -x "$f" ] && . "$f"
    done
    unset f
fi


# set the background
if [ -f /usr/bin/feh ]; then
    feh --bg-scale ~/.wallpaper.jpg &
fi

# turn off the cpu default bell
if [ -f /usr/bin/xset ]; then
    xset -b
fi

# enable window compositing
if [ -f /usr/bin/compton ]; then
    compton --config "$HOME/.config/i3/compton.conf" --daemon
fi

# enable touchpad basics
if [ -f /usr/bin/xinput ]; then
    xinput set-prop "AlpsPS/2 ALPS GlidePoint" \
        "libinput Tapping Enabled" 1 &
    xinput set-prop "AlpsPS/2 ALPS GlidePoint" \
        "libinput Natural Scrolling Enabled" 1 &
fi

# start redshift
if [ -f /usr/bin/redshift ]; then
    redshift &
fi

# Here i3 is kept as default
session=${1:-i3}

case $session in
    i3|i3wm           ) exec i3;;
    awesome|awesomewm        ) exec awesome;;
    # No known session, try to run it as command
    *                 ) exec $1;;
esac

#!/bin/sh

static=static-firefox
link=firefox
volatile=$HOME/.mozilla/firefox-caches/firefox-$USER

IFS=
set -efu

cd $HOME/.mozilla

if [ ! -r $volatile ]; then
	mkdir -p -m0700 $volatile
fi

if [ "$(readlink $link)" != "$volatile" ]; then
	mv $link $static
	ln -s $volatile $link
fi

if [ -e $link/.unpacked ]; then
	rsync -av --delete --exclude .unpacked ./$link/ ./$static/
    logger -t firefox_profile_sync "profile sync done."
else
	rsync -av ./$static/ ./$link/
	touch $link/.unpacked
    logger -t firefox_profile_sync "first touch done."
fi

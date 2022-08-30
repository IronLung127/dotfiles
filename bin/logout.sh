#!/bin/sh

case "$(printf "lock\\nsuspend\\nhibernate\\nlogout\\nreboot\\npoweroff" | dmenu -l 10 -p "⏻ ")" in
	lock) betterlockscreen -l ;;
	suspend) systemctl suspend ;;
	hibernate) systemctl hibernate ;;
	logout) killall xinit;;
	reboot) systemctl reboot ;;
	poweroff) systemctl poweroff ;;
esac

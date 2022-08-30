#!/usr/bin/env bash

declare -a playlists=(
"lofi chill ~ https://www.youtube.com/watch?v=d9M-YFxikvI"
"Advait bedroom pop to calm anxitey ~ https://www.youtube.com/watch?v=K4Icg1K3QE8"
"sad lofi for lost souls ~ https://www.youtube.com/watch?v=7k9FBNqGhBg"
"the lonliest feeling in the world ~ https://www.youtube.com/watch?v=7AHGD1IvssY"
"exit"
)

choice=$(printf '%s\n' "${playlists[@]}" | dmenu -i -l 20 -p 'play playlists: ')

if [[ "$choice" == "exit" ]];then
    exit
else
    link=$(printf '%s\n' "${choice}" | awk '{print $NF}' )
    alacritty -e mpv --no-video "$link"
fi
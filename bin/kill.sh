
#!/usr/bin/env bash

# dmenu theming
lines="-l 20"
font="-fn Inconsolata-13"
colors="-nb #2C323E -nf #9899a0 -sb #BF616A -sf #2C323E"

selected="$(ps -a -u $USER | \
            dmenu -i -p "process to murder:" \
            $lines $font | \
            awk '{print $1" "$4}')"; 

if [[ ! -z $selected ]]; then

    answer="$(echo -e "Yes\nNo" | \
            dmenu -i -p "$selected will be murdered, are you sure?" \
            $lines $font )"

    if [[ $answer == "Yes" ]]; then
        selpid="$(awk '{print $1}' <<< $selected)"; 
        kill -9 $selpid
    fi
fi

exit 0

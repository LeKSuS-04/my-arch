#!/bin/bash

number_of_desktops=0
focused_desktop=0
active_desktops=()

desktop_changed() {
    while read -r _unsued
    do
        # When ANYTHING changes, poll new information
        cmd_output=$(xprop -root _NET_NUMBER_OF_DESKTOPS _NET_CURRENT_DESKTOP _NET_CLIENT_LIST_STACKING)

        # Get data about amount of desktops
        found_number_of_desktops=$(echo "$cmd_output" | 
                                    perl -wnE 'say /_NET_NUMBER_OF_DESKTOPS\(CARDINAL\) = (\d+)/g')
        if [ "$found_number_of_desktops" != "" ]; then      # if data exists,
            number_of_desktops=$found_number_of_desktops    # then change saved value to it
        fi

        # Get data about currently focused desktop
        found_focused_desktop=$(echo "$cmd_output" | 
                                    perl -wnE 'say /_NET_CURRENT_DESKTOP\(CARDINAL\) = (\d+)/g')
        if [ "$found_focused_desktop" != "" ]; then     # if data exists,
            focused_desktop=$found_focused_desktop      # then change saved value to it
        fi

        # Get data about active windows and their order
        found_active_windows=$(echo "$cmd_output" | 
                                    perl -wnE 'say /_NET_CLIENT_LIST_STACKING/g')
        if [ "$found_active_windows" != "" ]; then
            # If found, parse it
            active_windows_str=$(echo "$cmd_output" |
                                    perl -wnE 'say join(" ", /0x[0-9A-Fa-f]+/g)' |
                                    awk NF)
            IFS=" " read -r -a active_windows <<< "$active_windows_str"

            # Using associative array as hashset
            active_desktops_associative=()

            for window_id in "${active_windows[@]}"     # For each window
            do
                desktop=$(xprop -id "$window_id" _NET_WM_DESKTOP |
                            perl -wnE 'say /_NET_WM_DESKTOP\(CARDINAL\) = (\d+)/g')
                active_desktops_associative[desktop]=1      # Mark this desktop as active
            done

            # Set active desktops to those values, that are present in hashset
            active_desktops=("${!active_desktops_associative[@]}")
        fi

        # Hackish json-like printing
        echo -n "["
        for ((i=0; i < number_of_desktops; i++))
        do
            # Is this workspace active?
            echo -n '{"is_active":'
            if [[ " ${active_desktops[*]} " =~ $i ]]; then
                echo -n "true"
            else
                echo -n "false"
            fi

            # Does this workspace have focus?
            echo -n ', "is_focused": '
            if (( focused_desktop == i )); then
                echo -n "true"
            else
                echo -n "false"
            fi
            echo -n "}"

            # If this workspace is not last, put comma after it (to build valid json)
            if (( i + 1 < number_of_desktops )); then
                echo -n ", "
            fi
        done
        echo "]"
    done
}

xprop -spy -root _NET_ACTIVE_WINDOW _NET_NUMBER_OF_DESKTOPS _NET_CURRENT_DESKTOP | desktop_changed

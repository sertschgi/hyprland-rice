#!/usr/bin/env bash

export LIFETIME=2000 # I just watched 'I Want To Eat Your Pancreas' so... I am a bit emotional right now... (I rate it a 10/10 for sure!)

json_field () {
    echo -n "\"$1\":\"$2\""

    [[ "$3" == "1" ]] && echo -n ","
}

time_24h="$(date '+%H:%M')"
time_12h="$(date '+%I:%M %p')"
time_date="$(date '+%A, %B %d, %Y')"

# Fix the 12 hour time if AM/PM isn't found... (I have a friend from Austria who has issues with this.)
if echo "$time_12h" | grep -iE 'AM|PM' > /dev/null 2>&1; then
    : # Do nothing.
else
    trimmed_display="$(echo "$time_12h" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

    minute_segment="$(echo "$time_24h" | cut -f2 -d ':')"
    hour_segment="$(echo "$time_24h" | cut -f1 -d ':')"
    am_pm="AM"

    if [[ "$hour_segment" -gt 12 ]]; then
        am_pm="PM"
        hour_segment=$(( ${hour_segment} - 12 ))
    fi

    time_12h="${hour_segment}:${minute_segment} ${am_pm}"
fi

hit_a_click=1

if [[ "$1" == "click-middle" ]]; then
    notify-send -e -t "${LIFETIME}" "Uptime is..." "$(uptime -p | sed 's/up //')"
elif [[ "$1" == "click-left" ]]; then
    notify-send -e -t "${LIFETIME}" "The date is..." "$time_date"
elif [[ "$1" == "click-right" ]]; then
    notify-send -e -t "${LIFETIME}" "12h -> 24h is..." "$time_12h -> $time_24h"
else
    hit_a_click=0
fi

[[ $hit_a_click == 1 ]] && exit

json_tooltip="$time_date"
json_text="$time_12h"

echo -n "{"
json_field 'text' "$json_text" 1
json_field 'tooltip' "$json_tooltip" 0
echo "}"

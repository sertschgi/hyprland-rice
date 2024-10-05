#!/usr/bin/env bash

notify-send -et 1000 "Re-copy..."
wl-copy "$(wl-paste)" || notify-send -u critical "Failed to re-copy!"

#!/usr/bin/bash

project_name=-home-bate-path-to-project  # TODO: compute from current path

if argument length = 1: program = $1
else; show error and report usage, ask to use pueue_add.sh 'cmd arg1 arg2'.

# 1. `pueue status` to check if daemon is started, start with `pueued -d` if not

# 2.
pueue group add -p 0 "$project_name"  # if not exist yet

# 3.
id=$(pueue add -g "$project_name" "$program")

# 4.
if id is empty; echo error failed to start; exit 1; fi

pueue follow $id

#!/usr/bin/env bash

. "./functions.sh"

repo="borgified%2Ftravis_job1"
id=$(trigger_job $repo)

status=$(wait_for "$repo" "$id")

if [ "$status" = "passed" ]; then
  exit 0
else
  exit 1
fi

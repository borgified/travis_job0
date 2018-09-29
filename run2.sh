#!/usr/bin/env bash

. "./functions.sh"

repo="borgified%2Ftravis_job2"
id=$(trigger_job $repo)

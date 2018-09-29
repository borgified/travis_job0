#!/usr/bin/env bash

. "./functions.sh"

repo="borgified%2Ftravis_job1"
id=$(trigger_job $repo)

#!/usr/bin/env bash

set -e

body='{ "request": { "message": "Override the commit message: this is an api request", "branch":"master", "config": { "env": "MYVAR=var_from_job_0" } }}'
REPO='https://api.travis-ci.com/repo/borgified%2Ftravis_job1/requests'


curl -s -X POST \
 -H "Content-Type: application/json" \
 -H "Accept: application/json" \
 -H "Travis-API-Version: 3" \
 -H "Authorization: token $TOKEN" \
 -d "$body" \
$REPO

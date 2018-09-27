#!/usr/bin/env bash

set -e

body=$(cat <<EOF
{
  "request": { 
    "message": "Override the commit message: this is an api request",
    "branch":"master", 
    "config": { 
      "env": {
        "MYVAR": "var_from_job_0",
        "UPSTREAM_SHA": "$TRAVIS_PULL_REQUEST_SHA",
        "UPSTREAM_REPO": "$TRAVIS_PULL_REQUEST_SLUG"
      }
    }
  }
}
EOF
)

echo $body

REPO='https://api.travis-ci.com/repo/borgified%2Ftravis_job2/requests'


curl -s -X POST \
 -H "Content-Type: application/json" \
 -H "Accept: application/json" \
 -H "Travis-API-Version: 3" \
 -H "Authorization: token $TOKEN" \
 -d "$body" \
$REPO
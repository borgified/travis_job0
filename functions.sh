# helper functions

function trigger_job {

  local repo_slug=$1

  local body=$(cat <<EOF
{
  "request": { 
    "message": "Override the commit message: this is an api request",
    "branch": "master", 
    "config": {
      "merge_mode": deep_merge,
      "env": {
        "DEFAULT_SETTING": "default",
        "UPSTREAM_SHA": "$TRAVIS_PULL_REQUEST_SHA",
        "UPSTREAM_REPO": "$TRAVIS_PULL_REQUEST_SLUG"
      },
      "before_script": "STATE=pending ./update_build_status.sh",
      "script": ["./sleep.sh", "echo \$DEFAULT_SETTING", "echo \$SPECIAL_SETTING"],
      "after_success": "STATE=success ./update_build_status.sh",
      "after_failure": "STATE=failure ./update_build_status.sh"
    }
  }
}
EOF
)

echo $body

local REPO="https://api.travis-ci.com/repo/$repo_slug/requests"

local results=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Travis-API-Version: 3" \
  -H "Authorization: token $TOKEN" \
  -d "$body" \
  $REPO)

echo $results

echo $results | jq .id
}

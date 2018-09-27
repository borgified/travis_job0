# helper functions

function wait_for {
  #poll every 5 seconds until upstream job is finished
  local repo_slug = $1
  local id = $2

  while [ "$state" != "finished" ]; do
    local result=$(curl -s -H "Travis-API-Version: 3" -H "User-Agent: API Explorer" -H "Authorization: token $TOKEN" https://api.travis-ci.com/repo/$repo_slug/request/$id)
    local state=$(echo $result | jq -r .state)
    local build_id=$(echo $result | jq -r .builds[0].id)
    echo "waiting for upstream job (build_id: $build_id) to complete. its current state is: $state"
    sleep 5
  done

  local final_result=$(curl -s -H "Travis-API-Version: 3" -H "User-Agent: API Explorer" -H "Authorization: token $TOKEN" https://api.travis-ci.com/repo/$repo_slug/request/$id)
  local status=$(echo $final_result | jq -r .builds[0].state)

  return $status

}

function trigger_job {

  local repo_slug = $1

  local body=$(cat <<EOF
{
  "request": { 
    "message": "Override the commit message: this is an api request",
    "branch":"master", 
    "config": { 
      "env": {
        "UPSTREAM_SHA": "$TRAVIS_PULL_REQUEST_SHA",
        "UPSTREAM_REPO": "$TRAVIS_PULL_REQUEST_SLUG"
      }
    }
  }
}
EOF
)

local REPO="https://api.travis-ci.com/repo/$repo_slug/requests"

local results=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Travis-API-Version: 3" \
  -H "Authorization: token $TOKEN" \
  -d "$body" \
  $REPO)

return $(echo $results | jq .id)
}

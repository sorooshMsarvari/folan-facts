#!/bin/bash
set -euo pipefail

function cd_here() {
  cd $(dirname -- $BASH_SOURCE)
}

function get_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -d|--description)
        NEED_DESC=true
        shift # past argument
        ;;
      *)
        shift # past argument
        ;;
    esac
  done
}

function get_fact_num() {
  cat $FACTS_FILE | jq '. | length'
}

function get_random_fact() {
  FACT_NUM=$(get_fact_num)
  FACT_INDEX=$((RANDOM % FACT_NUM))
  jq -r --arg f_idx $FACT_INDEX '.[$f_idx | tonumber]' "$FACTS_FILE"
}


function print_fact() {
  local FACT=$(echo "$1" | jq -r '.fact')
  echo $FACT
}

function print_desc() {
  local DESC=$(echo "$1" | jq -r '.desc')
  echo $DESC
}

function print_random_fact() {
  FACT_OBJ=$(get_random_fact)
  print_fact "$FACT_OBJ"
  if $NEED_DESC
  then
    print_desc "$FACT_OBJ"
  fi
}

function main() {
  NEED_DESC=false
  FACTS_FILE="folan-facts.json"

  cd_here
  get_args "$@"

  print_random_fact
}

main "$@"
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
  fact_num=$(get_fact_num)
  fact_index=$((RANDOM % fact_num))
  jq -r --arg f_idx $fact_index '.[$f_idx | tonumber]' "$FACTS_FILE"
}

function echo_color() {
  local GREEN="\033[1;36m"
  local GRAY="\033[1;35m"
  local NC="\033[0m"

  local color
  case "$1" in
    -g)
      color="$GREEN"
      shift
      ;;
    -gr)
      color="$GRAY"
      shift
  esac

  echo -e "${color}$*${NC}"
}

function print_fact() {
  local fact=$(echo "$1" | jq -r '.fact')
  echo_color -g $fact
}

function print_desc() {
  local desc=$(echo "$1" | jq -r '.desc')
  echo_color -gr $desc
}

function print_banner() {
  local fact="$1"
  local desc="$2"

  cat "banner.txt"
  echo
  echo "$fact"
  echo "$desc"
}

function print_random_fact() {
  local fact_obj=$(get_random_fact)

  local fact=$(print_fact "$fact_obj")
  local desc=""
  if $NEED_DESC; then
    desc=$(print_desc "$fact_obj")
  fi

  print_banner "$fact" "$desc"
}

function main() {
  NEED_DESC=false
  FACTS_FILE="folan-facts.json"

  cd_here
  get_args "$@"

  print_random_fact
}

main "$@"
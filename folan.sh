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
  local PRIMARY="\033[1;36m"
  local SECONDARY="\033[1;35m"
  local BANNER="\033[1;33m"
  local NC="\033[0m"

  local color
  case "$1" in
    -p)
      color="$PRIMARY"
      shift
      ;;
    -s)
      color="$SECONDARY"
      shift
      ;;
    -b)
      color="$BANNER"
      shift
      ;;
  esac

  echo -e "${color}$*${NC}"
}

function print_fact() {
  local fact=$(echo "$1" | jq -r '.fact')
  echo_color -p $fact
}

function print_desc() {
  local desc=$(echo "$1" | jq -r '.desc')
  echo_color -s $desc
}

function print_banner() {
  local fact="$1"
  local desc="$2"
  local banner=$(cat "$BANNER_FILE")

  echo_color -b "$banner\n"
  echo -e "$fact"
  if [[ "$desc" != "" ]];then
    echo -e "\n$desc"
  fi
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
  BANNER_FILE="banner.txt"

  cd_here
  get_args "$@"

  print_random_fact
}

main "$@"
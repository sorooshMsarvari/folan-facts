#!/bin/bash
set -euo pipefail

function cd_here() {
  cd $(dirname -- $BASH_SOURCE)
}


function echo_color() {
  local PRIMARY="\033[1;36m"
  local SECONDARY="\033[1;35m"
  local BANNER="\033[1;33m"
  local ERROR="\033[0;31m"
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
    -e)
      color="$ERROR"
      shift
      ;;
  esac

  echo -e "${color}$*${NC}"
}

function validate_fact_index() {
  local NUMERIC_RE='^[0-9]+$'
  input=$1
  if [[ ! "$input" =~ $NUMERIC_RE ]]; then
    echo_color -e "invalid fact index"
    exit 1
  fi
}

function get_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -d|--description)
        DESC_FLAG=true
        shift # past argument
        ;;
      -s|--show-index)
        SHOW_INDEX_FLAG=true
        shift
        ;;
      -i|--index)
        validate_fact_index "$2"
        FACT_INDEX="$2"
        shift
        shift
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

function get_fact() {
  fact_num=$(get_fact_num)
  if [[ ${FACT_INDEX:-"unset"} == "unset" ]];then
    fact_index=$((RANDOM % fact_num))
  else
    fact_index=$FACT_INDEX
  fi

  jq -r --arg f_idx $fact_index '.[$f_idx | tonumber] + {"index": $f_idx}' "$FACTS_FILE"
}

function print_fact() {
  local fact=""
  if $SHOW_INDEX_FLAG; then
    fact="$(echo "$1" | jq -r '.index'). "
  fi
  fact+=$(echo "$1" | jq -r '.fact')
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
  local fact_obj=$(get_fact)

  local fact=$(print_fact "$fact_obj")

  local desc=""
  if $DESC_FLAG; then
    desc=$(print_desc "$fact_obj")
  fi

  print_banner "$fact" "$desc"
}

function main() {
  DESC_FLAG=false
  SHOW_INDEX_FLAG=false
  declare FACT_INDEX

  FACTS_FILE="folan-facts.json"
  BANNER_FILE="banner.txt"

  cd_here
  get_args "$@"

  print_random_fact
}

main "$@"
#!/bin/bash

NEED_DESC=false

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

FACT_NUM=$(cat folan-facts.json | jq '. | length')

FACT_INDEX=$(($RANDOM % $FACT_NUM))
FACT=$(cat folan-facts.json | jq -r --arg FACT_INDEX $FACT_INDEX '.[$FACT_INDEX | tonumber].fact')
echo $FACT

if $NEED_DESC
then
  DESC=$(cat folan-facts.json | jq -r --arg FACT_INDEX $FACT_INDEX '.[$FACT_INDEX | tonumber].desc')
  echo $DESC
fi

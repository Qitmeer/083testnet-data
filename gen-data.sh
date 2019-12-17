#!/bin/bash
force="false"
if [ "$1" == "-f" ]; then
  force="true"
  shift
fi

CLI=./cli.sh

if [ ! -f "$CLI" ]; then
  echo "$CLI not found!"
  exit
fi

FILE=./block-reward-0.8.3.txt

if [ "$force" == "true" ]; then
  rm -f $FILE
fi

if [ ! -f $FILE ]; then
  for ((num=38000; num<110001; num+=1))
  do
    block=$num 
    #echo "The  block : $block"
    var=$($CLI block $block|jq '.|"\(.transactions[0].vout[].scriptPubKey.addresses[]) \(.hash) \(.txsvalid) \(.confirmations)"' -r 2>&1)
    addr=`echo $var| cut -d' ' -f1`
    hash=`echo $var| cut -d' ' -f2`
    txsvalid=`echo $var| cut -d' ' -f3`
    confirm=`echo $var| cut -d' ' -f4`
    start="${addr:0:2}"
    if [ ! "${start}" == "Tm" ] ; then
      break 
    fi
    isblue=$($CLI isblue $hash)
    if [ ! "$isblue" -eq 1 ]; then
      echo "WARNING: NOT BULE $isblue $addr $hash $txsvalid $confirm"
    fi
    echo "$block $addr $hash $txsvalid $confirm $isblue" >> $FILE
done
fi

#!/bin/bash

DATA=./block-reward-0.8.3.txt

if [ ! -f $DATA ]; then
  echo "$DATA not found."
  exit
fi

function usage() {
  me=`basename "$0"`
  echo "$me"
  echo "    <addr>   check reward by address"
  echo "    -l       list reward ranking"
}

if [ -z $1 ]; then
  usage
  exit
fi

function valid_block() {
  cat $DATA|grep true
}

function invalid_block() {
  cat $DATA|grep false
}
if [ "$1" == "-l" ]; then
  FILE=./temp_reward_sum.txt
  touch $FILE
  valid_block|cut -d' ' -f2|sort|uniq -c|sort -n -r | while read -r count addr; do
    c=$(($count/30))
    addr=`echo $addr`
    if [ ! "$c" -lt 1 ]; then
      echo "$addr $count $(($c*65)) PMEER = ($count/30) * 65" >> $FILE
    fi 
  done
  cat $FILE
  echo "The totol reward is :  `cat $FILE | awk '{ sum += $3 } END { print sum }'` PMEER"
  rm $FILE
elif [ "${1:0:2}" == "Tm" ] ; then
  addr=$1
  count_valid=`echo $(valid_block|grep $addr|wc -l)`
  echo "----------------------------------------------------------------------"
  echo "The valid blocks are blue blocks (isblue=1) and their txvalid=true : "
  valid_block|grep $addr
  echo "----------------------------------------------------------------------"
  count_invalid=`echo $(invalid_block|grep $addr|wc -l)`
  echo "The invalid blocks are txvalid=false blocks or red blocks (isblue=0) :"
  invalid_block|grep $addr
  echo "-----------------------------------------------------------------"
  echo "The Block Reward for address $addr"
  echo "The valid block   : $count_valid"
  echo "The invalid block : $count_invalid"
  echo -n "The total rewards : " 
  echo "`echo "($count_valid/30)*65"|bc` PMEER = ($count_valid/30) * 65" 
fi

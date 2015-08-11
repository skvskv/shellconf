#!/bin/bash

# set manually all params
# and use the script to your good


INPUT_FILE="a.txt"
OUTPUT_FILE="a.txt.out"


START_MARKER="start-marker"
STOP_MARKER="stop-marker"


cat INPUT_FILE | awk 'begin {flag = 0 }; $0 ~ /${START_MARKER}/ {flag =1 }; $0 ~ /${STOP_MARKER}/ {flag =0}; {if (flag == 1) {print $0}} ' > OUTPUT_FILE

#getopts "s:d:i:o:t" A
#echo $?
#echo $A
#echo $OPTARG

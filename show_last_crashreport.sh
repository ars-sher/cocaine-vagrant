#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "This script prints the last crash report for the give app" >&2
  echo "Usage: $0 app_name" >&2
  exit 1
fi

last_report=`cocaine-tool crashlog list --name $1 | tail -2`
echo $last_report
timestamp=`echo $last_report | head -1 | awk '{print $1;}'`
cocaine-tool crashlog view -t $timestamp -n $1
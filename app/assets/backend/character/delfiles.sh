#!/bin/bash
echo $@
args=("$@")
find . -name "*.xml" -type f|xargs rm -f
find . -name "*.txt" -type f|xargs rm -f
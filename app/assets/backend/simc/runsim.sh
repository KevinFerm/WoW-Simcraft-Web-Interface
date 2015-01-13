#!/bin/bash
echo $@
args=("$@")
/home/simc/simc ${args[0]} calculate_scale_factors=1 iterations=5000 xml=${args[1]}.xml
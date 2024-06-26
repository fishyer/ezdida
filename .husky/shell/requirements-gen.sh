#!/bin/bash

# source ~/.bash_profile
# conda activate base
pipreqs . --force
sed '/fish_util.egg==info/d' requirements.txt > requirements.txt.tmp
mv requirements.txt.tmp requirements.txt
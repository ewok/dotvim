#!/bin/env bash

#cat vimrc| grep '" inst:' | awk '{print "test -d ~/.vim/pack/"$4"/"$5"/"$6" || git clone --depth 1  --recurse-submodules "$3" ~/.vim/pack/"$4"/"$5"/"$6}' | bash
#cat vimrc| grep '" inst:' | awk '{print "cd ~/.vim/pack/"$4"/"$5"/"$6";git pull --rebase"}' | bash

git submodule update --init --recursive

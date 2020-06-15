cat vimrc| grep '" inst:' | awk '{print "iplug add "$3}' > install.vim

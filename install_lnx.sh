cat vimrc| grep '" inst:' | awk '{print "cd ~/.vim/pack/"$4";git pull --rebase"}' | bash
cat vimrc| grep '" inst:' | awk '{print "git clone --recurse-submodules "$3" ~/.vim/pack/"$4}' | bash 
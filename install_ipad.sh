echo iplug add > install.vim

# awful I know
urls=$(cat vimrc| grep '" inst:' | awk '{print $3}')
names=$(cat vimrc| grep '" inst:' | awk '{print $6}')
opts=$(cat vimrc| grep '" inst:' | awk '{print $5}')

echo "  \ -t" >> install.vim
for i in $opts
do
    echo "   \,$i" >> install.vim
done

echo "  \ -n" >> install.vim
for i in $names
do
    echo "   \,$i" >> install.vim
done

for i in $urls
do
    echo "   \ $i" >> install.vim
done

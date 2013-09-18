#!/usr/bin/env bash

echo "swspoke() { cd \`python /home/brady/bin/swglob spokes \$1\`}" >> ~/.bash_aliases
echo "swspoke() { cd \`python /home/brady/bin/swglob projects/sparkweave \$1\`}" >> ~/.bash_aliases
echo "alias sshsw='ssh bouncer@10.21.7.69'" >> ~/.bash_aliases
echo "alias sp='swspoke'" >> ~/.bash_aliases
echo "alias pr='swproj'" >> ~/.bash_aliases

#! /bin/bash

config_dir=$(dirname $(realpath $0))


if [ "$1" = "" ]
then
    config_branch=HEAD
else
    config_branch=$1
fi

config_tree=`git --git-dir=$config_dir/.git log $config_branch -1 --pretty=oneline|awk '{print $1}'`



if git --git-dir=$config_dir/.git archive --format=tar  $config_tree .\*  | (cd $HOME; tar -x -f - --exclude=.gitignore) && echo $config_tree > $config_dir/config_commit && echo config_dir=$config_dir >> $HOME/.bashrc
then
    echo "Configuration successfully installed."
else
    echo "Failed installing configuration."
    exit 1
fi

#!/bin/bash
#!Author:ZhangDezhi
# Create Time:2021-04-24 20:08
# Last Modified  : 2022-04-06 09:10:13
# Name:symlink-vim.sh
# Version: v1.0
# Description: 代码格式化初始化



if [[ $(uname) == 'Linux' ]]; then
    #SCRIPT_DIR=$(readlink -f ${0 %/*}) #rhel当前脚本工作目录
    SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
fi

if [[ $(uname) == 'Darwin' ]]; then
    SCRIPT_DIR=$(
    cd $(dirname ${BASH_SOURCE:-$0}) #macOS 获得当前脚本工作目录
    pwd
    )
fi

#-------------------------------------------------------------------

echo "start init zsh ... "

rm $HOME/.clangformat
ln -s $SCRIPT_DIR $HOME/.clangformat

#rm $HOME/_clangformat
#ln -s $SCRIPT_DIR/clangformat $HOME/_clangformat

echo "init clangformat ok"



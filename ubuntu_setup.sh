#!/bin/bash

yes | sudo apt-get update
yes | sudo apt-get install vim-gtk3
yes | sudo apt-get install tmux
yes | sudo apt-get install git
yes | sudo apt-get install xclip
yes | sudo apt-get install openssh-server
sudo adduser $USER dialout

# enable ssh
sudo systemctl enable ssh
sudo systemctl start ssh

# .vimrcをコピーする
# .tmux.confをコピーする
# ターミナルのプロンプトを短くする
sed -i -e "s/PS1='\${debian_chroot:+(\$debian_chroot)}"'\\\[\\033\[01;32m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ '"'/PS1='\${debian_chroot:+(\$debian_chroot)}"'\\\[\\033\[01;32m\\\]\\u@:\\\[\\033\[01;34m\\\]\\W\\\[\\033\[00m\\\]\\\$ '"'/g" ~/.bashrc
sed -i -e "s/PS1='"'\${debian_chroot:+(\$debian_chroot)}\\u@\\h:\\w\\\$ '"'/PS1='\$\{debian_chroot:+(\$debian_chroot)}"'\\u@\\W\\\$ '"'/g" ~/.bashrc

# capslock->ctrl
sed -e 's/XKBOPTIONS=\"\"/XKBOPTIONS=\"ctrl:nocaps\"/g' /etc/default/keyboard | sudo tee /etc/default/keyboard
sudo systemctl restart console-setup

# 日本語フォルダ名を英語表記に変更
env LANGUAGE=C LC_MESSAGES=C xdg-user-dirs-gtk-update

# 日本語入力の有効化
sudo apt update
yes | sudo apt install ibus-mozc
ibus restart
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'jp'), ('ibus', 'mozc-jp')]"

# install ROS noetic
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
yes | sudo apt install curl # if you haven't already installed curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
yes | sudo apt update
yes | sudo apt install ros-noetic-desktop-full
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

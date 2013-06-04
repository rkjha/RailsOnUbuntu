#!/bin/bash
# A simple Script for installing Rails on Ubuntu 12.04 LTS / 12.10
# It will also install the dependencies required as well as the RVM
# Author: Ramesh Jha (ramesh@rameshjha.com),(http://blog.sudobits.com)
# License: MIT 

RUBY_VERSION="1.9.3"
LOG_FILE="$HOME/install.log"

echo "Rails Installer started"

# Installing Dependencies
echo -n "Updating package cache..."
sudo apt-get update >>$LOG_FILE
echo "Done"

echo -n "Installing git..."
sudo apt-get -y install git >>$LOG_FILE
echo "Done..."

echo -n "Installing Curl..."
sudo apt-get -y install curl >>$LOG_FILE
echo "Done"


# Install RVM (Ruby Version Manager)
echo -n "Installing RVM..."
curl -Ls get.rvm.io | bash -s stable >>$LOG_FILE

# fallback for the above command (in case of certificates errors)
#if ($? !=0)
# then
#  curl -kLs get.rvm.io | bash -s stable
#fi  

echo "Done"
echo -n "Loading RVM..."
source ~/.rvm/scripts/rvm >>$LOG_FILE
echo "Done.."

# Install Additional Dependencies
echo -n "Installing additional dependencies (this is a big one)..."
sudo apt-get -y install build-essential openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion

# Install nodejs from the PPA
apt-add-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get -y install nodejs

echo "Done"

# Install Latest version of Ruby
echo -n "Installing Ruby (v$RUBY_VERSION)..."
rvm install $RUBY_VERSION >>$LOG_FILE
echo "Done"

echo "If you want to install another version of ruby e.g 1.8.7"
echo "Then use the command 'rvm install 1.8.7' "

# Select and Set latest version of ruby as the default so that
# You won't have to select each time you start a terminal

echo -n "Setting the default version of Ruby..."
rvm --default use $RUBY_VERSION >>$LOG_FILE
echo "Done"

echo "Now, You are using Ruby $RUBY_VERSION by default"
echo "if you want to change that then use 'rvm --default <ruby_version>' "

# Install Latest version of Rails
echo -n "Installing Rails gem..."
gem install rails >>$LOG_FILE
echo "Done"


echo "######################################"
echo "###### Installation Completed ########"
echo "######################################"

if [ "$(which notify-send)" != "" ] then
  notify-send "Rails Intall Complete"
fi

echo "if something went wrong then checkout the log file $LOG_FILE"

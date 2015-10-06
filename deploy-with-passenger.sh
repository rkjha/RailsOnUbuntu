### Deploying Ruby/Rails/Sinatra Apps using Passenger 5 and nginx ###
### Server OS : Ubuntu 14.04 LTS 64 bit ###
### Author: Ramesh Jha (ramesh[at]rameshjha.com),(http://blog.sudobits.com)
### License: MIT

# Server Setup

ssh root@SERVER_IP_ADDRESS

apt-get update && apt-get upgrade
apt-get -y install python-software-properties nano

# Adding a swap (optional, required on Digital Ocean)
### 1 GB swap
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1024K
sudo mkswap /swapfile
sudo swapon /swapfile

### add it to fstab so it's activated on reboot
### `vi /etc/fstab` and add following line
/swapfile       none    swap    sw      0       0

### for security
sudo chown root:root /swapfile
sudo chmod 0600 /swapfile
### use `free -m` command to see if it's working or not

## Creating a user
adduser username --ingroup sudo

## Upload ssh key [dev machine]
ssh-copy-id username@IP_ADDRESS

# Installing Ruby using rbenv

## libs
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev

## rbenv
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

## ruby
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.1.5
rbenv global 2.1.5

echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler
rbenv rehash

# install nginx & passenger

## Adding passenger repository
## If you're using other than Ubuntu 14.04,
### check out this : https://www.phusionpassenger.com/documentation/Users%20guide%20Nginx.html#install_add_apt_repo
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
sudo apt-get install apt-transport-https ca-certificates
sudo sh -c "echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main' >> /etc/apt/sources.list.d/passenger.list"
sudo chown root: /etc/apt/sources.list.d/passenger.list
sudo chmod 600 /etc/apt/sources.list.d/passenger.list
sudo apt-get update

## Install nginx and passenger
sudo apt-get install nginx-extras passenger

## Setup ruby/passenger path in nginx config
sudo nano /etc/nginx/nignx.conf

## And check for these lines (uncomment passenger root value and add passenger ruby as required)
passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
passenger_ruby /home/rkjha/.rbenv/shims/ruby;

# nginx virtual server setup
sudo nano /etc/nginx/sites-available/example.com

## Find a sample configuration here
https://gist.github.com/rkjha/784e6654d6558dbaa29c

## create a symlink and remove the default site
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/example.com
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx reload

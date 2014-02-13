# A list of commands - for quickly setting up VPS for deploying Rails Application
# using nginx, Ubuntu(Latest Stable LTS : 12.04), Unicorn, MySQL and Capistrano
# Author: Ramesh Jha (ramesh@rameshjha.com),(http://blog.sudobits.com)
# License: MIT 

# change root password
# setting hostname (optional)
echo "<YOUR_HOSTNAME>" > /etc/hostname
hostname -F /etc/hostname

# Update System Packages
apt-get -y update
apt-get -y upgrade

# Adding a swap (optional, required on Digital Ocean)
# 1 GB swap
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1024K
sudo mkswap /swapfile
sudo swapon /swapfile

# add it to fstab so it's activated on reboot
# `vi /etc/fstab` and add following line
/swapfile       none    swap    sw      0       0

# for security
sudo chown root:root /swapfile
sudo chmod 0600 /swapfile
# use `free -m` command to see if it's working or not

# fix for locale error on Ubuntu (optional)
apt-get install --reinstall language-pack-en
locale-gen en_US.UTF-8

# for apt
apt-get -y install python-software-properties

# install git and curl
apt-get -y install curl git-core

# Install Server (nginx)
apt-add-repository -y ppa:nginx/stable
apt-get -y update
apt-get -y install nginx

# start/stop nginx (in Ubuntu 12.04 LTS)
sudo service nginx start
sudo service nginx stop
sudo service nginx restart

# or

sudo /etc/init.d/nginx start
sudo /etc/init.d/nginx stop
sudo /etc/init.d/nginx restart


# For Installing nodejs
sudo apt-add-repository -y ppa:chris-lea/node.js
sudo apt-get -y update
sudo apt-get -y install nodejs

# Create User and add it to sudo group
adduser example_user --ingroup sudo


## setup keys for ssh login

# On Local Computer
ssh-keygen
scp ~/.ssh/id_rsa.pub example_user@IP_ADDRESS:

# On remote server
mkdir .ssh
mv id_rsa.pub .ssh/authorized_keys


# Install MySQL Database and its Dependencies
sudo apt-get -y install mysql-server libmysql++-dev

# for sqlite error
sudo apt-get install libsqlite3-dev

#create a production database (mysql)
mysql -u root -p
create database YOUR_DB_NAME;
grant all on YOUR_DB_NAME.* to DB_USER@localhost identified by 'your_password_here';
exit

# alternate : installing postgresql
sudo apt-get install postgresql-9.1 postgresql-contrib-9.1 redis-server \
                     libxml2-dev libxslt-dev libpq-dev make g++

# Create your postgres user and database
sudo -u postgres psql
# \password
# create user blog with password 'secret';
# create database blog_production owner blog;
# \q

## update .bashrc according to rbenv installer's instruction
# install dependencies 
rbenv bootstrap-ubuntu-12-04

# latest ruby 
rbenv install 2.0.0-p353
rbenv install 2.0.0-p353
rbenv rehash
rbenv global 2.0.0-p353

# install bundler and rake
gem install bundler --no-ri --no-rdoc
gem install rake --no-ri --no-rdoc
rbenv rehash

# setup git and github or bitbucket or equivalent one!

# remove default nginx config
sudo rm /etc/nginx/sites-enabled/default


# deployment using capistrano && unicorn
# update gemfile

# Deploy with Capistrano
# update Gemfile
## gem 'capistrano'
## gem 'mysql2'
## gem 'unicorn'
## gem 'capistrano'

bundle

# now capify!!
capify .

## update capfile and config/deploy.rb
## add config/nginx.conf
## add unicorn.rb
## add unicorn_init.sh and make it executable
## add delayed job scripts (rails generate delayed_job && capistrano recepies)

## commit the latest changes and update database.yml (youmay want to add it to gitignore file and 
## and update it manually on the server, for security reasons, of course)

# Deploying to VPS
cap deploy:setup
cap deploy

# Run Database Migrations
cap deploy:migrate

# for delayed job and sending emails (if you're using)
cap deploy:start

## read this (and comment there) if you need any help : http://blog.sudobits.com/2013/01/07/how-to-deploy-rails-application-to-vps/




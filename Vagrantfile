# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 5000, host: 5000

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
  # print command to stdout before executing it:
  set -x
  set -e

  curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    curl -L https://get.rvm.io | bash -s stable --autolibs=enabled --ruby

  source "$HOME/.rvm/scripts/rvm"
  rvm install 2.3.1
  rvm use 2.3.1

  echo 'source "$HOME/.rvm/scripts/rvm"' >> .bashrc
  echo "rvm use 2.3.1" >> .bashrc

  # install postgres
  sudo apt-get -y install postgresql postgresql-contrib libpq-dev node npm git
  sudo -u postgres psql -c "CREATE USER vagrant WITH PASSWORD 'vagrant';"
  sudo -u postgres psql -c "ALTER USER vagrant CREATEDB;"

  echo "localhost:5432:*:vagrant:vagrant" > .pgpass
  chmod 0600 .pgpass

  sudo mv /usr/sbin/node /usr/sbin/node-bak
  sudo ln -s /usr/bin/nodejs /usr/bin/node
  sudo npm install -g phantomjs

  cd /vagrant

  gem install bundle
  cp .sample.env .env

  ./bin/setup
  SHELL
end

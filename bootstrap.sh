#!/usr/bin/env bash

echo "--------Postgresql, Git---------"
# fix problem reported here https://github.com/mitchellh/vagrant/issues/289
sudo apt-mark hold grub-pc

# upgrade system
apt-get update && sudo apt-get -y upgrade

apt-get -y install curl
# install git
apt-get -y install git-core
# install ruby developer packages
apt-get -y install make build-essential libssl-dev libreadline6-dev zlib1g-dev libyaml-dev libsqlite3-dev libssl-dev libc6-dev libpq-dev libcurl4-openssl-dev libksba8 libksba-dev libqtwebkit-dev
# nokogiri requirements
apt-get -y install libxslt-dev libxml2-dev
# headless requirements
apt-get -y install xvfb
# capybara-webkit requirements
apt-get -y install libqt4-dev
# install common DB and tools
apt-get -y install postgresql postgresql-contrib redis-server
# install warden dependencies https://docs.cloudfoundry.org/concepts/architecture/warden.html
apt-get install -y build-essential debootstrap

echo "Set up postgresql"
# fix permissions
echo "-------------------- fixing listen_addresses on postgresql.conf"
sudo sed -i "s/#listen_address.*/listen_addresses '*'/" /etc/postgresql/9.1/main/postgresql.conf

echo "-------------------- fixing postgres pg_hba.conf file"
sudo sed -i "s/peer/trust/;s/md5/trust;s/ident/trust" /etc/postgresql/9.1/main/pg_hba.conf

echo "-------------------- Restart postgresql-------------------"
sudo pg_ctlcluster 9.1 main reload

echo "--------Install goevnv--------"
rm -rf /home/vagrant/.goenv/
sudo -u vagrant git clone https://github.com/wfarr/goenv.git /home/vagrant/.goenv
sudo -u vagrant echo 'export PATH="$HOME/.goenv/bin:$PATH"' >> /home/vagrant/.profile
sudo -u vagrant echo 'eval "$(goenv init -)"' >> /home/vagrant/.profile

echo "-------Install rbenv and ruby_build-------"
rm -rf /home/vagrant/.rbenv/
sudo -u vagrant git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
sudo -u vagrant echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.profile
sudo -u vagrant echo 'eval "$(rbenv init -)"' >> /home/vagrant/.profile
sudo -u vagrant git clone git://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
sudo -u vagrant git clone git://github.com/dcarley/rbenv-sudo.git /home/vagrant/.rbenv/plugins/rbenv-sudo

echo "--------Install require Go Versions--------"
sudo -u vagrant -i goenv install 1.4
sudo -u vagrant -i goenv global 1.4
sudo -u vagrant -i go version
sudo -u vagrant -i goenv rehash

echo "--------Set up go path---------------------"
sudo -u vagrant echo 'export GOPATH=/vagrant/tmp/gopath' >> /home/vagrant/.profile
sudo -u vagrant echo 'export PATH="$GOPATH/bin:$PATH"' >> /home/vagrant/.profile

# no rdoc for installed gems
sudo -u vagrant echo 'gem: --no-ri --no-rdoc' >> /home/vagrant/.gemrc

echo "---------install required ruby versions------"
sudo -u vagrant -i rbenv install 2.1.6
sudo -u vagrant -i rbenv global 2.1.6
sudo -u vagrant -i ruby -v
sudo -u vagrant -i gem install bundler --no-ri --no-rdoc
sudo -u vagrant -i rbenv rehash

echo "---------install iptables v1.4.21-----------------"
#For ubuntu 12.04 64bit, the iptables version is 1.4.12 which does not have option -w for warden container
sudo apt-get -y remove iptables
wget http://www.netfilter.org/projects/iptables/files/iptables-1.4.21.tar.bz2
sudo tar -xjvf iptables-1.4.21.tar.bz2
sudo apt-get -y install make
cd iptables-1.4.21/
sudo ./configure --prefix=/usr   \
            --sbindir=/sbin \
            --enable-libipq \
            --with-xtlibdir=/lib/xtables &&
sudo make
sudo make install &&
sudo ln -sfv ../../sbin/xtables-multi /usr/bin/iptables-xml &&
for file in ip4tc ip6tc ipq iptc xtables
do
  sudo mv -v /usr/lib/lib${file}.so.* /lib &&
  sudo ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
done

echo "------------------Configure quota for warden------------------"
sudo apt-get -y install quota quotatool
#A little injection into /etc/fstab to run quota
sudo sed -i '9s/.*/\/dev\/mapper\/precise64-root \/               ext4    errors=remount-ro,usrquota,grpquota 0       0/' /etc/fstab
sudo touch /quota.user /quota.group
sudo chmod 600 /quota.*
sudo mount -o remount /
sudo quotacheck -avugm
sudo touch /aquota.user /aquota.group
sudo quotaon -avug

echo "------------------Set other environment variables-------------"
sudo -u vagrant echo 'export DB=mysql' >> /home/vagrant/.profile
sudo -u vagrant echo 'export DB_CONNECTION_STRING="mysql2://root:password@localhost:3306/cc_test"' >> /home/vagrant/.profile


#!/bin/sh

# set ssh key
cd /root
mkdir .ssh
chmod 700 .ssh
cd .ssh
cat /vagrant/.ssh/test_id_rsa.pub >> authorized_keys
chmod 600 authorized_keys
cp /vagrant/.ssh/test_id_rsa ./id_rsa
chmod 600 id_rsa

# install puppet
yum install -y http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
yum install -y puppet

# git clone provisioner
cd /home/vagrant
git clone https://github.com/gomesuit/provisioner_puppet.git

# run puppet
cd /home/vagrant/provisioner_puppet
puppet apply testuser.pp
puppet apply testdirectory.pp

rm -rf /etc/puppet/modules
ln -s /home/vagrant/provisioner_puppet/modules /etc/puppet/

puppet apply testmodule_template.pp

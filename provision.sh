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

# install chef
curl -L https://www.chef.io/chef/install.sh | bash

echo 'export PATH=/opt/chef/embedded/bin:$PATH' >> /root/.bash_profile
export PATH=/opt/chef/embedded/bin:$PATH

# git clone provisioner
cd /home/vagrant
git clone https://github.com/gomesuit/provisioner_chef_server.git

# run chef
cd /home/vagrant/provisioner_chef_server
#bundle install
#bundle exec knife zero bootstrap localhost
#bundle exec berks vendor cookbooks
#bundle exec knife node run_list add ansible zsh
#bundle exec knife zero chef_client 'name:ansible' --attribute ipaddress
#chef-client -z


yum install -y https://web-dl.packagecloud.io/chef/stable/packages/el/6/chef-server-core-12.1.0-1.el6.x86_64.rpm
#yum install -y https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.6.2-1.el6.x86_64.rpm
chef-server-ctl reconfigure
chef-server-ctl test
chef-server-ctl user-create admin firstname lastname your@mail.address password --filename .chef/admin.pem
chef-server-ctl org-create chef "Chef" --association admin --filename .chef/chef-validator.pem
knife ssl fetch -s https://ansible/organizations/chef/
knife cookbook upload learn_chef_httpd
knife bootstrap localhost -N localhost --run-list 'recipe[learn_chef_httpd]'

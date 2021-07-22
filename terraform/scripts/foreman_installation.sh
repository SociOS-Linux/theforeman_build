#!/bin/bash
echo "Installing Foreman packages"
sudo yum -y localinstall https://yum.theforeman.org/releases/2.3/el7/x86_64/foreman-release.rpm
echo "Finished Foreman packages installation"
#
echo "Installing Katello packages"
sudo yum -y localinstall https://fedorapeople.org/groups/katello/releases/yum/3.18/katello/el7/x86_64/katello-repos-latest.rpm
echo "Finished Katello packages installation"
#
echo "Installing Puppet packages"
sudo yum -y localinstall https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
echo "Finished Puppet packages installation"
#
echo "Installing EPEL packages"
sudo yum -y install epel-release centos-release-scl-rh
echo "Finished EPEL packages installation"
#
echo "Updating basic yum packages"
sudo yum -y update
echo "Finished basic yum packages updation"
#
sudo bash -c 'sysctl -w vm.overcommit_memory=0 >> /etc/sysctl.d/vm_overcommit.conf'
echo "Installing Katello"
sudo yum -y install katello
echo "Finished Katello installation"
#
echo "Updating Foreman scenario with katello"
sudo foreman-installer --scenario katello
sudo sed -i '55 s/9090/8443/' /etc/foreman-proxy/settings.yml
sudo systemctl restart foreman foreman-proxy
echo "Finished Foreman & Katello installation"
sudo bash -c "grep 'username\|password' /root/.hammer/cli.modules.d/foreman.yml > credentials.txt"
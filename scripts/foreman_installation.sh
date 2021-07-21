#!/bin/bash
sudo yum -y localinstall https://yum.theforeman.org/releases/2.3/el7/x86_64/foreman-release.rpm
sudo yum -y localinstall https://fedorapeople.org/groups/katello/releases/yum/3.18/katello/el7/x86_64/katello-repos-latest.rpm
sudo yum -y localinstall https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
sudo yum -y install epel-release centos-release-scl-rh
sudo yum -y update
sudo bash -c 'sysctl -w vm.overcommit_memory=0 >> /etc/sysctl.d/vm_overcommit.conf'
sudo yum -y install katello
sudo foreman-installer --scenario katello
sudo sed -i '55 s/9090/8443/' /etc/foreman-proxy/settings.yml
sudo systemctl restart foreman foreman-proxy
sudo bash -c "grep 'username\|password' /root/.hammer/cli.modules.d/foreman.yml > credentials.txt"
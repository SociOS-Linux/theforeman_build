#!/bin/bash
sudo su
test = /opt
#Changing user profile
echo "\nChanging user profile to root"
cd $test
#updating packages
echo "\nUpdating yum packages"
sudo yum install -y 
echo "\nYum packages updated successfully"

echo "\nInstalling Foreman"
yum -y localinstall https://yum.theforeman.org/releases/2.3/el7/x86_64/foreman-release.rpm
echo "\nForeman installed successfully"

echo "\nInstalling Katello packages"
yum -y localinstall https://fedorapeople.org/groups/katello/releases/yum/3.18/katello/el7/x86_64/katello-repos-latest.rpm
echo "\nKatello packages installed successfully"

echo "Installing Puppet"
yum -y localinstall https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
echo "Puppet installed successfully"

echo "\nInstalling EPEL"
yum -y install epel-release centos-release-scl-rh 
echo "\nEPEL installed successfully"

echo "\nUpdating yum packages"
yum -y update
echo "\nYum packages updated successfully"

echo 0 > /proc/sys/vm/overcommit_memory

echo "\nInstalling Katello"
yum -y install katello
echo "\nKatello installed successfully"

echo  "\nInstalling katello packages"
foreman-installer --scenario katello
echo "\nKatello packages installed sucessfully"

#end script
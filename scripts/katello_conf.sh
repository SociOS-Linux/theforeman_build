#!/bin/bash
sudo hammer defaults add --param-name organization --param-value "Default Oraganization"
sudo hammer defaults add --param-name location --param-value "Default Location"
sudo hammer product create --name "CentOS7_repos" --description "Repositories for CentOS 7" --organization-id "1"
#
sudo wget http://mirror.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7
sudo hammer gpg create --key "RPM-GPG-KEY-CentOS-7" --name "RPM-GPG-KEY-CentOS-7" --organization-id "1"
sudo mkdir /etc/pki/rpm-gpg/import
sudo mv RPM-GPG-KEY-* /etc/pki/rpm-gpg/import
#
sudo hammer repository create --product "CentOS7_repos" --name "base_x86_64" --label "base_x86_64" --content-type "yum" --download-policy "on_demand" --gpg-key "RPM-GPG-KEY-CentOS-7" --url "http://mirror.centos.org/centos/7/os/x86_64/" --mirror-on-sync "no" --organization-id "1"
#
sudo hammer repository create --product "CentOS7_repos" --name "extras_x86_64" --label "extras_x86_64" --content-type "yum" --download-policy "on_demand" --gpg-key "RPM-GPG-KEY-CentOS-7" --url "http://mirror.centos.org/centos/7/extras/x86_64/" --mirror-on-sync "no" --organization-id "1"
#
sudo hammer repository create --product "CentOS7_repos" --name "updates_x86_64" --label "updates_x86_64" --content-type "yum" --download-policy "on_demand" --gpg-key "RPM-GPG-KEY-CentOS-7" --url "http://mirror.centos.org/centos/7/updates/x86_64/" --mirror-on-sync "no" --organization-id "1"
#
sudo hammer repository list --organization-id "1"
sudo hammer repository synchronize --product "CentOS7_repos" --id "1"
sudo hammer repository synchronize --product "CentOS7_repos" --id "2"
sudo hammer repository synchronize --product "CentOS7_repos" --id "3"
#
sudo hammer content-view create --name "CentOS7_content" --description "Content view for CentOS 7" --organization-id "1"
sudo hammer content-view list --organization-id "1"
sudo hammer content-view add-repository --name "CentOS7_content" --product "CentOS7_repos" --repository-id "1" --organization-id "1"
sudo hammer content-view add-repository --name "CentOS7_content" --product "CentOS7_repos" --repository-id "2" --organization-id "1"
sudo hammer content-view add-repository --name "CentOS7_content" --product "CentOS7_repos" --repository-id "3" --organization-id "1"
#
sudo hammer lifecycle-environment create --name "prod" --label "prod" --prior "Library" --organization-id "1"
sudo hammer lifecycle-environment list --organization-id "1"
sudo hammer content-view publish --name "CentOS7_content" --description "Publishing repositories for CentOS 7" --organization-id "1"
sudo hammer content-view version promote --content-view "CentOS7_content" --version "1.0" --to-lifecycle-environment "prod" --organization-id "1"
sudo hammer content-view version list --organization-id "1"
sudo hammer activation-key create --name "CentOS7-key" --description "Key for CentOS 7" --lifecycle-environment "prod" --content-view "CentOS7_content" --unlimited-hosts --organization-id "1"
sudo hammer activation-key list --organization-id "1"
sudo hammer activation-key add-subscription --name "CentOS7-key" --quantity "1" --subscription-id "1" --organization-id "1"
#
sudo yum -y install vsftpd
sudo systemctl enable vsftpd
sudo bash -c "sed -i '19 s/YES/no/' /etc/vsftpd/vsftpd.conf"
sudo systemctl restart vsftpd
sudo wget http://centos.mirror.snu.edu.in/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-NetInstall-2009.iso
sudo mkdir cd /ftp
sudo mount -o loop CentOS-7-x86_64-DVD-2009.iso /ftp
sudo mkdir /var/ftp/pub/CentOS_7_x86_64
sudo bash -c "rsync -rv --progress /ftp/ /var/ftp/pub/CentOS_7_x86_64/"
sudo hammer medium create --organization-id "1" --locations "Default Location" --name Centos_DVD_FTP --path "ftp://terraform-foreman.us-central1-a.c.simplelinux.internal/pub/CentOS_7_x86_64/" --os-family "Redhat"
sudo umount /ftp
sudo restorecon -Rv /var/ftp/pub/
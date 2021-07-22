#!/bin/bash
echo "Starting TFTP configuration"
sudo yum -y install tftp-server syslinux
sudo systemctl enable tftp.socket
sudo systemctl start tftp.socket
sudo mkdir -p /var/lib/tftpboot/{boot,pxelinux.cfg,grub2}
sudo cp /usr/share/syslinux/{pxelinux.0,menu.c32,chain.c32} /var/lib/tftpboot/
sudo restorecon -RvF /var/lib/tftpboot/
sudo mkdir -p /exports/var/lib/tftpboot
sudo bash -c "sed -n '6p' /home/centos/config/fstab >> /etc/fstab"
sudo mount -a
sudo bash -c "sed -n '4p' /home/centos/config/exports >> /etc/exports"
sudo exportfs -rva
echo "TFTP configuration has been Finished"
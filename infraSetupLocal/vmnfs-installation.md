# NFS machine set up ( typically Ubuntu server)

* set up 1 VM - Ubuntu server - 1 CPU, 1 GB RAM, 20-30 GB space
* Download MobaXterm on windows

### first update the apt
`sudo apt update && sudo apt upgrade -y`

### ssh server so that you can work remotely on that computer
```
sudo apt install ssh -y
sudo systemctl status ssh
#sudo systemctl start ssh
#sudo systemctl enable ssh
```

### NFS Server set up - only for NFS server

On nfs server machine

```
sudo apt install nfs-kernel-server -y
sudo mkdir /export/volumes -p
sudo chmod 777 /export/volumes
sudo echo "/export/volumes *(rw,no_root_squash,no_subtree_check)" >> /etc/exports
sudo systemctl restart nfs-kernel-server
```

create git directory for code.
```
sudo mkdir /export/volumes/git
sudo chmod 777 /export/volumes/git
```

Run `ip addr` on nfs server machine and get IPv4 address. nfs client will need it.

### On nfs client

Add host information
```
sudo echo "X:X:X:X vmnfs" >> /etc/hosts

sudo echo "vmnfs:/export/volumes /mnt/nfs nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab

sudo apt install nfs-common -y
```

Reboot and check if nfs is mounted.
```
sudo reboot
```
Create softlink for easy use in your home directory.
```
ln -s ~/git git
```

### NFS set up on windows

Its fairly straight forward.
Follow the instructions in link - 
https://docs.datafabric.hpe.com/62/AdministratorGuide/MountingNFSonWindowsClient.html

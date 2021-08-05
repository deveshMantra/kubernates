# Ubuntu machine set up help

### first update the apt
`sudo apt update && sudo apt upgrade -y`

### ssh server so that you can work remotely on that computer
```
sudo apt install ssh -y
sudo systemctl status ssh
#sudo systemctl start ssh
#sudo systemctl enable ssh
```



### Useful software
Just copy paste and get things installed.
```
sudo apt install openjdk-16-jdk -y
sudo apt install htop -y
sudo apt install git -y
git config --global credential.helper store
sudo apt install cups-pdf -y
sudo apt install curl -y
sudo apt install wget -y
sudo apt install software-properties-common -y
sudo apt install apt-transport-https  -y
sudo apt install net-tools -y
sudo apt-get install vsftpd -y
sudo ufw allow 20/tcp
sudo ufw allow 21/tcp
cd ~/Downloads
wget https://services.gradle.org/distributions/gradle-7.1-bin.zip
sudo mkdir /opt/gradle
sudo unzip -d /opt/gradle gradle-7.1-bin.zip
ls /opt/gradle/gradle-7.1


```

### Eclipse
```
cd ~/Downloads
tar -xf eclipse*.tar.gz
./eclipse-installer/eclipse-inst


```
### Get a good editor if this is for desktop
VSCODE - Manual download from https://code.visualstudio.com/docs/?dv=linux64_deb

```
cd Downloads
sudo dpkg -i code_*
```

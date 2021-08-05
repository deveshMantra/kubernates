# Minikube installation

If you are going to use minikube, you need to install
* docker
* minikube
* kubectl
* helm

### docker installation
```
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo usermod -aG docker $USER && newgrp docker
```

Verify installion is working
```
sudo docker run hello-world
```

### minikube installation
```
cd ~/Downloads
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
minikube start
minikube config set cpus 4
minikube config set memory 6144
minikube stop
minikube start
```

### kubectl installation

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "$(<kubectl.sha256) kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

kubectl get all
kubectl version --client

alias k=kubectl
```

### Runtime set up
Need to get docker credentials in kubernetes so that it can download the images in your account.

use login - blread. Take password from others in team.

```
docker login
```
docker login will create credentials file in home directory. You can import in kubernetes as secret.

```
sudo chown $(id -u):$(id -g) ~/.docker
sudo chown $(id -u):$(id -g) ~/.docker/config.json

kubectl create secret generic dockcred --from-file=.dockerconfigjson=/home/<userid>/.docker/config.json --type=kubernetes.io/dockerconfigjson
```

### HELM installation

Reference - https://helm.sh/docs/intro/install/

```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

Check version post installation

```
helm version
```


# Install Kubernetes

This installation of kubernetes is different from minikube installation.
This is full installation with mulitple machines. 

<p style="color:red">
CAUTION: Don't install docker, as we are planning to use containerd. Docker is no more the default container in kubernetes.
</p>

Link - 
https://github.com/kubernetes/kubernetes

### VMs / Lab set up
1. 1 VM - NFS server ( call it vmnfs )
2. 1 VM - Ubuntu desktop ( call it vmkubemaindesk)
3. 1 or 2 VMs - node machines. 1 node is good enough for learning. if you have HW availablem, you can have 2 nodes. ( call it - vmkuben1)

turn off swap file by commenting the swap line in /etc/fstab
```
sudo vi /etc/fstab

# /swapfile                                 none            swap    sw              0       0

```
Machine should have following
1. swapoff ( you can run swapoff on command line and no output should come.)
2. static ip
3. hostnames in `/etc/hosts` for easy access.

**What we need to install on ALL VMs**

* containerd
* kubelet
* kubeadm
* kubectl

**What we need to install on main kube VM**

* helm

## Installing containerd

Link with details -  https://kubernetes.io/docs/setup/production-environment/container-runtimes/

    CAUTIION - On this link there is a point where it puts another link to install docker engine from  - https://docs.docker.com/engine/install/ubuntu/. 
    You use the link to install ONLY containerd 

    Correct:
        sudo apt-get install containerd.io
    
    Incorrect:
        sudo apt-get install docker-ce docker-ce-cli containerd.io
    
Start installation:
```
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```

Install containerd from docker site.

```
sudo apt update && sudo apt upgrade -y

sudo apt install apt-transport-https ca-certificates curl     gnupg lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install containerd.io

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

sudo systemctl restart containerd

```

Manual step : update /etc/containerd/config.toml
```
sudo vi /etc/containerd/config.toml
```
Search for - `[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]`
add line `SystemdCgroup = true` under it.

So it will look like
```
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
  SystemdCgroup = true
```

Restart containerd

```
sudo systemctl restart containerd
```

## Install kubeadm, kubectl
Reference - https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

```

Hold automatic updates for installed software

```
sudo apt-mark hold kubelet kubeadm kubectl containerd
```

**Enable services**

```
sudo systemctl status kubelet.service
sudo systemctl status containerd.service

sudo systemctl enable kubelet.service
sudo systemctl enable containerd.service
```

**Installation is done at this point**

## CONFIGURING KUBERNETES CLUSTER - only on main kube machine

### Initialize kubernetes

### Creating control plan node

```
cd ~/Downloads

kubeadm config print init-defaults | tee ClusterConfiguration.yaml
```

update ClusterConfiguration.yaml with ip address of Kube main machine
* update advertiseAddress

```
advertiseAddress: 1.2.3.4
```

to 

```
advertiseAddress: 192.168.X.X
```

* update criSocket
```
criSocket: /var/run/dockershim.sock
```

to 
```
criSocket: /run/containerd/containerd.sock
```
* make sure name is pointing your vm name - name: `vmkubemaindesk`
* correct kubernetes version to what you have insta1lled . `kubernetesVersion: 1.21.0`

**Run kubeinit**

```
sudo kubeadm init --config=ClusterConfiguration.yaml --cri-socket /run/containerd/containerd.sock
```
note: This can take few mins.

Run following as suggested by output of above command
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
Save the command for nodes from output of kubeadm command. 

Command looks Something like 
```
kubeadm join 192.168.X.X:6443 --token abcded.thisissomerandomchars  --discovery-token-ca-cert-hash sha256:thisissomerandomchars... 
```

**Set up network**

```
wget https://docs.projectcalico.org/manifests/calico.yaml

kubectl apply -f calico.yaml
```

**Check pods**

```
kubectl get pods --all-namespaces
```

Check kubelet service. should be running. there will be few errors in output at this stage.

```
sudo systemctl status kubelet.service
```

**Info for Node machines**

listing tokens
```
kubeadm token list
kubeadm token create
```

find ca cert

```
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
```

generate join command

```
kubeadm  token  create --print-join-command
```

### nodes ( post complete installation )

```
sudo kubeadm join 192.168.1.60:6443 --token mbybau.ti8s214fnbqd6uo3 --discovery-token-ca-cert-hash sha256:6ae22b647540307e86df1033200d20b8f3489ab287881eb58f2ca09ab959cae2
```

Check nodes on main Kube

```
k get nodes -o wide
NAME             STATUS   ROLES                  AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
vmkubemaindesk   Ready    control-plane,master   116m   v1.21.2   192.168.1.60   <none>        Ubuntu 21.04         5.11.0-22-generic   containerd://1.4.6
vmkuben1         Ready    <none>                 69s    v1.21.2   192.168.1.49   <none>        Ubuntu 20.04.2 LTS   5.4.0-77-generic    containerd://1.4.6
vmkuben2         Ready    <none>                 88s    v1.21.2   192.168.1.50   <none>        Ubuntu 20.04.2 LTS   5.4.0-77-generic    containerd://1.4.6
```

## Enable Ingress

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.47.0/deploy/static/provider/baremetal/deploy.yaml
```

Check if ingress controller is running.
```
kubectl get pods -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx 
```


## Deploy HELM


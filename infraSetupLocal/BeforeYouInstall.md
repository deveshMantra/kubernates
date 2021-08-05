# Notes on installation before starting

### VM set up
If you are using oracle VM set up, following options for smooth experience are recommended.

* Use Ubuntu Desktop iso. You will need browser and other tools to check apps deployed in kubernetes. Don't deploy server.
* Choose 40 GB disk
* At least 4 CPUs are recommended. Below that, you will have to try.
* At least 4 GB RAM is recommended.
* Enable PAE/NX, VT-x/AMD-V to enable virtualization technology.
* Increase Video Memory to 80-100 MB otherwise Ubuntu UI crashes
* Network - choose Bridged Apapter. Your home router will treat your VM like any other device on network and assign an IP.

### 2 Types of set up

1. Recommended for most - minikube
For this set up, you just need 1 VM with 4 CPU and 4 GB RAM ( more is always better).
Follow instructions in linux-installation file.
Next follow instruction in minikube-installation file.

2. Full Kube set up
For this, you need lot of Hardware.
* 1 VM - NFS server ( call it vmnfs ). 1 GB , 1 CPU.
* 1 VM - Ubuntu desktop ( call it vmkubemaindesk). 4 GB, 4 CPU
* 1 or 2 VMs - node machines. 1 node is good enough for learning. if you have HW availablem, you can have 2 nodes. ( call it - vmkuben1). Each machine - 1/2 GB, 1/2 CPU.

You can skip NFS server set up, if you want to save RAM and CPU. 
Take this approach only if you have 6 Cores and 6 GB RAM free.

Follow instructions in linux-installation file.
Next follow instruction in kubernetes-installation file.

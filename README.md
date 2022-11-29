# Deploy-Kubernetes-With-Kubespray
**This is a simple guide to the Kubernetes default installation by Kubespray.**
```
Requirements:

1- OS: OracleLinux 8.5
2- Python 3.8
3- Kubespray
```
**We have 6 nodes in this scenario. Three nodes to be used as control planes and three nodes as workers. In addition, three control plane nodes are used to install ETSD database. The installation environment is on virtual machines in VMWare environment.**
```
The specifications of virtual machines are as follows:
Cpu: 4 cores
Memory: 8GB
Note: If you need to increase the memory in the future, activate the Memory Hot Plug option.


# Deploy-Kubernetes-With-Kubespray
**This is a simple guide to the Kubernetes default installation by Kubespray.**
```
Requirements:

1- OS: OracleLinux 8.5
2- Python 3.8
3- Kubespray (Current Version in 2022-11-29 is 2.20.0)
4- git
5- one server with Oracle Linux 8.5 for ansible
```
**We have 6 nodes in this scenario. Three nodes to be used as control planes and three nodes as workers. In addition, three control plane nodes are used to install etcd database. The installation environment is on virtual machines in VMWare environment.**

**The specifications of virtual machines are as follows:**
```
Cpu: 4 cores
Note: Note: If you need to increase the memory in the future, activate the CPU Hot Plug option.
Memory: 8GB
Note: If you need to increase the memory in the future, activate the Memory Hot Plug option.
HDD: 2*100GB (100GB for OS and 100GB for data directory)
```
**Operating system specifications and settings on nodes:**
```
- Create LVM (Logical Volume Manager) for each disk
The proposed model for the LVM structure of the operating system:

NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
mainvg-lv_root       252:0    0        5G  0 lvm  /
mainvg-lv_swap       252:1    0        5G  0 lvm  
mainvg-lv_usr        252:2    0        5G  0 lvm  /usr
mainvg-lv_home       252:3    0        5G  0 lvm  /home
mainvg-lv_var        252:4    0        5G  0 lvm  /var
mainvg-lv_opt        252:5    0        5G  0 lvm  /opt
mainvg-lv_tmp        252:6    0        5G  0 lvm  /tmp
mainvg-lv_vartmp     252:7    0        5G  0 lvm  /var/tmp
mainvg-lv_varlog     252:9    0        5G  0 lvm  /var/log
mainvg-lv_audit      252:10   0        5G  0 lvm  /var/log/audit

Note: VolumeGroup for OS filesystems name is "mainvg".

The proposed model for the LVM structure of the data directory:

NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
APPVG-LV_APP         252:8    0   100G  0 lvm  /app

Note: VolumeGroup for data directory filesystem name is "APPVG".
```
**LOM:**
```
Ansible  -> IP  Address: 192.168.1.9
Master01 -> IP Address: 192.168.1.10
Master02 -> IP Address: 192.168.1.11
Master03 -> IP Address: 192.168.1.12
Worker01 -> IP Address: 192.168.1.13
Worker02 -> IP Address: 192.168.1.14
Worker03 -> IP Address: 192.168.1.15
```

Installing:
```
Prepare Kubernetes nodes (192.168.1.10-15):
1- useradd ansible
2- echo "ansible		ALL=(ALL)	NOPASSWD: ALL" > /etc/sudoers.d/admins

Prepare Ansible Node:

1- dnf install git python38 python3-pip -y
2- git clone https://github.com/kubernetes-sigs/kubespray.git /opt/kubespray
3- cd /opt/kubespray
4- useradd ansible
5- echo "ansible		ALL=(ALL)	NOPASSWD: ALL" > /etc/sudoers.d/admins
6- su - ansible #switch to ansible user enviroment
7- mkdir /scripts
8- copy install-ansible.sh to /scripts
9- chmod +x install-ansible.sh
10- /scripts/install-ansible.sh
11- ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
12- copy public key to other nodes:



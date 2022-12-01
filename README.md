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
**We have 6 nodes in this scenario.Three nodes to be used as control planes, three nodes as workers and one node for Ansible. In addition, three control plane nodes are used to install etcd database. The installation environment is on virtual machines in VMWare environment.**

![image](https://user-images.githubusercontent.com/16554389/204513136-50ae86ea-3ad6-4543-99b1-dd04dd503865.png)


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
2- passwd ansible #set password for ansible user
2- echo "ansible  ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/admins

Prepare Ansible Node (192.168.1.9):

1- dnf install git python38 python3-pip -y
2- git clone https://github.com/kubernetes-sigs/kubespray.git /opt/kubespray
3- cd /opt/kubespray
4- useradd ansible
5- echo "ansible		ALL=(ALL)	NOPASSWD: ALL" > /etc/sudoers.d/admins
6- su - ansible #switch to ansible user enviroment
7- mkdir /scripts
8- copy install-ansible.sh to /scripts
9- chmod +x install-ansible.sh
10- /scripts/install-ansible.sh #install ansible and other requirements
11- ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1 #create private and public key
12- copy public key to other nodes:
ssh-copy-id ansible@192.168.1.10
ssh-copy-id ansible@192.168.1.11
ssh-copy-id ansible@192.168.1.12
ssh-copy-id ansible@192.168.1.13
ssh-copy-id ansible@192.168.1.14
ssh-copy-id ansible@192.168.1.15
13- cd /opt/kubespray
14- sudo cp -rfp inventory/sample inventory/mycluster 
15- sudo vi inventory//mycluster/inventory.ini #Then change the file according to the following values:

# ## Configure 'ip' variable to bind kubernetes services on a
# ## different ip than the default iface
# ## We should set etcd_member_name for etcd cluster. The node that is not a etcd member do not need to set the value, or can set the empty string value.
[all]
master01 ansible_host=192.168.1.10  # ip=10.3.0.1 etcd_member_name=etcd1
master02 ansible_host=192.168.1.11  # ip=10.3.0.2 etcd_member_name=etcd2
master03 ansible_host=192.168.1.12  # ip=10.3.0.3 etcd_member_name=etcd3
worker01 ansible_host=192.168.1.13  # ip=10.3.0.4 etcd_member_name=etcd4
worker02 ansible_host=192.168.1.14  # ip=10.3.0.5 etcd_member_name=etcd5
worker03 ansible_host=192.168.1.15  # ip=10.3.0.6 etcd_member_name=etcd6

# ## configure a bastion host if your nodes are not directly reachable
# [bastion]
# bastion ansible_host=x.x.x.x ansible_user=some_user

[kube_control_plane]
master01
master02
master03

[etcd]
master01
master02
master03

[kube_node]
master01
master02
master03
worker01
worker02
worker03

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr

16- sudo sed -i '4i containerd_storage_dir: "/app/containerd"'  inventory/mycluster/group_vars/all/containerd.yml
17- sudo sed -i 's/etcd_data_dir: \/var\/lib\/etcd/etcd_data_dir: \/app\/etcd/' inventory/mycluster/group_vars/all/etcd.yml
18- ansible-playbook -i inventory/mycluster/inventory.ini  --become --become-user=root cluster.yml
19- check nodes status
kubectl get nodes -o wide
```


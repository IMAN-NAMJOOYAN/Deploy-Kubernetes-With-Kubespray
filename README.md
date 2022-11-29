# Deploy-Kubernetes-With-Kubespray
**This is a simple guide to the Kubernetes default installation by Kubespray.**
```
Requirements:

1- OS: OracleLinux 8.5
2- Python 3.8
3- Kubespray
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




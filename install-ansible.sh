#!/bin/bash
#--------------------------------(This Script Prepare Suitable Ansible Version For Kubespray)
pip3.8 install virtualenv --user
VENVDIR=kubespray-venv
KUBESPRAYDIR=/opt/kubespray
ANSIBLE_VERSION=2.12
cd $KUBESPRAYDIR
pip3.8 install -U -r requirements-$ANSIBLE_VERSION.txt --user
test -f requirements-$ANSIBLE_VERSION.yml && \
ansible-galaxy role install -r requirements-$ANSIBLE_VERSION.yml && \
ansible-galaxy collection -r requirements-$ANSIBLE_VERSION.yml    

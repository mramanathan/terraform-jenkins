#!/bin/bash

## Pause to avoid conflicts that may arise due to 
## tasks initiated or in-progress as part of EC2 
## spin up prcess.
sleep 45

# System Update
echo -e "\n[$(date "+%Y/%m/%d %H:%M:%S")]: START user data script"
echo -e "\n[$(date "+%Y/%m/%d %H:%M:%S")]: Running apt update..."
sudo apt-get update

# Install basic packages and Python
echo -e "\n[$(date "+%Y/%m/%d %H:%M:%S")]: Sleeping for 30 seconds..."
sleep 30
echo -e "\n[$(date "+%Y/%m/%d %H:%M:%S")]: Installing basic packages and Python..."
sudo apt-get install -y git gcc make ntp wget curl python

# Check Python version
echo -e "\n[$(date "+%Y/%m/%d %H:%M:%S")]: Python version installed..."
python -V

# Install Ansible
echo -e "\n[$(date "+%Y/%m/%d %H:%M:%S")]: Sleeping for 30 seconds..."
sleep 30
echo -e "\n[$(date "+%Y/%m/%d %H:%M:%S")]: Installing Ansible..."
sudo apt-get install -y ansible

# Check Ansible version
echo -e "\n[$(date "+%Y/%m/%d %H:%M:%S")]: Ansible version installed..."
ansible --version | head -1

echo -e "\n[$(date "+%Y/%m/%d %H:%M:%S")]: END user data script"

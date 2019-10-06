#!/bin/bash

# System Update
echo -e "Running apt update..."
sudo apt-get update

# Install Python
echo -e "Installing Python..."
sudo apt-get install -y python

# Check Python version
echo -e "Python version installed..."
python -V

# Install Ansible
echo -e "Installing Ansible..."
sudo apt-get install -y ansible

# Check Ansible version
echo -e "Ansible version installed..."
ansible --version | head -1
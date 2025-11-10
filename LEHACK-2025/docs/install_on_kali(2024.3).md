# Virtualbox setup (aka "Les Snapshot sans raquer")

<div align="center">
  <img alt="vagrant" width="150" height="150" src="./img/icon_vagrant.png">
  <img alt="icon_vwmare" width="150"  height="150" src="./img/icon_virtualbox.png">
  <img alt="icon_ansible" width="150"  height="150" src="./img/icon_ansible.png">
</div>

## Prerequisites

- Providing
  - [Virtualbox](https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html)
  - [Vagrant](https://developer.hashicorp.com/vagrant/docs)
  - Vagrant plugins:
    - vagrant-reload
    - on some distributions also the vagrant plugins :
      - winrm
      - winrm-fs
      - winrm-elevated

- Provisioning with python
  - Python3 (>=3.8)
  - [ansible-core==2.12.6](https://docs.ansible.com/ansible/latest/index.html)
  - pywinrm

# Lab Installation Guide on Kali 2024.3

This guide will help you set up your lab environment on Kali.

## Step 1: Update and Upgrade System Packages

```bash
sudo apt update && apt upgrade -y
```

## Step 2: Install VirtualBox and Linux Headers

```bash
sudo apt install virtualbox linux-headers-generic
```

## Step 3: Install Vagrant

```bash
sudo apt install vagrant
```

## Step 4: Install Ansible Using pipx

```bash
pipx install --include-deps ansible
```

## Step 5: Install Git

```bash
sudo apt install git
```

## Step 6: Clone the Lab Repository

```bash
cd /tmp
git clone https://github.com/Pennyw0rth/NetExec-Lab
```

## Step 7: Install Python 3.8.12

```bash
cd /opt
sudo wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz
sudo tar xzf Python-3.8.12.tgz
cd Python-3.8.12
sudo ./configure --enable-optimizations
sudo make altinstall
```

## Step 8: Set Up Python Virtual Environment

```bash
cd /tmp/NetExec-Lab/LEHACK-2025/
python3.8 -m venv .venv
source .venv/bin/activate  # For bash/zsh
# OR
source .venv/bin/activate.fish  # For fish shell
```

## Step 9: Upgrade pip and Install Ansible Core

```bash
python3 -m pip install --upgrade pip
python3 -m pip install ansible-core==2.12.6
```

## Step 10: Install Additional Dependencies

```bash
python3 -m pip install pywinrm
```

## Step 11: Install Ansible Galaxy Requirements

```bash
ansible-galaxy install -r ansible/requirements.yml
```

## Step 12: Set Up VirtualBox with Vagrant

```bash
cd ad/LEHACK/providers/virtualbox
vagrant up
```

## Step 13: Run Ansible Playbooks
### Run the Main Playbook:
```bash
cd ../../../../ansible/
ansible-playbook -i ../ad/LEHACK/data/inventory -i ../ad/LEHACK/providers/virtualbox/inventory main.yml
```
### Disable Vagrant user:
```bash
ansible-playbook -i ../ad/LEHACK/providers/virtualbox/inventory_disablevagrant disable_vagrant.yml
```
### Reboot the Machines:
```bash
ansible-playbook -i ../ad/LEHACK/providers/virtualbox/inventory_disablevagrant reboot.yml rebootsrv01.yml
```


# TroubleShooting

## Memory issues

### Error
```bash
There was an error while executing `VBoxManage`, a CLI used by Vagrant
for controlling VirtualBox. The command and stderr is shown below.

Command: ["startvm", "96b98a1c-4a38-48ae-b683-58c90e16f475", "--type", "headless"]

Stderr: Warning: program compiled against libxml 212 using older 209
VBoxManage: error: Out of memory condition when allocating memory with low physical backing. (VERR_NO_LOW_MEMORY)
VBoxManage: error: Details: code NS_ERROR_FAILURE (0x80004005), component ConsoleWrap, interface IConsole
```
### Mitigation

```bash
free -h
sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches
```

## Libxml issues

### Error
```bash
There was an error while executing VBoxManage, a CLI used by Vagrant
for controlling VirtualBox. The command and stderr is shown below.

Command: ["hostonlyif", "ipconfig", "Warning: program compiled against libxml 212 using older 209", "--ip", "192.168.56.1", "--netmask", "255.255.255.0"]

Stderr: Warning: program compiled against libxml 212 using older 209
VBoxManage: error: The host network interface named 'Warning: program compiled against libxml 212 using older 209' could not be found
VBoxManage: error: Details: code NS_ERROR_INVALID_ARG (0x80070057), component HostWrap, interface IHost, callee nsISupports
VBoxManage: error: Context: "FindHostNetworkInterfaceByName(Bstr(pszName).raw(), hif.asOutParam())" at line 242 of file VBoxManageHostonly.cpp
```

### Mitigation
```bash
sudo apt-get update
sudo apt-get install --reinstall libxml2
```

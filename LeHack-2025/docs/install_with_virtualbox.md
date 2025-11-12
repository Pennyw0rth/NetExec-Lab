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

- Or provisioning With Docker
  - [Docker](https://www.docker.com/)


### Install VirtualBox

- Download and install [VirtualBox](https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html)
- You can probably use the version of your package manager, but I would recommend using the latest one from Oracle.

### Install Vagrant

- **vagrant** from their official site [vagrant](https://developer.hashicorp.com/vagrant/downloads). __The version you can install through your favorite package manager (apt, yum, ...) is probably not the latest one__.
- Install vagrant plugin vbguest if you want the guest addition: `vagrant plugin install vagrant-vbguest` (not mandatory)
- Vagrant installation is well described in [the official vagrant page](https://developer.hashicorp.com/vagrant/downloads) (tests are ok on 2.3.4)
- Some github issues indicate vagrant got some issues on some version and works well with 2.2.19 (`apt install vagrant=2.2.19`)

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```

- on some recent versions (ubuntu 23.04), you should consider running:
```bash
gem install winrm winrm-fs winrm-elevated
```

### Install Ansible

#### Installing with pipx

`pipx` is a great way to avoid conflicting Python dependencies when installing applications.
Installing _ansible_ with `pipx` is documented here: [https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pipx](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pipx).

```bash
pipx install --include-deps ansible
```

`pywinrm` is a library, so it needs to be installed with `pip`.

```bash
python3 -m pip install pywinrm
```
If you encounter any issue, try the virtualenv installationInstalling with a virtualenv below.


- Install all the ansible-galaxy requirements:
  - **ansible windows**
  - **ansible community.windows**
  - **ansible chocolatey** (not needed anymore)
  - **ansible community.general**
```
ansible-galaxy install -r ansible/requirements.yml
```

#### Installing with a virtualenv

- If you want to play ansible from your host or a linux vm you should launch the following commands :

- *Create a python >= 3.8 virtualenv*

```bash
sudo apt install git
git clone https://github.com/Pennyw0rth/NetExec-Lab
cd LeHack-2025/ansible
sudo apt install python3.8-venv
python3.8 -m virtualenv .venv
source .venv/bin/activate
```

- Install ansible and pywinrm in the .venv
  - **ansible** following the extensive guide on their website [ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
  - **Tested with ansible-core (2.12)**
  - **pywinrm** be sure you got the pywinrm package installed

```
python3 -m pip install --upgrade pip
python3 -m pip install ansible-core==2.12.6
python3 -m pip install pywinrm
```

- Install all the ansible-galaxy requirements
  - **ansible windows**
  - **ansible community.windows**
  - **ansible chocolatey** (not needed anymore)
  - **ansible community.general**
```
ansible-galaxy install -r ansible/requirements.yml
```

## Install

### Create the vms

- To create the VMs just run 

```bash
cd ad/LEHACK/providers/virtualbox
vagrant up
```
*note: For some distributions, you may need to run additional commands to install WinRM gems* this can be done via the following commands:

```bash
vagrant plugin install winrm
vagrant plugin install winrm-fs
vagrant plugin install winrm-elevated
```

- At the end of the vagrantup you should have the vms created and running
### Launch provisioning with Ansible

- launch the provision script (launch ansible with failover on errors)

```bash
cd ansible
export ANSIBLE_COMMAND="ansible-playbook -i ../ad/LEHACK/data/inventory -i ../ad/LEHACK/providers/virtualbox/inventory.yml"
export LAB="LEHACK"
../scripts/provisionning.sh
```

- or launch ansible directly

```bash
cd ansible/
ansible-playbook -i ../ad/LEHACK/data/inventory -i ../ad/LEHACK/providers/virtualbox/inventory.yml main.yml
```
### Once install has finished disable vagrant user to avoid using it

```bash
cd ansible/
ansible-playbook -i ../ad/LEHACK/providers/virtualbox/inventory_disablevagrant.yml disable_vagrant.yml
```

### Now do a reboot of all the machines to avoid unintended secrets stored / am looking at you Lsassy

```bash
cd ansible/
ansible-playbook -i ../ad/LEHACK/providers/virtualbox/inventory_disablevagrant.yml reboot.yml rebootsrv01.yml
```


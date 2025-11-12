# Ludus setup (the best way to deploy any lab )

<div align="center">
  <img alt="vagrant" width="150" height="150" src="./img/icon_ludus.png">
  <img alt="icon_vwmare" width="150"  height="150" src="./img/icon_proxmox.png">
  <img alt="icon_ansible" width="150"  height="150" src="./img/icon_ansible.png">
</div>

 Netexec Workshop (leHACK 2025)

:::success Props!

Huge shout out to [@ladhaAleem](https://twitter.com/LadhaAleem) for creating this project and converting the leHACK 2025 workshop created by [@mpgn_x64](https://x.com/mpgn_x64) to an ansible playbook and making it work with Ludus as well!
:::

## Description from leHACK 2025

Welcome to the NetExec Active Directory Lab! This lab is designed to teach you how to exploit Active Directory (AD) environments using the powerful tool [NetExec](https://github.com/Pennyw0rth/NetExec).

Originally featured in the leHACK 2024 Workshop, this lab is now available for free to everyone! In this lab, you’ll explore how to use the powerful tool NetExec to efficiently compromise an Active Directory domain during an internal pentest.

The ultimate goal? Become Domain Administrator by following various attack paths, using nothing but NetExec and maybe BloodHound (Why not :P).

Obviously do not cheat by looking at the passwords and flags in the recipe files, the lab must start without user to full compromise

### Public Writeups

## Deployment

### 1. Add the Windows 2019 template to Ludus


- [https://blog.anh4ckin.ch/posts/netexec-workshop2k25/] by [Anh4ckin3]

```bash
git clone https://gitlab.com/badsectorlabs/ludus
cd ludus/templates
ludus templates add -d win2019-server-x64
ludus templates build
# Wait until the templates finish building, you can monitor them with `ludus templates logs -f` or `ludus templates status`
#terminal-command-local
ludus templates list
+----------------------------------------+-------+
|                TEMPLATE                | BUILT |
+----------------------------------------+-------+
| debian-11-x64-server-template          | TRUE  |
| debian-12-x64-server-template          | TRUE  |
| kali-x64-desktop-template              | TRUE  |
| win11-22h2-x64-enterprise-template     | TRUE  |
| win2022-server-x64-template            | TRUE  |
| win2019-server-x64-template            | TRUE  |
+----------------------------------------+-------+
```

### 2. Deploy VMs


```bash
git clone https://github.com/Pennyw0rth/NetExec-Lab
ludus range config set -f NetExec-Lab/LeHack-2025/ad/LEHACK/providers/ludus/config.yml
ludus range deploy
# Wait for the range to successfully deploy
# You can watch the logs with `ludus range logs -f`
# Or check the status with `ludus range status`

```

### 3. Install requirements

Install ansible and its requirements for the NetExec lab on your local machine.

```bash
# You can use a virtualenv here if you would like
python3 -m pip install ansible-core
python3 -m pip install pywinrm
git clone https://github.com/Pennyw0rth/NetExec-Lab
cd LeHack-2025/ansible
ansible-galaxy install -r requirements.yml
```

### 4. Setup  the inventory files

The inventory file is already present in the providers folder and replace RANGENUMBER with your range number with sed (commands provided below)

```bash
cd LeHack-2025/ansible
export RANGENUMBER=$(ludus range list --json | jq '.rangeNumber')
sed -i "s/RANGENUMBER/$RANGENUMBER/g" ../ad/LEHACK/providers/ludus/inventory.yml
sed -i "s/RANGENUMBER/$RANGENUMBER/g" ../ad/LEHACK/providers/ludus/inventory_disableludus.yml
```

### 5. Deploy the NetExec Workshop

:::note

If not running on the Ludus host, you must be connected to your Ludus wireguard VPN for these commands to work

:::

```bash
cd LeHack-2025/ansible
export ANSIBLE_COMMAND="ansible-playbook -i ../ad/LEHACK/data/inventory -i ../ad/LEHACK/providers/ludus/inventory.yml"
export LAB="LEHACK"
chmod +x ../scripts/provisionning.sh
../scripts/provisionning.sh
```


Now you wait. `[WARNING]` lines are ok, and some steps may take a long time, don't panic!

This will take a few hours. You'll know it is done when you see:

```
The galaxy needs you! A dark presence still lingers in the shadows. It's your mission to hunt it down!. May the Force guide your path, pilot
```

### 5. Disable localuser

Once install has finished disable localuser user to avoid using it and avoid unintended secrets stored (*I'm looking at you Lsassy*).

:::note

You must be connected to your Ludus wireguard VPN for these commands to work

:::

```bash
# Still in the LeHack-2025/ansible directory
ansible-playbook -i ../ad/LEHACK/providers/ludus/inventory_disableludus.yml disable_localuser.yml reboot.yml rebootsrv01.yml
```

### 6. Snapshot VMs

Take snapshots via the proxmox web UI or SSH run the following ludus command:

```bash
ludus snapshot create clean-setup -d "Clean setup of the netexec lab after ansible run"
```

### 7. Hack!

Access your Kali machine at `https://10.RANGENUMBER.10.99:8444` using the creds `kali:password`.

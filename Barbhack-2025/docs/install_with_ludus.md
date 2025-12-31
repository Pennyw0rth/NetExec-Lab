# Ludus setup (the best way to deploy any lab)

<div align="center">
  <img alt="vagrant" width="150" height="150" src="./img/icon_ludus.png">
  <img alt="icon_vwmare" width="150"  height="150" src="./img/icon_proxmox.png">
  <img alt="icon_ansible" width="150"  height="150" src="./img/icon_ansible.png">
</div>

## Prerequisites

- A working Ludus installation
- Ludus CLI configured

## Installation

### 1. Deploy the VMs

First, copy the Ludus config to your Ludus server:

```bash
# Copy the config.yml to your ludus config
ludus range config set -f ad/BARBHACK/providers/ludus/config.yml
```

Then deploy the range:

```bash
ludus range deploy
```

### 2. Wait for deployment

```bash
ludus range list
```

Wait until DEPLOYMENT STATUS shows `SUCCESS`.

### 3. Run Ansible provisioning

SSH into your Kali VM or run from your local machine:

```bash
# Replace RANGENUMBER with your actual range number (e.g., 2 for 10.2.x.x)
cd ansible
sed -i 's/RANGENUMBER/YOUR_RANGE_NUMBER/g' ../ad/BARBHACK/providers/ludus/inventory.yml

ansible-playbook -i ../ad/BARBHACK/data/inventory -i ../ad/BARBHACK/providers/ludus/inventory.yml main.yml
```

## Ansible Issue

Make sure the ansible version is 2.12.6

```bash
python3 -m pip install ansible-core==2.12.6
```

## Troubleshot DNS issues

Check if DNS are correctly configured to make sure internet is accessible (to download the nuget packages). SSH on your Kali created by Ludus:

```bash
ludus range list
+---------+---------------+------------------+---------------+-------------------+-----------------+
| USER ID | RANGE NETWORK | LAST DEPLOYMENT  | NUMBER OF VMS | DEPLOYMENT STATUS | TESTING ENABLED |
+---------+---------------+------------------+---------------+-------------------+-----------------+
|   jm    |  10.2.0.0/16  | 2025-11-23 09:23 |       5       |      SUCCESS      |      FALSE      |
+---------+---------------+------------------+---------------+-------------------+-----------------+
+------------+------------------------+-------+-------------+
| PROXMOX ID |        VM NAME         | POWER |     IP      |
+------------+------------------------+-------+-------------+
|    106     | jm-router-debian11-x64 |  On   | 10.2.10.254 |
|    107     | jm-dc01                |  On   | 10.2.10.10  |
|    108     | jm-srv01               |  On   | 10.2.10.11  |
|    109     | jm-srv02               |  On   | 10.2.10.12  |
|    110     | jm-srv03               |  On   | 10.2.10.13  |
|    111     | jm-kali                |  On   | 10.2.10.99  |
+------------+------------------------+-------+-------------+
ssh kali@10.2.10.99 (password is kali)
ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=115 time=5.87 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=115 time=6.78 ms
ping google.com
(no result)
```

If `ping google.com` doesn't give anything then follow this procedure, SSH into the Router (jm-router...).

Edit the Config:

```bash
sudo nano /opt/AdGuardHome/AdGuardHome.yaml
```

Update Upstreams: Change upstream_dns to:

```yaml
upstream_dns:
  - 8.8.8.8
```

Restart AdGuard:

```bash
sudo systemctl restart AdGuardHome
```

### Verification

From your Kali VM, run the following:

```bash
┌──(kali㉿jm-kali)-[~]
└─$ ping google.com
PING google.com (216.58.205.206) 56(84) bytes of data.
64 bytes from mil04s29-in-f14.1e100.net (216.58.205.206): icmp_seq=1 ttl=115 time=5.56 ms
```

Then run the ansible script :)

## Lab Information

### Servers

| Hostname | IP Address | Role |
|----------|------------|------|
| BLACKPEARL | 10.X.10.10 | Domain Controller |
| JOLLYROGER | 10.X.10.11 | Web Server (Caddy 8080) |
| QUEENREV | 10.X.10.12 | MSSQL Server |
| FLYINGDUTCHMAN | 10.X.10.13 | Windows Server |

### Domain

- Domain: PIRATES.BRB
- Domain Admin Password: REDqC8aQtyhd78A

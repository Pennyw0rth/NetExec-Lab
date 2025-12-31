# Barbhack CTF 2025 (Pirates - Active Directory Lab)

<div>
<img src="./barbhack.jpg"/>
</div>

Welcome to the NetExec Active Directory Lab! This lab is designed to teach you how to exploit Active Directory (AD) environments using the powerful tool NetExec.

Originally featured in the Barbhack 2025 CTF, this lab is now available for free to everyone! In this lab, you'll explore how to use the powerful tool NetExec to efficiently compromise an Active Directory domain during an internal pentest.

The ultimate goal? Become Domain Administrator by following various attack paths!

Obviously do not cheat by looking at the passwords and flags in the recipe files, the lab must start without user to full compromise.

> Welcome aboard, Captain! The notorious pirate domain PIRATES.BRB awaits your conquest. Navigate through treacherous waters of NTLMv1 relaying, DPAPI secrets, GMSA offline recovery, and more. From web application enumeration to NTDS forensics, every step brings you closer to becoming the true Domain Administrator!

### Lab Architecture

- **Domain**: PIRATES.BRB
- **4 Servers**:
  - **BLACKPEARL** (192.168.10.10) - Domain Controller
  - **JOLLYROGER** (192.168.10.11) - Web Application Server (Caddy on port 8080)
  - **QUEENREV** (192.168.10.12) - MSSQL Server
  - **FLYINGDUTCHMAN** (192.168.10.13) - Windows Server with NTDS backup

### Attack Path Summary

1. **Initial Enumeration** - Identify servers and services
2. **Web Application** - Find credentials on the printer web interface
3. **Flag 1** - User's descriptions
4. **Flag 2** - SMB share access
5. **Flag 3** - Group Policy Preferences
6. **Flag 4** - NTLMv1 relay to LDAP + SPN-less RBCD
7. **Flag 5** - DPAPI for local account
8. **Flag 6** - GMSA offline recovery + MSSQL impersonation
9. **Flag 7** - MSSQL command execution + S4U2Self privilege escalation
10. **Flag 8** - Kerberos Constrained Delegation without Protocol Transition
11. **Flag 9** - NTDS backup forensics → Domain Admin

### Public Writeups

- [Barbhack 2025 AD Writeup](https://github.com/mael91620/Barbhack-2025-AD-writeup) by [@mael91620](https://github.com/mael91620)
- [Lab Build Notes](https://gist.github.com/mpgn/e89e8aa08aec9283483855b6308c0a43) by [@mpgn](https://github.com/mpgn)

There are 9 flags to find in this lab!

### Original pitch

Ahoy, matey! Time to conquer the Seven Seas and claim the PIRATES.BRB domain!

## Install dependencies

> No automatic install is provided as it depends on your package manager and distribution. Here are some install command lines given for Ubuntu.

## Installation

- Installation depends on the provider you use, please follow the appropriate guide:
  - [Install with VmWare](./docs/install_with_vmware.md)
  - [Install with VirtualBox](./docs/install_with_virtualbox.md)
  - [Install with Ludus](./docs/install_with_ludus.md)

- Installation is in three parts:
  1. Templating: this will create the template to use (needed only for proxmox) 
  2. Providing: this will instantiate the virtual machines depending on your provider
  3. Provisioning: it is always made with ansible, it will install all the stuff to create the lab

## Special Thanks to

- Aleem Ladha [@LadhaAleem](https://x.com/LadhaAleem) for creating this project and converting the Barbhack-2025 workshop to an ansible playbook  
- M4yFly [@M4yFly](https://x.com/M4yFly) for the amazing GOAD project and ansible playbooks (This repo is based on the work of [Mayfly277](https://github.com/Orange-Cyberdefense/GOAD/))
- mpgn [@mpgn_x64](https://x.com/mpgn_x64) for the Barbhack Windows CTF
- mael91620 [@mael91620](https://github.com/mael91620) for the detailed writeup
- NetExec's dev team for this awesome tool!

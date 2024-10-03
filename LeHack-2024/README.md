# LEHACK FREE Workshop 2024 (Active Directory pwnage with NetExec)

<div>
<img src="./lehack-2024.png"/>
</div>

Welcome to the NetExec Active Directory Lab! This lab is designed to teach you how to exploit Active Directory (AD) environments using the powerful tool NetExec.

Originally featured in the LeHack2024 Workshop, this lab is now available for free to everyone! In this lab, you’ll explore how to use the powerful tool NetExec to efficiently compromise an Active Directory domain during an internal pentest.

The ultimate goal? Become Domain Administrator by following various attack paths, using nothing but NetExec! and Maybe BloodHound (Why not :P)

Obviously do not cheat by looking at the passwords and flags in the recipe files, the lab must start without user to full compromise

**Note**: One change has been made on this lab regarding the workshop, the part using msol module on nxc is replaced with a dump of lsass. The rest is identical.

### Original pitch

The Gallic camp was attacked by the Romans and it seems that a traitor made this attack possible! Two domains must be compromised to find it 🔥

### Public Writeups

- https://www.rayanle.cat/lehack-2024-netexec-workshop-writeup/ by [@rayanlecat](https://x.com/rayanlecat)
- https://blog.lasne.pro/posts/netexec-workshop-lehack2024/ by [@0xFalafel](https://x.com/0xFalafel)

Submit a PR to add your writeup to this list :)

## Install dependencies

> No automatic install is provided as it depend of your package manager and distribution. Here are some install command lines are given for ubuntu.

## Installation

- Installation depend of the provider you use, please follow the appropriate guide :
  - [Install with VmWare](./docs/install_with_vmware.md)
  - [Install with VirtualBox](./docs/install_with_virtualbox.md)

- Installation is in three parts :
  1. Templating : this will create the template to use (needed only for proxmox) 
  2. Providing : this will instantiate the virtual machines depending on your provider
  3. Provisioning : it is always made with ansible, it will install all the stuff to create the lab

## Special Thanks to

- Aleem Ladha [@LadhaAleem](https://x.com/LadhaAleem) for creating this project and converting the LEHACK-2024 workshop to an ansible playbook  
- M4yFly [@M4yFly](https://x.com/M4yFly) for the amazing GOAD porject and ansible playbooks (This repo is based on the work of [Mayfly277](https://github.com/Orange-Cyberdefense/GOAD/))
- mpgn [@mpgn_x64](https://x.com/mpgn_x64) for the LeHack workshop
- NetExec's dev team for this awesome tool !

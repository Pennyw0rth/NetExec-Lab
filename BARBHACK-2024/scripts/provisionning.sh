#!/bin/bash

JOKER_ATTACK=$(tput setaf 1; echo -n "[!] The Joker has launched an attack on Gotham!"; tput sgr0)
BATMAN_VICTORY=$(tput setaf 2; echo -n "[✓] Gotham is safe—for now."; tput sgr0)
ALERT=$(tput setaf 3; echo -n "[-] Oracle reports unusual activity across the city..."; tput sgr0)

# Battle counter and maximum defenses (retries)
DEFENSE_ROUND=0
MAX_DEFENSES=3

# Declare the current status of Gotham
echo "[+] Current command center: $(pwd)"
echo "[+] Preparing to deploy the Batcave setup for: BARBHACK"
echo "[+] Commissioner overseeing operations: $PROVIDER"

# Setting the Ansible command for Gotham's defense
if [ -z "$ANSIBLE_COMMAND" ]; then
  export ANSIBLE_COMMAND="ansible-playbook -i ../ad/BARBHACK/data/inventory -i ../ad/BARBHACK/providers/$PROVIDER/inventory.yml"
fi
echo "[+] The Batcomputer is online with the command: $ANSIBLE_COMMAND"

# Function to execute each mission (playbook)
function defend_gotham {
    if [ $DEFENSE_ROUND -eq $MAX_DEFENSES ]; then
        echo "$JOKER_ATTACK Gotham has fallen after $MAX_DEFENSES failed attempts! The villains reign!"
        exit 2
    fi

    echo "[+] Defense round: $DEFENSE_ROUND"
    let "DEFENSE_ROUND += 1"

    # Begin the mission with a 30-minute timeout unless it's a critical operation
    if [[ BARBHACK == "SCCM" ]]; then
        echo "$BATMAN_VICTORY Deploying without restrictions: $ANSIBLE_COMMAND $1"
        $ANSIBLE_COMMAND $1
    else
        echo "$BATMAN_VICTORY Defending Gotham with a 30-minute timeout: $ANSIBLE_COMMAND $1"
        timeout 30m $ANSIBLE_COMMAND $1
    fi

    mission_status=$(echo $?)

    if [ $mission_status -eq 4 ]; then
        echo "$JOKER_ATTACK Riddler jammed communications! Retrying: $ANSIBLE_COMMAND $1"
        defend_gotham $1

    elif [ $mission_status -eq 124 ]; then
        echo "$JOKER_ATTACK Timeout! Batman regroups for another mission: $ANSIBLE_COMMAND $1"
        defend_gotham $1

    elif [ $mission_status -eq 0 ]; then
        echo "$BATMAN_VICTORY Mission accomplished. Gotham is safe!"
        DEFENSE_ROUND=0
        return 0

    else
        echo "$JOKER_ATTACK Unexpected error! Reengaging (error code: $mission_status)"
        defend_gotham $1
    fi
}

# Begin deploying the Gotham defense infrastructure
echo "[+] Villains are assembling. The Batcave must be deployed before chaos takes over!"
SECONDS=0

case BARBHACK in
    "BARBHACK")
        echo "[+] Entering Arkham perimeter – initiating Gotham’s defensive protocols!"
        defend_gotham build.yml
        defend_gotham ad-servers.yml
        defend_gotham ad-parent_domain.yml
        #defend_gotham ad-child_domain.yml
        defend_gotham ad-members.yml
        #defend_gotham ad-trusts.yml
        defend_gotham ad-data.yml
        defend_gotham ad-gmsa.yml
        defend_gotham ad-relations.yml
        defend_gotham ad-acl.yml
        #defend_gotham servers.yml
        defend_gotham security.yml
        defend_gotham wayneservice.yml
        defend_gotham vulnerabilities.yml
        defend_gotham GmsaRobin.yml
        defend_gotham winscp.yml
        ;;
    *)
        echo "$JOKER_ATTACK Unknown district: BARBHACK. Batman cannot deploy defenses!"
        exit 1
        ;;
esac

# Final mission - reboot Batcave systems
echo "[+] Villains retreating! Rebooting Gotham's systems to lock down the city!"
defend_gotham reboot.yml
echo "$BATMAN_VICTORY Gotham is secure. The Joker has vanished into the shadows—for now."
duration=$SECONDS
echo "The Batcave was deployed in $((duration / 60)) minutes and $((duration % 60)) seconds."

# Final message - call to action for the operatives
echo ""
echo "🦇🦇🦇 Gotham needs you! A villain is still at large in the shadows. It's your mission to track them down! 🦇🦇🦇"
echo "Let justice guide your path, detective."
echo ""

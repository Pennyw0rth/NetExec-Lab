#!/bin/bash

JOKER_ATTACK=$(tput setaf 1; echo -n "[!] The Empire has launched an attack on the Rebellion!"; tput sgr0)
BATMAN_VICTORY=$(tput setaf 2; echo -n "[✓] The Force is strong — the galaxy is safe, for now."; tput sgr0)
ALERT=$(tput setaf 3; echo -n "[-] R2-D2 reports strange signals in the outer rim..."; tput sgr0)

# Battle counter and maximum defenses (retries)
DEFENSE_ROUND=0
MAX_DEFENSES=3

# Declare the current status of the operation
echo "[+] Current command post: $(pwd)"
echo "[+] Preparing to deploy the Rebel Base setup for: LEHACK"
echo "[+] Mission commander: $PROVIDER"

# Setting the Ansible command for the Rebel defense
if [ -z "$ANSIBLE_COMMAND" ]; then
  export ANSIBLE_COMMAND="ansible-playbook -i ../ad/LEHACK/data/inventory -i ../ad/LEHACK/providers/$PROVIDER/inventory.yml"
fi
echo "[+] The Holonet is active with the command: $ANSIBLE_COMMAND"

# Function to execute each mission (playbook)
function defend_gotham {
    if [ $DEFENSE_ROUND -eq $MAX_DEFENSES ]; then
        echo "$JOKER_ATTACK The Rebellion has fallen after $MAX_DEFENSES failed attempts! The Empire reigns supreme!"
        exit 2
    fi

    echo "[+] Defense round: $DEFENSE_ROUND"
    let "DEFENSE_ROUND += 1"

    # Begin the mission with a 30-minute timeout unless it's a critical operation
    if [[ BARBHACK == "SCCM" ]]; then
        echo "$BATMAN_VICTORY Deploying without restrictions: $ANSIBLE_COMMAND $1"
        $ANSIBLE_COMMAND $1
    else
        echo "$BATMAN_VICTORY Engaging Imperial forces with a 30-minute mission limit: $ANSIBLE_COMMAND $1"
        timeout 30m $ANSIBLE_COMMAND $1
    fi

    mission_status=$(echo $?)

    if [ $mission_status -eq 4 ]; then
        echo "$JOKER_ATTACK Imperial jammers disrupted communications! Retrying: $ANSIBLE_COMMAND $1"
        defend_gotham $1

    elif [ $mission_status -eq 124 ]; then
        echo "$JOKER_ATTACK Mission timeout! Rebel pilots regroup for another assault: $ANSIBLE_COMMAND $1"
        defend_gotham $1

    elif [ $mission_status -eq 0 ]; then
        echo "$BATMAN_VICTORY Mission accomplished. The Rebellion holds strong!"
        DEFENSE_ROUND=0
        return 0

    else
        echo "$JOKER_ATTACK Unknown disturbance in the Force! Retrying (error code: $mission_status)"
        defend_gotham $1
    fi
}

# Begin deploying the Rebel defense infrastructure
echo "[+] Imperial fleets are mobilizing. The Rebel Base must be deployed before the system falls!"
SECONDS=0

case BARBHACK in
    "BARBHACK")
        echo "[+] Entering Imperial perimeter – initiating Rebel defensive protocols!"
        defend_gotham build.yml
        #defend_gotham elk.yml
        #defend_gotham ad.yml
        defend_gotham ad-servers.yml
        defend_gotham ad-parent_domain.yml
        #defend_gotham ad-child_domain.yml
        defend_gotham ad-members.yml
        #defend_gotham ad-trusts.yml
        defend_gotham ad-data.yml
        defend_gotham 01.yml
        defend_gotham userrights.yml
        defend_gotham ad-gmsa.yml
        #defend_gotham laps.yml
        defend_gotham servers.yml
        #defend_gotham msqlsrv02.yml
        defend_gotham msqlsrv01.yml
        defend_gotham msqlsrv02.yml
        defend_gotham security.yml
        #msqlsrv02.yml
        defend_gotham cert.yml
        defend_gotham adcs.yml
        defend_gotham cert.yml
        defend_gotham ad-acl.yml
        defend_gotham security.yml
        #defend_gotham cert.yml
        defend_gotham vulnerabilities.yml
        defend_gotham local-users.yml
        defend_gotham cert.yml
        defend_gotham vulnerabilities.yml
        #defend_gotham winscp.yml
        defend_gotham reboot.yml
        #defend_gotham rebootsrv01.yml
        ;;
    *)
        echo "$JOKER_ATTACK Unknown system: BARBHACK. Rebel command cannot deploy defenses!"
        exit 1
        ;;
esac

# Final mission - reboot Rebel systems
echo "[+] Imperial forces retreating! Rebooting Rebel systems to secure the base!"
defend_gotham rebootsrv01.yml
echo "$BATMAN_VICTORY The galaxy is safe. The Sith have vanished into the void—for now."
duration=$SECONDS
echo "The Rebel Base was deployed in $((duration / 60)) minutes and $((duration % 60)) seconds."

# Final message - call to action for the operatives
echo ""
echo "✨✨✨ The Rebellion needs you! A Sith Lord remains hidden among the stars. It’s your mission to find them! ✨✨✨"
echo "May the Force be with you, always."
echo ""

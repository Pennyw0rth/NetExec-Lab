#!/bin/bash

KRAKEN_ATTACK=$(tput setaf 1; echo -n "[!] The Kraken has been released upon the Seven Seas!"; tput sgr0)
CAPTAIN_VICTORY=$(tput setaf 2; echo -n "[✓] The treasure is secured—the crew celebrates!"; tput sgr0)
ALERT=$(tput setaf 3; echo -n "[-] The lookout spots strange sails on the horizon..."; tput sgr0)

# Battle counter and maximum defenses (retries)
DEFENSE_ROUND=0
MAX_DEFENSES=3

# Declare the current status of the ship
echo "[+] Current coordinates: $(pwd)"
echo "[+] Preparing to deploy the Pirate Fleet for: $LAB"
echo "[+] The navigation charts are ready with the command: $ANSIBLE_COMMAND"

# Function to execute each mission (playbook)
function sail_the_seas {
    if [ $DEFENSE_ROUND -eq $MAX_DEFENSES ]; then
        echo "$KRAKEN_ATTACK The fleet has sunk after $MAX_DEFENSES failed attempts! Davy Jones claims his prize!"
        exit 2
    fi

    echo "[+] Voyage attempt: $DEFENSE_ROUND"
    let "DEFENSE_ROUND += 1"

    # Begin the mission with a 30-minute timeout unless it's a critical operation
    if [[ BARBHACK == "SCCM" ]]; then
        echo "$CAPTAIN_VICTORY Setting sail without restrictions: $ANSIBLE_COMMAND $1"
        $ANSIBLE_COMMAND $1
    else
        echo "$CAPTAIN_VICTORY Navigating the seas with a 30-minute voyage limit: $ANSIBLE_COMMAND $1"
        timeout 30m $ANSIBLE_COMMAND $1
    fi

    mission_status=$(echo $?)

    if [ $mission_status -eq 4 ]; then
        echo "$KRAKEN_ATTACK Navy ships jammed our signals! Retrying: $ANSIBLE_COMMAND $1"
        sail_the_seas $1

    elif [ $mission_status -eq 124 ]; then
        echo "$KRAKEN_ATTACK Voyage timeout! The crew regroups for another attempt: $ANSIBLE_COMMAND $1"
        sail_the_seas $1

    elif [ $mission_status -eq 0 ]; then
        echo "$CAPTAIN_VICTORY Voyage successful. The treasure awaits!"
        DEFENSE_ROUND=0
        return 0

    else
        echo "$KRAKEN_ATTACK Unexpected storm! Retrying (error code: $mission_status)"
        sail_the_seas $1
    fi
}

# Begin deploying the Pirate Fleet
echo "[+] The Royal Navy is approaching. The fleet must be deployed before they catch us!"
SECONDS=0

case $LAB in
    "BARBHACK")
        echo "[+] Raising the Jolly Roger – initiating Pirate Fleet protocols!"
        sail_the_seas build.yml
        #sail_the_seas elk.yml
        sail_the_seas ad-servers.yml
        sail_the_seas ad-parent_domain.yml
        #sail_the_seas ad-child_domain.yml
        sail_the_seas ad-members.yml
        #sail_the_seas ad-trusts.yml
        sail_the_seas ad-data.yml
        sail_the_seas ad-gmsa.yml
        #sail_the_seas laps.yml
        sail_the_seas msqlsrv02.yml
        sail_the_seas ad-relations.yml
        #sail_the_seas adcs.yml
        sail_the_seas ad-acl.yml
        sail_the_seas security.yml
        sail_the_seas vulnerabilities.yml
        sail_the_seas barbhack2025.yml
        ;;
    *)
        echo "$KRAKEN_ATTACK Unknown waters: $LAB. The Captain cannot navigate here!"
        exit 1
        ;;
esac

# Final mission - reboot the fleet
echo "[+] The Navy is retreating! Rebooting the fleet systems to secure our position!"
sail_the_seas reboot.yml
echo "$CAPTAIN_VICTORY The Seven Seas are ours. The Royal Navy has fled into the fog—for now."
duration=$SECONDS
echo "The Pirate Fleet was deployed in $((duration / 60)) minutes and $((duration % 60)) seconds."

# Final message - call to action for the crew
echo ""
echo "🏴‍☠️🏴‍☠️🏴‍☠️ Ahoy, Pirate! The treasure map leads to PIRATES.BRB. It's your mission to plunder the loot! 🏴‍☠️🏴‍☠️🏴‍☠️"
echo "May the wind be at your back and the rum never run dry!"
echo ""

#!/bin/bash

ROMAN_ATTACK=$(tput setaf 1; echo -n "[!] The Romans are attacking!"; tput sgr0)
VICTORY=$(tput setaf 2; echo -n "[✓] Victory is ours!"; tput sgr0)
ALERT=$(tput setaf 3; echo -n "[-] Gallic Scouts report unusual activity..."; tput sgr0)

# Battle counter and maximum defenses (retries)
BATTLE_COUNT=0
MAX_DEFENSES=3

# Declare the current state of the battlefield
echo "[+] Current battlefield: $(pwd)"
echo "[+] Preparing to build the Gallic camp of: $LAB"
echo "[+] Provider of reinforcements: $PROVIDER"

# Setting the Ansible command for deploying the camp
if [ -z  "$ANSIBLE_COMMAND" ]; then
  export ANSIBLE_COMMAND="ansible-playbook -i ../ad/$LAB/data/inventory -i ../ad/$LAB/providers/$PROVIDER/inventory"
fi
echo "[+] Gallic warriors are ready with the command: $ANSIBLE_COMMAND"

# Function to handle each battle (playbook execution)
function defend_gallic_camp {
    if [ $BATTLE_COUNT -eq $MAX_DEFENSES ]; then
        echo "$ROMAN_ATTACK Our defenses have fallen after $MAX_DEFENSES attempts! The Romans overrun the camp!"
        exit 2
    fi

    echo "[+] Defense round: $BATTLE_COUNT"
    let "BATTLE_COUNT += 1"

    # Begin the battle with a 30-minute timeout unless it's a special mission (SCCM)
    if [[ $LAB == "SCCM" ]]; then
        echo "$VICTORY Deploying without time restrictions: $ANSIBLE_COMMAND $1"
        $ANSIBLE_COMMAND $1
    else
        echo "$VICTORY Holding the line with a 30-minute timeout: $ANSIBLE_COMMAND $1"
        timeout 30m $ANSIBLE_COMMAND $1
    fi

    # Analyze the results of the battle
    battle_result=$(echo $?)

    if [ $battle_result -eq 4 ]; then
        echo "$ROMAN_ATTACK The traitor has disrupted communications! Retrying the battle: $ANSIBLE_COMMAND $1"
        defend_gallic_camp $1

    elif [ $battle_result -eq 124 ]; then
        echo "$ROMAN_ATTACK Time has run out, but we regroup for another attack: $ANSIBLE_COMMAND $1"
        defend_gallic_camp $1

    elif [ $battle_result -eq 0 ]; then
        echo "$VICTORY We have successfully defended the camp!"
        BATTLE_COUNT=0 # Reset defenses for the next battle
        return 0

    else
        echo "$ROMAN_ATTACK A serious error occurred! Preparing another counterattack (error code: $battle_result)"
        defend_gallic_camp $1
    fi
}

# Begin the process of building the lab (aka camp) by running all the necessary playbooks (battles)
echo "[+] The Romans are gathering their forces, and the camp must be built to withstand the siege!"
SECONDS=0

case $LAB in
    "LEHACK")
        echo "[+] Entering LEHACK territory - building the defenses of the Gallic camp!"
        defend_gallic_camp build.yml
        defend_gallic_camp ad-servers.yml
        defend_gallic_camp ad-parent_domain.yml
        #defend_gallic_camp ad-child_domain.yml
        defend_gallic_camp ad-members.yml
        #defend_gallic_camp ad-trusts.yml
        defend_gallic_camp ad-data.yml
        defend_gallic_camp ad-gmsa.yml
        defend_gallic_camp local-users.yml
        defend_gallic_camp laps.yml
        #defend_gallic_camp ad-relations.yml
        defend_gallic_camp adcs.yml
        defend_gallic_camp ad-acl.yml
        #defend_gallic_camp servers.yml
        defend_gallic_camp security.yml
        defend_gallic_camp vulnerabilities.yml
        defend_gallic_camp cred-acl.yml
        ;;
    *)
        echo "$ROMAN_ATTACK Unknown territory: $LAB. Unable to deploy defenses!"
        exit 1
        ;;
esac

# Final task - reboot the camp to ensure safety
echo "[+] The Romans are retreating! Prepare for the final reboot to secure the camp!"
defend_gallic_camp reboot.yml
echo "$VICTORY The Gallic camp is fully defended! The traitor is hiding, and the camp is ready for you to find them!"
duration=$SECONDS
echo "The camp was built in $((duration / 60)) minutes and $((duration % 60)) seconds."

# Final message - call to action for the participants
echo ""
echo "🔥🔥🔥 The battle is ready! The traitor is hiding somewhere in the camp, and it's your mission to find them! 🔥🔥🔥"
echo "May the gods of Gaul guide you as you embark on this dangerous quest!"
echo ""

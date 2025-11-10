#!/bin/bash

# ------------------------------
#  Rebel deployment — Star Wars
# ------------------------------
DEATHSTAR_ASCII='
               .-.
             .`   `.
            /  .-.  \
           |  /   \  |
           | |     | |
           | |     | |
           |  \   /  |
            \  `-`  /
             `.   .`
               `-`
         (The Death Star looms... )
'

XWING_ASCII='
           __/\__
        __/      \__
       /  _  /\  _  \
      /__/ \/  \/ \__\
         /_/      \_\
       (X-wing patrols the sector)
'

SITH_ATTACK=$(tput setaf 1; echo -n "[!] The Sith have launched an assault on the galaxy!"; tput sgr0)
JEDI_VICTORY=$(tput setaf 2; echo -n "[✓] The Republic holds — for now."; tput sgr0)
ASTROMECH_ALERT=$(tput setaf 3; echo -n "[-] R2-D2 reports anomalous signals across the sector..."; tput sgr0)

# Battle counter and maximum defenses (retries)
DEFENSE_ROUND=0
MAX_DEFENSES=3

# Declare the current status of operations
echo "$DEATHSTAR_ASCII"
echo "[+] Current command center: $(pwd)"
echo "[+] Preparing to deploy the Rebel base configuration for: LEHACK"
echo "[+] Fleet commander overseeing operations: $PROVIDER"
echo "$XWING_ASCII"

# Setting the Ansible command for the mission
if [ -z "$ANSIBLE_COMMAND" ]; then
  export ANSIBLE_COMMAND="ansible-playbook -i ../ad/LEHACK/data/inventory -i ../ad/LEHACK/providers/$PROVIDER/inventory.yml"
fi
echo "[+] The Holonet link is live with the command: $ANSIBLE_COMMAND"

# Function to execute each mission (playbook)
function launch_sortie {
    if [ $DEFENSE_ROUND -eq $MAX_DEFENSES ]; then
        echo "$SITH_ATTACK The Empire overwhelms us after $MAX_DEFENSES failed attempts! Darkness spreads!"
        exit 2
    fi

    echo "[+] Sortie number: $DEFENSE_ROUND"
    let "DEFENSE_ROUND += 1"

    # Begin the mission with a 30-minute timeout unless it's a critical operation
    if [[ STARSECTOR == "SCCM" ]]; then
        echo "$JEDI_VICTORY Deploying without restrictions: $ANSIBLE_COMMAND $1"
        $ANSIBLE_COMMAND $1
    else
        echo "$JEDI_VICTORY Engaging the mission with a 30-minute window: $ANSIBLE_COMMAND $1"
        timeout 30m $ANSIBLE_COMMAND $1
    fi

    mission_status=$?

    if [ $mission_status -eq 4 ]; then
        echo "$SITH_ATTACK Imperial jamming detected! Reattempting: $ANSIBLE_COMMAND $1"
        launch_sortie $1

    elif [ $mission_status -eq 124 ]; then
        echo "$SITH_ATTACK Timeout! The Jedi regroup for another sortie: $ANSIBLE_COMMAND $1"
        launch_sortie $1

    elif [ $mission_status -eq 0 ]; then
        echo "$JEDI_VICTORY Mission successful. This sector is secure."
        DEFENSE_ROUND=0
        return 0

    else
        echo "$SITH_ATTACK Unexpected anomaly! Re-engaging (error code: $mission_status)"
        launch_sortie $1
    fi
}

# Begin deploying the Rebel infrastructure
echo "[+] Imperial forces are mobilizing. The Rebel base must be established before the sector falls!"
SECONDS=0

case STARSECTOR in
    "STARSECTOR")
        echo "[+] Entering Outer Rim perimeter – initiating Rebel protocols!"
        launch_sortie build.yml
        #launch_sortie elk.yml
        #launch_sortie ad.yml
        launch_sortie ad-servers.yml
        launch_sortie ad-parent_domain.yml
        #launch_sortie ad-child_domain.yml
        launch_sortie ad-members.yml
        #launch_sortie ad-trusts.yml
        launch_sortie ad-data.yml
        launch_sortie 01.yml
        launch_sortie userrights.yml
        launch_sortie ad-gmsa.yml
        #launch_sortie laps.yml
        launch_sortie servers.yml
        launch_sortie msqlsrv01.yml
        launch_sortie msqlsrv02.yml
        launch_sortie security.yml
        launch_sortie cert.yml
        launch_sortie adcs.yml
        launch_sortie cert.yml
        launch_sortie ad-acl.yml
        launch_sortie security.yml
        launch_sortie vulnerabilities.yml
        launch_sortie local-users.yml
        launch_sortie cert.yml
        launch_sortie vulnerabilities.yml
        launch_sortie reboot.yml
        ;;
    *)
        echo "$SITH_ATTACK Unknown sector: STARSECTOR. The Jedi cannot deploy!"
        exit 1
        ;;
esac

# Final mission - reboot base systems
echo "[+] Imperial fleet withdrawing! Initiating system reboot to secure the base!"
launch_sortie rebootsrv01.yml
echo "$JEDI_VICTORY The Republic holds. The Sith have withdrawn into the shadows—for now."
duration=$SECONDS
echo "The Rebel base was brought online in $((duration / 60)) minutes and $((duration % 60)) seconds."

# Final message - lightsaber call to action
echo ""
echo "🔴🔵🔴🔵🔴 The galaxy needs you! A dark presence still lingers in the shadows. It's your mission to hunt it down! 🔴🔵🔴🔵🔴"
echo "May the Force guide your path, pilot."
echo ""

# Wireshark Role

This Ansible role installs Wireshark network protocol analyzer on Windows hosts for network traffic analysis and forensics.

## Features

- Downloads and installs Wireshark silently
- Includes Npcap packet capture driver
- Creates desktop shortcuts
- Adds Wireshark to system PATH
- Validates installation
- Supports customizable installation options

## Requirements

- Ansible 2.9+
- Windows hosts with internet connectivity
- Administrator privileges on target hosts

## Role Variables

### Optional Variables (with defaults)
- `wireshark_version`: Version to install (default: "4.2.0")
- `wireshark_installer_url`: Download URL (auto-generated from version)
- `wireshark_install_dir`: Installation directory (default: "C:\\Program Files\\Wireshark")
- `wireshark_silent_install`: Silent installation (default: true)
- `wireshark_install_npcap`: Install Npcap driver (default: true)
- `wireshark_install_usb_capture`: Install USB capture support (default: false)
- `wireshark_create_desktop_shortcut`: Create desktop shortcut (default: true)
- `wireshark_validate_installation`: Validate after install (default: true)

## Dependencies

None

## Example Playbook

```yaml
- hosts: windows
  roles:
    - wireshark
```

## Custom Configuration

```yaml
- hosts: windows
  roles:
    - role: wireshark
      vars:
        wireshark_version: "4.2.0"
        wireshark_install_npcap: true
        wireshark_create_desktop_shortcut: true
```

## Tags

- `wireshark`: All tasks
- `setup`: Directory creation
- `check`: Installation check
- `download`: Installer download
- `install`: Installation tasks
- `validate`: Installation validation
- `shortcuts`: Shortcut creation
- `path`: PATH modification
- `cleanup`: Cleanup tasks
- `info`: Information display

## Usage Examples

```bash
# Install Wireshark on all Windows hosts
ansible-playbook playbook.yml --tags "wireshark"

# Only download and install (skip validation)
ansible-playbook playbook.yml --tags "download,install"

# Skip cleanup of installer file
ansible-playbook playbook.yml --skip-tags "cleanup"
```

## Installation Process

1. Creates temporary directory
2. Checks if already installed
3. Downloads installer from official source
4. Performs silent installation with Npcap
5. Validates installation
6. Creates shortcuts and adds to PATH
7. Cleans up installer file

## Security Considerations

- Downloads from official Wireshark repository
- Requires administrator privileges
- Installs Npcap for packet capture (requires elevated permissions)
- Consider network security policies for packet capture tools

## Troubleshooting

1. **Download failures**: Check internet connectivity and firewall rules
2. **Installation failures**: Verify administrator privileges
3. **Npcap issues**: May require system reboot after installation
4. **PATH issues**: Log out/in or restart to refresh environment variables

## License

MIT

# Ansible Role: Elastic Container

An Ansible role that runs [Elastic Container](https://github.com/peasead/elastic-container) on a Linux system.

- Creates an agent policy
- Add 2 integrations to the policy (Elastic Defend and Windows)
- Configures one (1) Fleet server
- Downloads the compatible agent version and drops it inside the ludus host (`/opt/ludus/resources/elastic`) for "offline" agent installations.
- Reconfigures the output elasticsearch URL to be an array of the ipv4 address of this elastic server
- Writes the enrollment token to `{{ ludus_elastic_container_install_path }}/enrollment_token.txt`. With this token and the IP address assigned to the elastic server, you are ready to [deploy agents](https://github.com/badsectorlabs/ludus_elastic_agent).

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    ludus_elastic_container_install_path: /opt/elastic_container
    ludus_elastic_password: "elasticpassword"
    ludus_elastic_stack_version: "9.0.1"
    ludus_elastic_container_branch: HEAD

## Dependencies

[geerlingguy.docker](https://github.com/geerlingguy/ansible-role-docker)

[Optional] Check out the [.env example](./files/env.example) prior to **uploading** the role (if you choose to clone and add).

## Example Playbook

```yaml
- hosts: elastic-server
  roles:
    - badsectorlabs.ludus_elastic_container
```

## Example Ludus Range Config

```yaml
ludus:
  - vm_name: "{{ range_id }}-elastic-server"
    hostname: "{{ range_id }}-elastic-server"
    template: debian-12-x64-server-template
    vlan: 20
    ip_last_octet: 2
    ram_gb: 8
    cpus: 4
    linux: true
    testing:
      snapshot: false
      block_internet: false
    roles:
      - badsectorlabs.ludus_elastic_container
    role_vars:
      ludus_elastic_password: "hellofromtheotherside"
```

Set the `role_vars` to install Elastic v8.X:
```yaml
ludus:
  - vm_name: "{{ range_id }}-elastic-server"
    hostname: "{{ range_id }}-elastic-server"
    template: debian-12-x64-server-template
    vlan: 20
    ip_last_octet: 2
    ram_gb: 8
    cpus: 4
    linux: true
    testing:
      snapshot: false
      block_internet: false
    roles:
      - badsectorlabs.ludus_elastic_container
    role_vars:
      ludus_elastic_password: "hellofromtheotherside"
      ludus_elastic_stack_version: "8.12.2"
      ludus_elastic_container_branch: 05c0b91a36a0918d095c28295a9c64a9def275f5 # Known good commit, 2024-07-03
```

## Ludus setup

```
# Add the role to your ludus host
ludus ansible roles add badsectorlabs.ludus_elastic_container

# Get your config into a file so you can assign to a VM
ludus range config get > config.yml

# Edit config to add the role to the VMs you wish to make an elastic server
ludus range config set -f config.yml

# Deploy the range with the user-defined-roles ONLY :)
ludus range deploy -t user-defined-roles
```

- Once deployed, access the kibana UI at `https://<IP>:5601`

- In Kibana UI, you can enable your own detection rules (to trigger alerts). The Windows, Linux and MacOS detection rules are enabled by default to get the user started quickly. This is a [good reference](https://www.elastic.co/guide/en/security/current/rules-ui-management.html) on how to manage detection rules.

## License

Apache-2.0

## Author Information

This role was created by [Bad Sector Labs](https://badsectorlabs.com/), for [Ludus](https://ludus.cloud/).

## Resources/Credits

- Excellent blog post from Elastic [Security Labs](https://www.elastic.co/security-labs/the-elastic-container-project)
- This role heavily utilized this [awesome project](https://github.com/peasead/elastic-container) by @peasead
- [Kibana Fleet API](https://www.elastic.co/guide/en/fleet/8.12/fleet-api-docs.html)
- [Elastic Integrations](https://www.elastic.co/guide/en/security/8.12/create-defend-policy-api.html)

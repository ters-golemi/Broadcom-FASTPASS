# Ansible Automation for Broadcom FASTPATH Switches

This directory contains Ansible playbooks and configurations for automating the setup of Broadcom FASTPATH switches with VLANs and OSPF routing.

## Directory Structure

```
ansible/
├── configure_switches.yml    # Main playbook for switch configuration
├── inventory.ini            # Inventory file with switch definitions
├── requirements.yml         # Ansible collection requirements
├── group_vars/             # Group variable files
├── host_vars/              # Host-specific variable files
└── templates/              # Configuration templates
```

## Prerequisites

1. Ansible 2.9 or later installed
2. Network connectivity to all switches
3. Valid credentials for switch access
4. Python 3.6 or later

## Installation

### Install Ansible

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install ansible -y
```

**RHEL/CentOS:**
```bash
sudo yum install ansible -y
```

**macOS:**
```bash
brew install ansible
```

**Using pip:**
```bash
pip install ansible
```

### Install Required Collections

```bash
cd ansible
ansible-galaxy collection install -r requirements.yml
```

## Configuration

### Update Inventory File

Edit `inventory.ini` to match your environment:

```ini
[broadcom_switches]
switch1 ansible_host=<SWITCH1_IP>
switch2 ansible_host=<SWITCH2_IP>
switch3 ansible_host=<SWITCH3_IP>

[broadcom_switches:vars]
ansible_network_os=broadcom_fastpath
ansible_connection=network_cli
ansible_user=<USERNAME>
ansible_password=<PASSWORD>
ansible_become=yes
ansible_become_method=enable
```

Replace:
- `<SWITCH1_IP>`, `<SWITCH2_IP>`, `<SWITCH3_IP>` with actual IP addresses
- `<USERNAME>` with the switch username
- `<PASSWORD>` with the switch password

### Using Ansible Vault for Security

To encrypt sensitive credentials:

```bash
# Encrypt the inventory file
ansible-vault encrypt inventory.ini

# Create an encrypted variables file
ansible-vault create group_vars/broadcom_switches.yml
```

Add credentials in the encrypted file:
```yaml
ansible_user: admin
ansible_password: secretpassword
```

## Usage

### Run Complete Configuration

```bash
# From the ansible directory
ansible-playbook -i inventory.ini configure_switches.yml

# If using Ansible Vault
ansible-playbook -i inventory.ini configure_switches.yml --ask-vault-pass
```

### Run with Verbose Output

```bash
ansible-playbook -i inventory.ini configure_switches.yml -v   # Basic verbosity
ansible-playbook -i inventory.ini configure_switches.yml -vv  # More verbose
ansible-playbook -i inventory.ini configure_switches.yml -vvv # Very verbose
```

### Run Specific Configuration Tasks

The playbook uses tags to allow selective execution:

```bash
# Configure only basic settings
ansible-playbook -i inventory.ini configure_switches.yml --tags basic

# Configure only VLANs
ansible-playbook -i inventory.ini configure_switches.yml --tags vlan

# Configure only SVI interfaces
ansible-playbook -i inventory.ini configure_switches.yml --tags svi

# Configure only OSPF
ansible-playbook -i inventory.yml configure_switches.yml --tags ospf

# Configure only access ports
ansible-playbook -i inventory.ini configure_switches.yml --tags access_ports

# Configure only trunk ports
ansible-playbook -i inventory.ini configure_switches.yml --tags trunk_ports

# Save configuration
ansible-playbook -i inventory.ini configure_switches.yml --tags save
```

### Run on Specific Switches

```bash
# Configure only switch1
ansible-playbook -i inventory.ini configure_switches.yml --limit switch1

# Configure switch1 and switch2
ansible-playbook -i inventory.ini configure_switches.yml --limit switch1,switch2
```

### Dry Run (Check Mode)

```bash
# See what changes would be made without applying them
ansible-playbook -i inventory.ini configure_switches.yml --check
```

## Verification

### Test Connectivity

```bash
# Ping all switches
ansible -i inventory.ini broadcom_switches -m ping

# Test raw connection
ansible -i inventory.ini broadcom_switches -m raw -a "show version"
```

### Run Ad-hoc Commands

```bash
# Show VLAN configuration
ansible -i inventory.ini broadcom_switches -m broadcom_fastpath_command \
  -a "commands='show vlan'"

# Show OSPF neighbors
ansible -i inventory.ini broadcom_switches -m broadcom_fastpath_command \
  -a "commands='show ip ospf neighbor'"

# Show running configuration
ansible -i inventory.ini broadcom_switches -m broadcom_fastpath_command \
  -a "commands='show running-config'"
```

## Available Tags

| Tag          | Description                            |
|--------------|----------------------------------------|
| basic        | Basic configuration (hostname, routing)|
| vlan         | VLAN creation and configuration        |
| svi          | SVI interface configuration            |
| ospf         | OSPF routing protocol configuration    |
| access_ports | Access port configuration              |
| trunk_ports  | Trunk port configuration               |
| save         | Save configuration to startup-config   |

## Troubleshooting

### Connection Issues

If you encounter connection errors:

1. Verify network connectivity:
   ```bash
   ping <switch_ip>
   ```

2. Test SSH access:
   ```bash
   ssh <username>@<switch_ip>
   ```

3. Verify credentials in inventory file

4. Check firewall rules

### Module Not Found

If Ansible can't find the Broadcom FASTPATH module:

1. Check if using generic network modules
2. May need to use `cli_config` or `cli_command` modules
3. Consider creating custom module for FASTPATH

### Playbook Execution Errors

1. Run with increased verbosity:
   ```bash
   ansible-playbook -i inventory.ini configure_switches.yml -vvv
   ```

2. Check syntax:
   ```bash
   ansible-playbook --syntax-check configure_switches.yml
   ```

3. Validate inventory:
   ```bash
   ansible-inventory -i inventory.ini --list
   ```

## Customization

### Modify VLAN Configuration

Edit the `vlans` variable in `configure_switches.yml`:

```yaml
vlans:
  - vlan_id: 10
    vlan_name: "VLAN_10"
    description: "Data VLAN"
  - vlan_id: 20
    vlan_name: "VLAN_20"
    description: "Voice VLAN"
  # Add more VLANs as needed
```

### Modify IP Addressing

Update the IP addresses in the SVI configuration tasks for each switch.

### Modify Port Assignments

Update the access port and trunk port configuration tasks to match your requirements.

## Best Practices

1. Always test in a lab environment first
2. Use Ansible Vault for sensitive data
3. Keep inventory files in version control (encrypted)
4. Document any customizations
5. Take configuration backups before making changes
6. Use tags for incremental deployments
7. Run in check mode before actual deployment

## Additional Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Network Automation](https://docs.ansible.com/ansible/latest/network/index.html)
- [Broadcom FASTPATH Documentation](https://www.broadcom.com/)

## Support

For issues related to:
- Ansible playbooks: Check this repository's documentation
- Broadcom FASTPATH: Consult Broadcom documentation
- Ansible: Visit [Ansible Community](https://www.ansible.com/community)

# Broadcom FASTPASS Network Configuration

This repository contains comprehensive documentation, configuration templates, and Ansible automation for setting up a network using Broadcom switches with FASTPATH operating system.

## Overview

This project provides everything needed to configure a three-switch network with:
- Three VLANs (Data, Voice, Management)
- SVI Layer 3 interfaces with IP addressing
- OSPF routing protocol between switches
- Access ports for end devices
- Trunk ports for inter-switch connectivity
- Automated deployment using Ansible

## Repository Structure

```
.
├── README.md                      # This file
├── ansible/                       # Ansible automation files
│   ├── configure_switches.yml    # Main playbook
│   ├── inventory.ini             # Switch inventory
│   ├── requirements.yml          # Ansible dependencies
│   └── README.md                 # Ansible usage guide
├── configs/                       # Manual configuration templates
│   ├── switch1_config.txt        # Switch 1 commands
│   ├── switch2_config.txt        # Switch 2 commands
│   └── switch3_config.txt        # Switch 3 commands
├── docs/                          # Documentation
│   ├── SETUP_GUIDE.md            # Detailed step-by-step guide
│   ├── NETWORK_TOPOLOGY.md       # Network topology documentation
│   └── QUICK_REFERENCE.md        # Quick reference guide
└── scripts/                       # Utility scripts
    └── verify_config.sh          # Configuration verification script
```

## Quick Start

### Option 1: Automated Setup with Ansible

1. Install Ansible and required collections:
   ```bash
   pip install ansible
   cd ansible
   ansible-galaxy collection install -r requirements.yml
   ```

2. Update the inventory file with your switch IP addresses and credentials:
   ```bash
   vim ansible/inventory.ini
   ```

3. Run the playbook:
   ```bash
   cd ansible
   ansible-playbook -i inventory.ini configure_switches.yml
   ```

### Option 2: Manual Configuration

1. Review the detailed setup guide:
   ```bash
   cat docs/SETUP_GUIDE.md
   ```

2. Use the configuration templates for each switch:
   ```bash
   cat configs/switch1_config.txt
   cat configs/switch2_config.txt
   cat configs/switch3_config.txt
   ```

3. Apply configurations via console or SSH to each switch

## Network Design

### VLANs
- **VLAN 10**: Data VLAN (10.10.10.0/24)
- **VLAN 20**: Voice VLAN (10.10.20.0/24)
- **VLAN 30**: Management VLAN (10.10.30.0/24)

### IP Addressing

| Switch   | VLAN 10 SVI  | VLAN 20 SVI  | VLAN 30 SVI  | OSPF Router ID |
|----------|--------------|--------------|--------------|----------------|
| Switch 1 | 10.10.10.1   | 10.10.20.1   | 10.10.30.1   | 1.1.1.1        |
| Switch 2 | 10.10.10.2   | 10.10.20.2   | 10.10.30.2   | 2.2.2.2        |
| Switch 3 | 10.10.10.3   | 10.10.20.3   | 10.10.30.3   | 3.3.3.3        |

### Port Assignments (All Switches)
- **Ports 0/1-0/3**: Access ports for VLAN 10 (Data)
- **Ports 0/4-0/6**: Access ports for VLAN 20 (Voice)
- **Ports 0/7-0/8**: Access ports for VLAN 30 (Management)
- **Ports 0/23-0/24**: Trunk ports for inter-switch links

### Topology
```
           Switch 1
              |
    +---------+---------+
    |                   |
Switch 2            Switch 3
    |                   |
    +-------------------+
```

## Documentation

- **[Quick Reference](docs/QUICK_REFERENCE.md)**: Quick reference guide for common tasks
- **[Setup Guide](docs/SETUP_GUIDE.md)**: Comprehensive step-by-step configuration guide
- **[Network Topology](docs/NETWORK_TOPOLOGY.md)**: Detailed network topology and design
- **[Ansible README](ansible/README.md)**: Ansible automation usage guide

## Features

- Complete VLAN configuration for three networks
- Layer 3 SVI interfaces for inter-VLAN routing
- OSPF routing protocol for dynamic routing
- Access port configuration for end devices
- Trunk port configuration for switch interconnection
- Automated deployment with Ansible
- Manual configuration templates
- Comprehensive verification procedures
- Security best practices
- Troubleshooting guides

## Requirements

### Hardware
- Three Broadcom switches running FASTPATH OS
- Console cables or network connectivity for management
- Ethernet cables for trunk connections

### Software
- Broadcom FASTPATH operating system
- Ansible 2.9 or later (for automation)
- Python 3.6 or later (for Ansible)

## Usage

Detailed usage instructions are available in the documentation:

1. **Manual Configuration**: Follow [docs/SETUP_GUIDE.md](docs/SETUP_GUIDE.md)
2. **Ansible Automation**: Follow [ansible/README.md](ansible/README.md)
3. **Network Topology**: Reference [docs/NETWORK_TOPOLOGY.md](docs/NETWORK_TOPOLOGY.md)

## Verification

After configuration, verify the setup:

### Using the Verification Script
```bash
# Run the automated verification script
./scripts/verify_config.sh
```

### Manual Verification Commands
```bash
# On each switch
show vlan
show ip interface
show interfaces trunk
show ip ospf neighbor
show ip route
```

## Support and Contribution

For issues, questions, or contributions, please refer to the documentation in the `docs/` directory.

## License

This project is provided as-is for educational and deployment purposes.

## Additional Notes

- Always test configurations in a lab environment before production deployment
- Maintain configuration backups
- Follow change management procedures
- Document any customizations made to the base configuration
- Review security settings for production environments
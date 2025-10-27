# Quick Reference Guide - Broadcom FASTPATH Network Setup

## Quick Start Commands

### Ansible Deployment (Fastest Method)
```bash
# 1. Update inventory with your switch IPs
vim ansible/inventory.ini

# 2. Run the playbook
cd ansible
ansible-playbook -i inventory.ini configure_switches.yml
```

### Manual Configuration
```bash
# Copy the configuration from configs/ directory
# For Switch 1: configs/switch1_config.txt
# For Switch 2: configs/switch2_config.txt  
# For Switch 3: configs/switch3_config.txt
```

## Network Summary

### VLANs
| VLAN | Name    | Network       | Purpose    |
|------|---------|---------------|------------|
| 10   | VLAN_10 | 10.10.10.0/24 | Data       |
| 20   | VLAN_20 | 10.10.20.0/24 | Voice      |
| 30   | VLAN_30 | 10.10.30.0/24 | Management |

### Switch IP Addresses
| Switch   | VLAN 10      | VLAN 20      | VLAN 30      | Router ID |
|----------|--------------|--------------|--------------|-----------|
| Switch 1 | 10.10.10.1   | 10.10.20.1   | 10.10.30.1   | 1.1.1.1   |
| Switch 2 | 10.10.10.2   | 10.10.20.2   | 10.10.30.2   | 2.2.2.2   |
| Switch 3 | 10.10.10.3   | 10.10.20.3   | 10.10.30.3   | 3.3.3.3   |

### Port Assignments (Same on All Switches)
| Ports    | Mode   | VLAN | Purpose                |
|----------|--------|------|------------------------|
| 0/1-0/3  | Access | 10   | Data devices           |
| 0/4-0/6  | Access | 20   | Voice devices          |
| 0/7-0/8  | Access | 30   | Management devices     |
| 0/23-0/24| Trunk  | All  | Inter-switch links     |

## Essential Verification Commands

```bash
# VLANs
show vlan

# IP Interfaces
show ip interface

# Trunk Ports
show interfaces trunk
show interfaces switchport 0/23

# OSPF Status
show ip ospf
show ip ospf neighbor
show ip route ospf

# Complete Route Table
show ip route

# Save Configuration
write memory
```

## Quick Troubleshooting

### Issue: OSPF neighbors not forming
```bash
# Check IP connectivity
ping 10.10.10.1
ping 10.10.10.2
ping 10.10.10.3

# Verify OSPF is running
show ip ospf
show ip ospf interface
```

### Issue: VLANs not working across switches
```bash
# Verify trunk configuration
show interfaces trunk
show vlan

# Check trunk port status
show interfaces status
```

### Issue: Access ports not working
```bash
# Check port VLAN assignment
show interfaces switchport 0/1
show vlan port 0/1
```

## Ansible Quick Commands

```bash
# Test connectivity
ansible -i inventory.ini broadcom_switches -m ping

# Run specific configuration sections
ansible-playbook -i inventory.ini configure_switches.yml --tags vlan
ansible-playbook -i inventory.ini configure_switches.yml --tags ospf

# Configure specific switch
ansible-playbook -i inventory.ini configure_switches.yml --limit switch1

# Dry run (no changes)
ansible-playbook -i inventory.ini configure_switches.yml --check
```

## OSPF Configuration Summary

```
Process ID: 1
Area: 0 (Backbone)
Networks: 10.10.10.0/24, 10.10.20.0/24, 10.10.30.0/24
```

## Physical Connections

```
Switch1:0/23 <--> Switch2:0/23
Switch1:0/24 <--> Switch3:0/24
Switch2:0/24 <--> Switch3:0/23
```

## Files in This Repository

| File/Directory              | Purpose                                    |
|-----------------------------|--------------------------------------------|
| README.md                   | Main project overview                      |
| docs/SETUP_GUIDE.md         | Detailed step-by-step configuration guide  |
| docs/NETWORK_TOPOLOGY.md    | Network topology and design details        |
| ansible/configure_switches.yml | Main Ansible playbook                   |
| ansible/inventory.ini       | Switch inventory for Ansible               |
| ansible/README.md           | Ansible usage guide                        |
| configs/switch1_config.txt  | Manual config for Switch 1                 |
| configs/switch2_config.txt  | Manual config for Switch 2                 |
| configs/switch3_config.txt  | Manual config for Switch 3                 |

## Next Steps After Configuration

1. Verify all OSPF neighbors are up
2. Test inter-VLAN routing
3. Connect end devices to access ports
4. Configure additional security features (port security, ACLs)
5. Set up monitoring and logging
6. Take configuration backups

For detailed information, see:
- Full setup guide: `docs/SETUP_GUIDE.md`
- Network topology: `docs/NETWORK_TOPOLOGY.md`
- Ansible guide: `ansible/README.md`

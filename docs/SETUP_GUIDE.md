# Broadcom FASTPATH Network Setup Guide

## Overview
This guide provides detailed step-by-step instructions for configuring a network using Broadcom switches with FASTPATH operating system. The setup includes three VLANs, SVI Layer 3 interfaces, OSPF routing protocol, access ports, and trunk ports for inter-switch connectivity.

## Network Topology

```
                    +------------+
                    |  Switch 1  |
                    | 10.10.x.1  |
                    +-----+------+
                          |
          +---------------+---------------+
          |                               |
    +-----+------+                  +-----+------+
    |  Switch 2  |                  |  Switch 3  |
    | 10.10.x.2  |                  | 10.10.x.3  |
    +------------+                  +------------+

Trunk Connections:
- Switch1 port 0/23 <--> Switch2 port 0/23
- Switch1 port 0/24 <--> Switch3 port 0/24
- Switch2 port 0/24 <--> Switch3 port 0/23
```

## Network Design

### VLANs Configuration
- **VLAN 10**: Data VLAN (10.10.10.0/24)
- **VLAN 20**: Voice VLAN (10.10.20.0/24)
- **VLAN 30**: Management VLAN (10.10.30.0/24)

### IP Addressing Scheme

#### Switch 1
- VLAN 10 SVI: 10.10.10.1/24
- VLAN 20 SVI: 10.10.20.1/24
- VLAN 30 SVI: 10.10.30.1/24
- OSPF Router ID: 1.1.1.1

#### Switch 2
- VLAN 10 SVI: 10.10.10.2/24
- VLAN 20 SVI: 10.10.20.2/24
- VLAN 30 SVI: 10.10.30.2/24
- OSPF Router ID: 2.2.2.2

#### Switch 3
- VLAN 10 SVI: 10.10.10.3/24
- VLAN 20 SVI: 10.10.20.3/24
- VLAN 30 SVI: 10.10.30.3/24
- OSPF Router ID: 3.3.3.3

### Port Assignments

Each switch has the following port assignments:
- **Ports 0/1-0/3**: Access ports for VLAN 10
- **Ports 0/4-0/6**: Access ports for VLAN 20
- **Ports 0/7-0/8**: Access ports for VLAN 30
- **Ports 0/23-0/24**: Trunk ports for inter-switch connectivity

## Prerequisites

1. Three Broadcom switches running FASTPATH OS
2. Console access to all switches
3. Ansible installed on the management workstation
4. Network connectivity between management workstation and switches
5. Appropriate credentials for switch access

## Step-by-Step Manual Configuration

### Step 1: Initial Switch Access and Basic Configuration

#### Switch 1 Configuration

```bash
# Access the switch via console
# Login with default or existing credentials

# Enter privileged EXEC mode
enable

# Enter global configuration mode
configure

# Set hostname
hostname switch1

# Enable IP routing
ip routing

# Exit configuration mode
exit
```

#### Repeat for Switch 2 and Switch 3
Change the hostname to `switch2` and `switch3` respectively.

### Step 2: Create VLANs on All Switches

Execute on all three switches:

```bash
# Enter VLAN database mode
vlan database

# Create VLAN 10
vlan 10
vlan name 10 VLAN_10

# Create VLAN 20
vlan 20
vlan name 20 VLAN_20

# Create VLAN 30
vlan 30
vlan name 30 VLAN_30

# Exit VLAN database mode
exit

# Verify VLANs were created
show vlan
```

### Step 3: Configure SVI Layer 3 Interfaces

#### Switch 1 SVI Configuration

```bash
# Enter global configuration mode
configure

# Configure VLAN 10 interface
interface vlan 10
ip address 10.10.10.1 255.255.255.0
no shutdown
exit

# Configure VLAN 20 interface
interface vlan 20
ip address 10.10.20.1 255.255.255.0
no shutdown
exit

# Configure VLAN 30 interface
interface vlan 30
ip address 10.10.30.1 255.255.255.0
no shutdown
exit

# Exit configuration mode
exit

# Verify interface configuration
show ip interface
```

#### Switch 2 SVI Configuration

```bash
configure

interface vlan 10
ip address 10.10.10.2 255.255.255.0
no shutdown
exit

interface vlan 20
ip address 10.10.20.2 255.255.255.0
no shutdown
exit

interface vlan 30
ip address 10.10.30.2 255.255.255.0
no shutdown
exit

exit
show ip interface
```

#### Switch 3 SVI Configuration

```bash
configure

interface vlan 10
ip address 10.10.10.3 255.255.255.0
no shutdown
exit

interface vlan 20
ip address 10.10.20.3 255.255.255.0
no shutdown
exit

interface vlan 30
ip address 10.10.30.3 255.255.255.0
no shutdown
exit

exit
show ip interface
```

### Step 4: Configure Access Ports

#### Switch 1 Access Ports

```bash
configure

# Configure VLAN 10 access ports
interface 0/1
switchport mode access
switchport access vlan 10
no shutdown
exit

interface 0/2
switchport mode access
switchport access vlan 10
no shutdown
exit

interface 0/3
switchport mode access
switchport access vlan 10
no shutdown
exit

# Configure VLAN 20 access ports
interface 0/4
switchport mode access
switchport access vlan 20
no shutdown
exit

interface 0/5
switchport mode access
switchport access vlan 20
no shutdown
exit

interface 0/6
switchport mode access
switchport access vlan 20
no shutdown
exit

# Configure VLAN 30 access ports
interface 0/7
switchport mode access
switchport access vlan 30
no shutdown
exit

interface 0/8
switchport mode access
switchport access vlan 30
no shutdown
exit

exit

# Verify port configuration
show running-config interface 0/1
show interfaces switchport 0/1
```

#### Switch 2 and Switch 3 Access Ports

Repeat the same access port configuration on Switch 2 and Switch 3 with the same VLAN assignments.

### Step 5: Configure Trunk Ports

#### Switch 1 Trunk Configuration

```bash
configure

# Configure trunk port 0/23 (connected to Switch 2)
interface 0/23
switchport mode trunk
switchport trunk allowed vlan add 10,20,30
no shutdown
exit

# Configure trunk port 0/24 (connected to Switch 3)
interface 0/24
switchport mode trunk
switchport trunk allowed vlan add 10,20,30
no shutdown
exit

exit

# Verify trunk configuration
show interfaces switchport 0/23
show interfaces switchport 0/24
```

#### Switch 2 Trunk Configuration

```bash
configure

# Configure trunk port 0/23 (connected to Switch 1)
interface 0/23
switchport mode trunk
switchport trunk allowed vlan add 10,20,30
no shutdown
exit

# Configure trunk port 0/24 (connected to Switch 3)
interface 0/24
switchport mode trunk
switchport trunk allowed vlan add 10,20,30
no shutdown
exit

exit
```

#### Switch 3 Trunk Configuration

```bash
configure

# Configure trunk port 0/23 (connected to Switch 2)
interface 0/23
switchport mode trunk
switchport trunk allowed vlan add 10,20,30
no shutdown
exit

# Configure trunk port 0/24 (connected to Switch 1)
interface 0/24
switchport mode trunk
switchport trunk allowed vlan add 10,20,30
no shutdown
exit

exit
```

### Step 6: Configure OSPF Routing Protocol

#### Switch 1 OSPF Configuration

```bash
configure

# Enable OSPF with process ID 1
router ospf 1

# Set router ID
router-id 1.1.1.1

# Add network statements for all VLANs
network 10.10.10.0/24 area 0
network 10.10.20.0/24 area 0
network 10.10.30.0/24 area 0

exit
exit

# Verify OSPF configuration
show ip ospf
show ip ospf interface
show ip route ospf
```

#### Switch 2 OSPF Configuration

```bash
configure

router ospf 1
router-id 2.2.2.2
network 10.10.10.0/24 area 0
network 10.10.20.0/24 area 0
network 10.10.30.0/24 area 0
exit
exit

# Verify OSPF configuration
show ip ospf
show ip ospf neighbor
show ip route ospf
```

#### Switch 3 OSPF Configuration

```bash
configure

router ospf 1
router-id 3.3.3.3
network 10.10.10.0/24 area 0
network 10.10.20.0/24 area 0
network 10.10.30.0/24 area 0
exit
exit

# Verify OSPF configuration
show ip ospf
show ip ospf neighbor
show ip route ospf
```

### Step 7: Save Configuration

Execute on all switches:

```bash
# Save the running configuration to startup configuration
copy running-config startup-config

# Or use the write command
write memory
```

## Verification Commands

### Verify VLAN Configuration
```bash
show vlan
show vlan id 10
show vlan id 20
show vlan id 30
```

### Verify Interface Configuration
```bash
show ip interface
show ip interface vlan 10
show ip interface vlan 20
show ip interface vlan 30
show interfaces status
```

### Verify Trunk Ports
```bash
show interfaces switchport 0/23
show interfaces switchport 0/24
show interfaces trunk
```

### Verify Access Ports
```bash
show interfaces switchport 0/1
show vlan port 0/1
```

### Verify OSPF
```bash
show ip ospf
show ip ospf interface
show ip ospf neighbor
show ip route
show ip route ospf
```

### Verify Connectivity
```bash
# Ping between switch SVIs
ping 10.10.10.1
ping 10.10.10.2
ping 10.10.10.3
ping 10.10.20.1
ping 10.10.20.2
ping 10.10.20.3
```

## Using Ansible for Automation

### Step 1: Install Ansible

On your management workstation:

```bash
# For Ubuntu/Debian
sudo apt update
sudo apt install ansible -y

# For RHEL/CentOS
sudo yum install ansible -y

# For macOS
brew install ansible

# Verify installation
ansible --version
```

### Step 2: Install Required Ansible Collections

```bash
# Install network automation collections
ansible-galaxy collection install ansible.netcommon
ansible-galaxy collection install community.network

# Note: You may need to create a custom collection for Broadcom FASTPATH
# if it's not available in the standard collections
```

### Step 3: Configure Inventory File

The inventory file is located at `ansible/inventory.ini`. Update the IP addresses and credentials:

```ini
[broadcom_switches]
switch1 ansible_host=192.168.1.10
switch2 ansible_host=192.168.1.11
switch3 ansible_host=192.168.1.12

[broadcom_switches:vars]
ansible_network_os=broadcom_fastpath
ansible_connection=network_cli
ansible_user=admin
ansible_password=admin
ansible_become=yes
ansible_become_method=enable
```

### Step 4: Run the Ansible Playbook

Execute the playbook to configure all switches:

```bash
# Navigate to the ansible directory
cd ansible

# Run the complete playbook
ansible-playbook -i inventory.ini configure_switches.yml

# Run with verbose output for debugging
ansible-playbook -i inventory.ini configure_switches.yml -v

# Run specific tags only
# Configure only VLANs
ansible-playbook -i inventory.ini configure_switches.yml --tags vlan

# Configure only SVI interfaces
ansible-playbook -i inventory.ini configure_switches.yml --tags svi

# Configure only OSPF
ansible-playbook -i inventory.ini configure_switches.yml --tags ospf

# Configure only access ports
ansible-playbook -i inventory.ini configure_switches.yml --tags access_ports

# Configure only trunk ports
ansible-playbook -i inventory.ini configure_switches.yml --tags trunk_ports
```

### Step 5: Verify Ansible Deployment

```bash
# Check connectivity to all switches
ansible -i inventory.ini broadcom_switches -m ping

# Run verification commands on all switches
ansible -i inventory.ini broadcom_switches -m broadcom_fastpath_command -a "commands='show vlan'"
ansible -i inventory.ini broadcom_switches -m broadcom_fastpath_command -a "commands='show ip ospf neighbor'"
ansible -i inventory.ini broadcom_switches -m broadcom_fastpath_command -a "commands='show ip route'"
```

## Troubleshooting

### OSPF Neighbors Not Forming

1. Verify IP connectivity between switches:
   ```bash
   ping 10.10.10.1
   ping 10.10.10.2
   ping 10.10.10.3
   ```

2. Check OSPF interface configuration:
   ```bash
   show ip ospf interface
   ```

3. Verify OSPF network statements:
   ```bash
   show running-config router
   ```

4. Check for OSPF authentication mismatches

### VLANs Not Working Across Switches

1. Verify trunk configuration:
   ```bash
   show interfaces trunk
   show interfaces switchport 0/23
   ```

2. Ensure VLANs are allowed on trunk:
   ```bash
   show vlan
   ```

3. Check physical connectivity

### Access Ports Not Working

1. Verify port VLAN assignment:
   ```bash
   show interfaces switchport 0/1
   show vlan port 0/1
   ```

2. Check port status:
   ```bash
   show interfaces status
   ```

3. Verify VLAN exists:
   ```bash
   show vlan id 10
   ```

### Ansible Playbook Failures

1. Verify connectivity to switches:
   ```bash
   ansible -i inventory.ini broadcom_switches -m ping
   ```

2. Check credentials in inventory file

3. Verify Ansible version and collections:
   ```bash
   ansible --version
   ansible-galaxy collection list
   ```

4. Run with increased verbosity:
   ```bash
   ansible-playbook -i inventory.ini configure_switches.yml -vvv
   ```

## Security Best Practices

1. Change default credentials immediately
2. Use strong passwords for switch access
3. Implement SSH instead of Telnet for remote access
4. Configure access control lists (ACLs) for management access
5. Use VLAN 30 (Management VLAN) for administrative access only
6. Enable port security on access ports
7. Implement DHCP snooping for security
8. Use Ansible Vault for storing sensitive credentials:

   ```bash
   # Encrypt the inventory file
   ansible-vault encrypt ansible/inventory.ini
   
   # Run playbook with vault password
   ansible-playbook -i inventory.ini configure_switches.yml --ask-vault-pass
   ```

## Additional Configuration Options

### Enable Spanning Tree Protocol

```bash
configure
spanning-tree mode rstp
spanning-tree priority 4096  # For root bridge
exit
```

### Configure Port Security

```bash
configure
interface 0/1
switchport port-security
switchport port-security maximum 2
switchport port-security violation restrict
exit
exit
```

### Configure Management VLAN Access

```bash
configure
interface vlan 30
ip address 10.10.30.1 255.255.255.0
exit

# Enable SSH
ip ssh server
crypto key generate rsa modulus 2048
```

### Configure SNMP for Monitoring

```bash
configure
snmp-server community public ro
snmp-server location "Network Closet"
snmp-server contact "admin@example.com"
exit
```

## Maintenance and Monitoring

### Regular Monitoring Commands

```bash
# Monitor CPU and memory
show system

# Monitor interfaces
show interfaces status
show interfaces counters

# Monitor OSPF
show ip ospf neighbor
show ip route ospf

# Monitor VLANs
show vlan
show mac-address-table

# Check logs
show logging
```

### Backup Configuration

```bash
# Using TFTP
copy running-config tftp://192.168.1.100/switch1-config.txt

# Manual backup
show running-config > /tmp/switch1-backup.cfg
```

### Configuration Restoration

```bash
# Restore from TFTP
copy tftp://192.168.1.100/switch1-config.txt running-config

# Restore to startup config
copy tftp://192.168.1.100/switch1-config.txt startup-config
```

## Conclusion

This guide provides a comprehensive approach to configuring a Broadcom FASTPATH network with VLANs, Layer 3 routing, and OSPF. The combination of manual configuration steps and Ansible automation allows for both learning the underlying concepts and efficiently deploying configurations at scale.

For production deployments, always:
- Test configurations in a lab environment first
- Document all changes
- Maintain configuration backups
- Follow change management procedures
- Monitor network performance after changes

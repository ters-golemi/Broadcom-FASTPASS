#!/bin/bash
# Verification script for Broadcom FASTPATH network configuration
# This script helps verify that the network is configured correctly

echo "======================================"
echo "Broadcom FASTPATH Network Verification"
echo "======================================"
echo ""

# Function to run command on a switch via Ansible
run_switch_command() {
    local switch=$1
    local command=$2
    echo "Running on $switch: $command"
    ansible -i ansible/inventory.ini $switch -m broadcom_fastpath_command -a "commands='$command'" 2>/dev/null
}

# Function to print section header
print_section() {
    echo ""
    echo "======================================"
    echo "$1"
    echo "======================================"
}

# Check if we're in the right directory
if [ ! -f "ansible/inventory.ini" ]; then
    echo "Error: Please run this script from the repository root directory"
    exit 1
fi

# Test connectivity to all switches
print_section "Testing Connectivity to Switches"
ansible -i ansible/inventory.ini broadcom_switches -m ping

# Verify VLAN configuration
print_section "Verifying VLAN Configuration"
for switch in switch1 switch2 switch3; do
    echo ""
    echo "--- $switch VLANs ---"
    run_switch_command $switch "show vlan"
done

# Verify SVI interfaces
print_section "Verifying SVI Layer 3 Interfaces"
for switch in switch1 switch2 switch3; do
    echo ""
    echo "--- $switch IP Interfaces ---"
    run_switch_command $switch "show ip interface"
done

# Verify trunk ports
print_section "Verifying Trunk Ports"
for switch in switch1 switch2 switch3; do
    echo ""
    echo "--- $switch Trunk Ports ---"
    run_switch_command $switch "show interfaces trunk"
done

# Verify OSPF configuration
print_section "Verifying OSPF Configuration"
for switch in switch1 switch2 switch3; do
    echo ""
    echo "--- $switch OSPF Status ---"
    run_switch_command $switch "show ip ospf"
done

# Verify OSPF neighbors
print_section "Verifying OSPF Neighbors"
for switch in switch1 switch2 switch3; do
    echo ""
    echo "--- $switch OSPF Neighbors ---"
    run_switch_command $switch "show ip ospf neighbor"
done

# Verify routing table
print_section "Verifying Routing Tables"
for switch in switch1 switch2 switch3; do
    echo ""
    echo "--- $switch Routing Table ---"
    run_switch_command $switch "show ip route"
done

print_section "Verification Complete"
echo ""
echo "Review the output above to ensure:"
echo "1. All VLANs (10, 20, 30) are created on all switches"
echo "2. All SVI interfaces have correct IP addresses"
echo "3. Trunk ports 0/23 and 0/24 are in trunk mode"
echo "4. OSPF is running on all switches"
echo "5. Each switch sees 2 OSPF neighbors"
echo "6. Routing tables show OSPF routes"
echo ""

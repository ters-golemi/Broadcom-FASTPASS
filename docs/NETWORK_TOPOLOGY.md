# Network Topology Documentation

## Physical Network Topology

```
                    +-----------------+
                    |    Switch 1     |
                    |  Router ID:     |
                    |    1.1.1.1      |
                    |                 |
                    | VLAN 10: .1     |
                    | VLAN 20: .1     |
                    | VLAN 30: .1     |
                    +-----------------+
                      |0/23      |0/24
                      |          |
          +-----------+          +-----------+
          |                                  |
      0/23|                                  |0/24
    +-----+------+                    +------+-----+
    |  Switch 2  |                    |  Switch 3  |
    | Router ID: |       0/24    0/23 | Router ID: |
    |  2.2.2.2   +--------------------+  3.3.3.3   |
    |            |                    |            |
    | VLAN 10: .2|                    | VLAN 10: .3|
    | VLAN 20: .2|                    | VLAN 20: .3|
    | VLAN 30: .2|                    | VLAN 30: .3|
    +------------+                    +------------+
```

## Logical VLAN Topology

### VLAN 10 - Data VLAN (10.10.10.0/24)
```
Switch 1 (10.10.10.1)
  |
  +---- Ports 0/1, 0/2, 0/3 (Access)
  |
  +---- Trunk to Switch 2 and Switch 3

Switch 2 (10.10.10.2)
  |
  +---- Ports 0/1, 0/2, 0/3 (Access)
  |
  +---- Trunk to Switch 1 and Switch 3

Switch 3 (10.10.10.3)
  |
  +---- Ports 0/1, 0/2, 0/3 (Access)
  |
  +---- Trunk to Switch 1 and Switch 2
```

### VLAN 20 - Voice VLAN (10.10.20.0/24)
```
Switch 1 (10.10.20.1)
  |
  +---- Ports 0/4, 0/5, 0/6 (Access)
  |
  +---- Trunk to Switch 2 and Switch 3

Switch 2 (10.10.20.2)
  |
  +---- Ports 0/4, 0/5, 0/6 (Access)
  |
  +---- Trunk to Switch 1 and Switch 3

Switch 3 (10.10.20.3)
  |
  +---- Ports 0/4, 0/5, 0/6 (Access)
  |
  +---- Trunk to Switch 1 and Switch 2
```

### VLAN 30 - Management VLAN (10.10.30.0/24)
```
Switch 1 (10.10.30.1)
  |
  +---- Ports 0/7, 0/8 (Access)
  |
  +---- Trunk to Switch 2 and Switch 3

Switch 2 (10.10.30.2)
  |
  +---- Ports 0/7, 0/8 (Access)
  |
  +---- Trunk to Switch 1 and Switch 3

Switch 3 (10.10.30.3)
  |
  +---- Ports 0/7, 0/8 (Access)
  |
  +---- Trunk to Switch 1 and Switch 2
```

## OSPF Routing Topology

```
Area 0 (Backbone Area)
+--------------------------------------------------+
|                                                  |
|   Switch 1 (RID: 1.1.1.1)                       |
|     |                                            |
|     +-- Network 10.10.10.0/24                   |
|     +-- Network 10.10.20.0/24                   |
|     +-- Network 10.10.30.0/24                   |
|     |                                            |
|     +-- OSPF Neighbor: 2.2.2.2 (Switch 2)       |
|     +-- OSPF Neighbor: 3.3.3.3 (Switch 3)       |
|                                                  |
|   Switch 2 (RID: 2.2.2.2)                       |
|     |                                            |
|     +-- Network 10.10.10.0/24                   |
|     +-- Network 10.10.20.0/24                   |
|     +-- Network 10.10.30.0/24                   |
|     |                                            |
|     +-- OSPF Neighbor: 1.1.1.1 (Switch 1)       |
|     +-- OSPF Neighbor: 3.3.3.3 (Switch 3)       |
|                                                  |
|   Switch 3 (RID: 3.3.3.3)                       |
|     |                                            |
|     +-- Network 10.10.10.0/24                   |
|     +-- Network 10.10.20.0/24                   |
|     +-- Network 10.10.30.0/24                   |
|     |                                            |
|     +-- OSPF Neighbor: 1.1.1.1 (Switch 1)       |
|     +-- OSPF Neighbor: 2.2.2.2 (Switch 2)       |
|                                                  |
+--------------------------------------------------+
```

## Port Assignments

### Switch 1
| Port  | Mode   | VLAN | Purpose                      |
|-------|--------|------|------------------------------|
| 0/1   | Access | 10   | Data VLAN - End Device       |
| 0/2   | Access | 10   | Data VLAN - End Device       |
| 0/3   | Access | 10   | Data VLAN - End Device       |
| 0/4   | Access | 20   | Voice VLAN - End Device      |
| 0/5   | Access | 20   | Voice VLAN - End Device      |
| 0/6   | Access | 20   | Voice VLAN - End Device      |
| 0/7   | Access | 30   | Management VLAN - End Device |
| 0/8   | Access | 30   | Management VLAN - End Device |
| 0/23  | Trunk  | All  | Uplink to Switch 2           |
| 0/24  | Trunk  | All  | Uplink to Switch 3           |

### Switch 2
| Port  | Mode   | VLAN | Purpose                      |
|-------|--------|------|------------------------------|
| 0/1   | Access | 10   | Data VLAN - End Device       |
| 0/2   | Access | 10   | Data VLAN - End Device       |
| 0/3   | Access | 10   | Data VLAN - End Device       |
| 0/4   | Access | 20   | Voice VLAN - End Device      |
| 0/5   | Access | 20   | Voice VLAN - End Device      |
| 0/6   | Access | 20   | Voice VLAN - End Device      |
| 0/7   | Access | 30   | Management VLAN - End Device |
| 0/8   | Access | 30   | Management VLAN - End Device |
| 0/23  | Trunk  | All  | Uplink to Switch 1           |
| 0/24  | Trunk  | All  | Uplink to Switch 3           |

### Switch 3
| Port  | Mode   | VLAN | Purpose                      |
|-------|--------|------|------------------------------|
| 0/1   | Access | 10   | Data VLAN - End Device       |
| 0/2   | Access | 10   | Data VLAN - End Device       |
| 0/3   | Access | 10   | Data VLAN - End Device       |
| 0/4   | Access | 20   | Voice VLAN - End Device      |
| 0/5   | Access | 20   | Voice VLAN - End Device      |
| 0/6   | Access | 20   | Voice VLAN - End Device      |
| 0/7   | Access | 30   | Management VLAN - End Device |
| 0/8   | Access | 30   | Management VLAN - End Device |
| 0/23  | Trunk  | All  | Uplink to Switch 2           |
| 0/24  | Trunk  | All  | Uplink to Switch 1           |

## IP Addressing Scheme

### Switch 1
| Interface | IP Address    | Subnet Mask     | Description        |
|-----------|---------------|-----------------|--------------------|
| VLAN 10   | 10.10.10.1    | 255.255.255.0   | Data Gateway       |
| VLAN 20   | 10.10.20.1    | 255.255.255.0   | Voice Gateway      |
| VLAN 30   | 10.10.30.1    | 255.255.255.0   | Management Gateway |

### Switch 2
| Interface | IP Address    | Subnet Mask     | Description        |
|-----------|---------------|-----------------|--------------------|
| VLAN 10   | 10.10.10.2    | 255.255.255.0   | Data Gateway       |
| VLAN 20   | 10.10.20.2    | 255.255.255.0   | Voice Gateway      |
| VLAN 30   | 10.10.30.2    | 255.255.255.0   | Management Gateway |

### Switch 3
| Interface | IP Address    | Subnet Mask     | Description        |
|-----------|---------------|-----------------|--------------------|
| VLAN 10   | 10.10.10.3    | 255.255.255.0   | Data Gateway       |
| VLAN 20   | 10.10.20.3    | 255.255.255.0   | Voice Gateway      |
| VLAN 30   | 10.10.30.3    | 255.255.255.0   | Management Gateway |

## Trunk Link Details

### Physical Connections
- Switch 1 Port 0/23 <--> Switch 2 Port 0/23
- Switch 1 Port 0/24 <--> Switch 3 Port 0/24
- Switch 2 Port 0/24 <--> Switch 3 Port 0/23

### Trunk Configuration
- Mode: Trunk
- Allowed VLANs: 10, 20, 30
- Encapsulation: 802.1Q (default on FASTPATH)
- Native VLAN: 1 (default)

## OSPF Configuration Details

### Global Settings
- OSPF Process ID: 1
- OSPF Area: 0 (Backbone Area)
- OSPF Version: 2

### Router IDs
- Switch 1: 1.1.1.1
- Switch 2: 2.2.2.2
- Switch 3: 3.3.3.3

### Network Advertisements
All switches advertise:
- 10.10.10.0/24 (VLAN 10)
- 10.10.20.0/24 (VLAN 20)
- 10.10.30.0/24 (VLAN 30)

## Traffic Flow Examples

### Example 1: Device in VLAN 10 on Switch 1 to Device in VLAN 10 on Switch 2
1. Source sends frame to destination MAC
2. Frame travels through trunk port 0/23 from Switch 1
3. Frame arrives at Switch 2 trunk port 0/23
4. Switch 2 forwards frame out access port in VLAN 10

### Example 2: Device in VLAN 10 on Switch 1 to Device in VLAN 20 on Switch 2
1. Source sends packet to gateway (10.10.10.1)
2. Switch 1 routes packet to VLAN 20 network
3. OSPF determines best path
4. Packet routed within Switch 1 from VLAN 10 SVI to VLAN 20 SVI
5. Frame sent through trunk to Switch 2
6. Switch 2 forwards frame out access port in VLAN 20

### Example 3: Inter-Switch Layer 3 Routing
1. All switches learn routes via OSPF
2. Each switch maintains full routing table
3. Traffic can be routed at any switch layer 3 interface
4. OSPF provides redundancy and load balancing

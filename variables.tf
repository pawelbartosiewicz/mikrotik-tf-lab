# variable "bond_ports" {
#     type = list(string)
#     default = [""]
#     description = "Which ports will get added to bonding?"
# }

# login parameters

variable hosturl { type = string }
variable username { type = string }
variable password { type = string }
     



variable "whatport" {
    type = string
    default = "ether2"
    description = "what port is added to bond?"
}



variable interfacesInfo {
    type = map(object({
        mtu = number
        comment = string
    }))
    description = "Define interfaces info"
    default = {
        "ether1" = { mtu = 1500 , comment="Uplink to Proxmox" }
        "ether2" = { mtu = 1500 , comment="Access Port" }
        "ether3" = { mtu = 1500 , comment="Trunk Port to Switch" }
    }
}



variable defaultAccessVlan {
    type = number
    default = 1
    description = "Default access vlan on router"
}

# variable defaultTrunkVlans {
#     type = list(number)
#     # default = [10,20,30,40,99]
#     description = "Default trunk vlans on router"
# }


variable mgmtVlanID {
    type = number
    default = 99
    description = "Management VLAN ID"
}


variable accessPorts {
    type = list(string)
    description = "which ports are access from router"
}


variable vlansList {
    type = map(object({
        comment = string
        interface = string
        trunkInterfaces = list(string)
    }))
    description = "Define VLANs to create and trunking interface"
    default = {
        "10" = { comment="VLAN 10 - Default Access" , interface="bridge" , trunkInterfaces=["ether3", "ether2"] }
        "20" = { comment="VLAN 20 - Data VLAN" , interface="bridge", trunkInterfaces=["ether3", "ether2"] }

      }
    }


variable trunkPorts {
    type = map(object({
        vlan_ids = list(number)
        comment = string
    }))

    default = {

        "ether3" = { vlan_ids = [10,20,30] , comment="trunk to SWITCH" }
        "ether4" = { vlan_ids = [10,40,50] , comment="trunk to AP" }
    }
    description = "Define trunk ports and their allowed VLANs"
}


variable interfaceToVlanMap {
    type = map(object({
        vlan_id = number
        comment = string
    }))

    description = "Define what interfaces are assigned to which VLAN"

    # example - add for 10.9.10.0/24 and 10.9.20.0/24 subnets
    
    default = {
      "ether3" = { vlan_id = 1 , comment="Access Port for VLAN 10"  } 
      "ether4" = { vlan_id = 20 , comment="Access Port for VLAN 20" }
      }
    }


variable subnets {
    type = map(object({
        comment = string
        network = string
        network_with_subnet = string
        interface = string
        dhcp_range = list(string)
        gateway = string
    }))
    description = "Define what subnets to create on which interfaces"

    # example - add for 10.9.10.0/24 and 10.9.20.0/24 subnets
    default = {
      "10.9.10.1/24" = {
            comment = "VLAN 10 Subnet"
            network = "10.9.10.0"
            network_with_subnet = "10.9.10.0/24"
            interface = "vlan10"
            dhcp_range = ["10.9.10.100-10.9.10.254"]
            gateway = "10.9.10.1"
      }

      "10.9.20.1/24" = {
            comment = "VLAN 20 Subnet"
            network = "10.9.20.0"
            network_with_subnet = "10.9.20.0/24"
            interface = "vlan20"
            dhcp_range = ["10.9.20.100-10.9.20.254"]
            gateway = "10.9.20.1"
      }

    }
}

variable bridgeName {
    type = string
    default = "bridge"
    description = "Name of the bridge interface"
}

variable routerInterfaces {
    type = map(object({
        description = string
    }))
    description = "List of all interfaces on the router"
    default = {
        "ether1" = {description = "uplink 10.9.1.0/24 proxmox"}
    }
}


variable hostname {
    type = string
    description = "address:port to login"
}

variable username {
    type = string
    description = "username to login"
}

variable password {
    type = string
    description = "password to login"
}


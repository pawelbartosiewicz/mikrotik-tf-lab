resource "routeros_ip_address" "assign_subnets" {
  for_each = var.subnets
  address   = each.key
  interface = each.value.interface
  network = each.value.network
  comment = each.value.comment

  depends_on = [
    routeros_interface_vlan.create_svis
  ]
}




resource "routeros_interface_bridge" "create_br" {
    name = var.bridgeName
    vlan_filtering = true
    
}

resource "routeros_interface_vlan" "create_svis" {
  for_each = var.vlansList
  name = "vlan${each.key}"
  interface = each.value.interface
  vlan_id = each.key
  comment = each.value.comment

  depends_on = [ routeros_interface_bridge.create_br ]
}


resource "routeros_interface_bridge_vlan" "create_VLANS_on_bridge" {
  for_each = var.vlansList
  bridge = routeros_interface_bridge.create_br.name
  tagged = concat([routeros_interface_bridge.create_br.name], each.value.trunkInterfaces)
  comment = each.value.comment
  vlan_ids = [each.key]
}


resource "routeros_interface_bridge_port" "add_access_ports_to_br" {
    for_each = var.interfaceToVlanMap
    bridge = routeros_interface_bridge.create_br.name
    interface = each.key
    pvid = each.value.vlan_id
}
resource "routeros_ip_pool" "add_dhcp_pools" {
  for_each = var.subnets
  name = "pool_${each.value.interface}"
  ranges = each.value.dhcp_range
}





resource "routeros_ip_dhcp_server" "create_dhcp_server" {
  for_each = var.subnets
  address_pool = "pool_${each.value.interface}"
  interface    = each.value.interface
  name         = "dhcp_${each.value.interface}"


  depends_on = [ routeros_ip_pool.add_dhcp_pools, routeros_interface_vlan.create_svis]
}

#assign network parameters to dhcp server
resource "routeros_ip_dhcp_server_network" "dhcp_server_network" {
  for_each = var.subnets
  address    = each.value.network_with_subnet
  gateway    = each.value.gateway
  dns_server = ["1.1.1.1", "8.8.8.8"]

  depends_on = [ routeros_ip_dhcp_server.create_dhcp_server ]
}
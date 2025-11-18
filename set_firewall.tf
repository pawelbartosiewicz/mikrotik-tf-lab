# add masquerade for each access subnet
resource "routeros_ip_firewall_nat" "add_access_nat" {
  for_each = var.subnets
  action        = "masquerade"
  chain         = "srcnat"
  src_address   = each.value.network_with_subnet
  out_interface = "ether1" # assuming ether1 is the WAN interface
  comment = "Masquerade for ${each.value.network_with_subnet}"
}

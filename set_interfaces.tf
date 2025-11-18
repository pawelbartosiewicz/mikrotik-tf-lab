resource "routeros_interface_ethernet" "set_interfaces_parameters" {
  for_each = var.interfacesInfo
  factory_name = each.key
  name = each.key
  mtu = each.value.mtu
  comment = each.value.comment

}

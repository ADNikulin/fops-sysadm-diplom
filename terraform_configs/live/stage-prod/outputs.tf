output "external_ip_address_app" {
  value = yandex_alb_load_balancer.lb-fsd_netology.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "bastion_external_ips" {
  description = "Public IP address of load bastion."
  value       = module.bastion.external_ip_address_server
}

output "internal_instances_ips" {
  description = "Internal IP address of webservers."
  value = {
    webservers    = yandex_compute_instance_group.webservers.instances.*.network_interface.0.ip_address
    prometheus    = yandex_compute_instance.prometheus.network_interface.0.ip_address
    elasticsearch = yandex_compute_instance.elastic.network_interface.0.ip_address
    kibana        = yandex_compute_instance.kibana.network_interface.0.ip_address
    grafana       = yandex_compute_instance.grafana.network_interface.0.ip_address
  }
}

output "external_instances_ip" {
  description = "Internal IP address of webservers."
  value = {
    "bastion"       = module.bastion.external_ip_address_server
    "kibana"        = "http://${yandex_compute_instance.kibana.network_interface.0.nat_ip_address}:5601"
    "grafana"       = "http://${yandex_compute_instance.grafana.network_interface.0.nat_ip_address}:3000"
    "load_balancer" = "https://${yandex_alb_load_balancer.lb-fsd_netology.listener.0.endpoint.0.address.0.external_ipv4_address.0.address}"
  }
}

output "pg_cluster_id" {
  value = yandex_mdb_postgresql_cluster.postgres.id
}

resource "local_file" "tf_ansible_vars_file" {
  content  = <<-DOC
    webserver_node_1: ${yandex_compute_instance_group.webservers.instances.0.name}
    webserver_node_2: ${yandex_compute_instance_group.webservers.instances.1.name}
    webserver_node_3: ${yandex_compute_instance_group.webservers.instances.2.name}
    ansible_workdir: ${var.ansible_workdir}
    telegram_chat_id: "${var.telegram_chat_id}"
    pg_cluster_id: ${yandex_mdb_postgresql_cluster.postgres.id}
    kibana_host: "${yandex_compute_instance.kibana.fqdn}"
    grafana_host: "${yandex_compute_instance.grafana.fqdn}"
    elastic_host: "${yandex_compute_instance.elastic.fqdn}"
    prometheus_host: "${yandex_compute_instance.prometheus.fqdn}"
    DOC
  filename = "../../../ansible_configs/vars/terraform_vars.yml"
}

resource "local_file" "tf_ansible_vars_secrets_file" {
  content  = <<-DOC
    kibana_password: ${var.kibana_password}
    telegram_bot_token: "${var.telegram_bot_token}"
    pg_admin_password: ${var.pg_admin_password}
    DOC
  filename = "../../../ansible_configs/vars/secrets_vars.yml"
}


resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl",
    {
      bastion = tomap({
        "ip"       = module.bastion.external_ip_address_server,
        "hostname" = module.bastion.hostname
        "fqdn"     = module.bastion.fqdn
      })
      webservers = [for instance in yandex_compute_instance_group.webservers.instances.* : tomap({
        "ip"       = instance.fqdn
        "hostname" = instance.name
        "fqdn"     = instance.fqdn,
      })]
      prometheus = tomap({
        "ip"       = yandex_compute_instance.prometheus.network_interface.0.ip_address,
        "hostname" = yandex_compute_instance.prometheus.hostname
        "fqdn"     = yandex_compute_instance.prometheus.fqdn,
      })
      grafana = tomap({
        "ip"       = yandex_compute_instance.grafana.network_interface.0.ip_address,
        "hostname" = yandex_compute_instance.grafana.hostname
        "fqdn"     = yandex_compute_instance.grafana.fqdn,
      })
      elastic = tomap({
        "ip"       = yandex_compute_instance.elastic.network_interface.0.ip_address,
        "hostname" = yandex_compute_instance.elastic.hostname
        "fqdn"     = yandex_compute_instance.elastic.fqdn,
      })
      kibana = tomap({
        "ip"       = yandex_compute_instance.kibana.network_interface.0.ip_address,
        "hostname" = yandex_compute_instance.kibana.hostname
        "fqdn"     = yandex_compute_instance.kibana.fqdn,
      })
    }
  )
  filename = "../../../ansible_configs/inventory.yaml"
}

resource "docker_network" "bgg-net" {
    name = "bgg-net"
}

resource "docker_volume" "shared_volume" {
  name = "shared_volume"
}

resource "docker_image" "bgg-database" {
  name  = "chukmunnlee/bgg-database:${var.database_version}"
}

resource "docker_image" "bgg-backend" {
  name  = "chukmunnlee/bgg-backend:${var.backend_version}"
}

resource "docker_container" "bgg-database" {
    name = "bgg-database"
    image = docker_image.bgg-database.image_id
    ports {
        internal = 3306
        external = 3306
    }
    networks_advanced{
        name = docker_network.bgg-net.id
    }
    volumes {
        volume_name  = docker_volume.shared_volume.name
        container_path = "/var/lib/mysql"
    }
}

resource "docker_container" "bgg-backend" {
    count = var.backend_instance_count
    name = "bgg-backend-${count.index}"
    image = docker_image.bgg-backend.image_id
    ports {
        internal = 3000
    }
    env = [
        "BGG_DB_USER=root",
        "BGG_DB_PASSWORD=changeit",
        "BGG_DB_HOST=${docker_container.bgg-database.name}"
    ]
    networks_advanced {
        name = docker_network.bgg-net.id
    }
}

data "digitalocean_ssh_key" "ssh_key" {
    name = var.do_ssh_key
}

# Create a new Web Droplet in the sgp1 region
resource "digitalocean_droplet" "nginx-droplet" {
    name = "nginx-droplet"
    image  = var.droplet_image
    region = var.droplet_region
    size   = var.droplet_size

    ssh_keys = [ data.digitalocean_ssh_key.ssh_key.id ]
    connection {
        type = "ssh"
        user = "root"
        private_key = file(var.digitalocean_private_key)
        host = self.ipv4_address
    }

    provisioner "remote-exec" {
        inline = [
            "apt update -y",
            "apt upgrade -y",
            "apt install nginx -y",
        ]
    }

    provisioner "file" {
        source = local_file.nginx-conf.filename
        destination = "/etc/nginx/nginx.conf"
    }

    provisioner "remote-exec" {
        inline = [
            "systemctl restart nginx",
            "systemctl enable nginx",
        ]
    }
}

resource "local_file" "root_at_nginx" {
    filename = "root${digitalocean_droplet.nginx-droplet.ipv4_address}"
    content = ""
    file_permission = "0444"
}


resource "local_file" "nginx-conf" {
    filename = "nginx.conf"
    content = templatefile (
        "sample.nginx.conf.tftpl", {
            docker_host = "68.183.228.103",
            ports = docker_container.bgg-backend[*].ports[0].external
            })
}

output droplet_ipv4 {
    value = digitalocean_droplet.nginx-droplet.ipv4_address
}

output backend_ports {
    value = docker_container.bgg-backend[*].ports[0].external
}
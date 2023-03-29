# images
data "digitalocean_ssh_key" "ssh_key" {
    name = var.do_ssh_key
}

data "digitalocean_image" "mynginx" {
    name = "mynginx"
}

resource "digitalocean_droplet" "mynginx" {
    name = "mynginx"
    image = data.digitalocean_image.mynginx.id
    region = var.droplet_region
    size = var.droplet_size

    ssh_keys = [ data.digitalocean_droplet.ssh_key.id ]
}

output nginx_ip {
    value = digitalocean_droplet.mynginx.ipv4_address
}
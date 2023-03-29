resource "digitalocean_ssh_key" "ssh_key" {
    name = "ssh_key"
    public_key = file(var.digitalocean_pub_key)
}

resource "digitalocean_droplet" "workshop02-droplet" {
    name = "workshop02-droplet"
    image  = var.droplet_image
    region = var.droplet_region
    size   = var.droplet_size

    ssh_keys = [ digitalocean_ssh_key.ssh_key.fingerprint ]
}

resource "local_file" "root_at_codeserver" {
    filename = "root@${digitalocean_droplet.workshop02-droplet.ipv4_address}"
    content = ""
    file_permission = "0444"
}

resource "local_file" "ansible-inventory" {
    filename = "inventory.yaml"
    content = templatefile("inventory.yaml.tftpl", {
        digitalocean_private_key = var.digitalocean_private_key,
        ansible_host = digitalocean_droplet.workshop02-droplet.ipv4_address,
        codeserver_name = "code-server",
        codeserver_domain = "jingsen-domain",
        codeserver_password = "111111",
    })
    file_permission = "0444"
}
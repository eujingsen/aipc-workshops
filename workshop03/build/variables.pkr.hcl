variable droplet_region {
    type = string
    default = "sgp1"
}

variable droplet_image {
    type = string 
    default = "ubuntu-20-04-x64"
}

variable droplet_size {
    type = string
    default = "s-1vcpu-2gb"
}

variable do_token {
    type = string
    sensitive = true
}

variable do_ssh_key {
    type = string
    default = "Key1"
}

variable digitalocean_ssh_fingerprint {
    type = string
}

variable digitalocean_pub_key {
    type = string
}

variable digitalocean_private_key {
    type = string
}

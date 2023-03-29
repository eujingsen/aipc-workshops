variable backend_instance_count {
    type = number
    default = 3
}

variable backend_version {
    type = string
    default = "v3"
}

variable database_version {
    type = string
    default = "v3.1"
}

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

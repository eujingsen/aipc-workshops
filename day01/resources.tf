# pull the image
# docker pull image
resource "docker_image" "dov-bear" {
    name = "chukmunnlee/dov-bear:v4"
}

# run the container
# docker run -d -p 8080:3000 <image>
resource "docker_container" "dov-bear" {
    name = "my-dov-bear"
    image = docker_image.dov-bear.image_id
    ports {
        internal = 3000
        external = 3000
    }
    env = [
        "INSTANCE_NAME=my-dov-bear",
    ]
}

output "dov_ports" {
    #value = docker_container.dov-bear[*].ports[0].external
    #value = [
    #    for d in docker_container.dov-bear: [
    #        for p in d.ports: p
    #    ]
    #]
}

#data "digitalocean_ssh_key" "aipc" {
#    name = "Key1"
#}

#output aipc_fingerprint {
#    description = "AIPC fingerprint"
#    value = data.digitalocean_ssh_key.aipc.fingerprint
#}

#output aipc_public_key {
#    description = "AIPC public key"
#    value = data.digitalocean_ssh_key.aipc.public_key
#}
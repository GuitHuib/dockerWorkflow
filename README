# Docker image creation
- checkout repo
- set up java
- build jar file
- login to docker hub
- setup qemu
- setup buildx
- build and push to docker hub
- after workflow runs, verify that the new image is in your dockerhub repository

# Docker image deployment to existing ec2 instance
- create new ec2 instance, noting public IPv4 address
- create key pair, downloading .pem file
- add deploy job to workflow that will ssh into server
    - needs ec2 host(ip address), ec2 username(dec2-user for linux), ssh key from github secrets(.pem file or other token)
    - after ssh-ing in, run scripts to:
        - install and start docker
        - make any needed permission changes
        - pull and run container, ensuring not to start duplicates of already running containers

 # Terraform
 - use existing key pair, or create a new key pair in AWS, download .pem file
 - set up aws cli locally with access key and secret access key set
 - update `key_name` at line 63 to the name of your key
 - update paths to .pem file at lines 55 and 70
 - ensure path and filename for ansible playbook is correct at line 61

 #Ansible
 - ensure dockerhub username is correct at lines 24 and 27, i.e. `docker pull <username>/<application name>:latest`

 #Workflow to run terraform
 - add secrets to github
 - change paths to .pem file to reference github secrets
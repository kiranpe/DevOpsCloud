#DevOps AWS
------------------------------------------------------------------------------------------------
| Tools:                                                                                       |
| ------                                                                                       |
|                                                                                              |
| Cloud: AWS,    Cloud--Orchestration: Terraform                                               |
|                                                                                              |
| Container: Docker,   Container-Orchestration: Kubernetes,  Infra-Configuration: Ansible           |
|                                                                                              |
| Source Code Repo: GIT,  CI: Jenkins,   Build Tool: Maven,   Maven-Repo: Nexus3               |
|                                                                                              |
| Coding: HTML + CSS,   Scripting: Shell Script                                                |
------------------------------------------------------------------------------------------------

#README Files are Very Very Imp.. Just follow them when you have any difficulty while setting up the Env
----------------------------------------------------------------------------------------------------------

Manual Set Up (Jenkins + Docker + Ansible):
--------------------------------------------
You need Three instances.. One for Master Node, One for Worker Node and One for Jenkins server

Choose t2.medium Ubuntu Instances for K8S, nexus and t2.micro for jenkins..

Lanch jenkins instance and install java and maven and jenkins..

Launch nexus instace and install docker and run the nexus image..

For Master and workernode instances follow kuberenetes-master-worker file to set up K8S after lanching ubuntu instances.. File is in Ansible/Ansible-K8S/readmefiles/ folder

Follow security group instructions..

Install ansible in all instances..

Create RSA key for Ansible ssh..

Set up jenkins build with git repo and add below lines to execute shell commands

https://github.com/kiranpe/maven-project.git

Add maven build step with "clean deploy"

Add below commands to jenkins execute shell in build steps

#Checking Docker image Quality before deploying to k8s

ansible-playbook docker-image.yaml

#Deploying image on K8S

cd "$WORKSPACE"/ymlfiles/

#push rsa key to master node

ansible-playbook push_rsa_key.yaml -i hosts --private-key /sites/keyfile.pem

#Deploy image

ansible-playbook webapp.yaml -i hosts

Access url: http://public_ip:nodeport/webapp/login.html

Note: you can get Nodeport from jenkins build or from K8S dashboard. 

Jenkins and K8S Automation using Ansible:
------------------------------------------

Uisng Ansible, automated manual installation.. local setup using ansible files are available in localhost-setup(our system).. remote host set up files are available in Ansible folder.. First understand manual set up and then go for automation using Ansible.. Follow Readme files..

Complete Automation using Terraform:
-------------------------------------
Automated everything from creation of EC2 instance to installing Ansible and installing Java, Jenkins, Maven, Nexus3, Docker and K8S installation using Ansible after instance creation.. Manual interaction is very minimal.. Files are available under K8S-Terraform folder.. Follow Readme files.. 

All in one go:
--------------
First set up your localhost using install-terraform-awscli.yaml.. file is in localhost-setup folder..

Use install-all.tf file to set up remote hosts and tools using terraform.. file is in "AllInOneFile" folder..

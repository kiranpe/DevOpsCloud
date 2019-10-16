#Devops Project
------------------------------------------------------------------------------------------------
| Tools:                                                                                       |
| ------                                                                                       |
|                                                                                              |
| Cloud: AWS,    Cloud--Orchestration: Terraform                                               |
|                                                                                              |
| Container: Docker,   Container-Orchestration: Kubernetes,  Env-Automation: Ansible           |
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

Choose t2.medium Ubuntu Instances for K8S set up and jenkins nexus set up..

Create Jenkins instance manually..

Launch master and workernode instances and follow kuberenetes-master-worker file to set up K8S after lanching ubuntu instances.. File is in Ansible/Ansible-K8S/readmefiles/ folder

Follow security group instructions 

Create RSA key for Ansible ssh

Set up jenkins build with git repo and add below lines to execute shell commands

#create image and testing it out if image is fine or not

sh "$WORKSPACE"/Docker-Image/dockerscript.sh

#deploying casestudy image and doing healthcheck

cd "$WORKSPACE"/Docker-Image/ymlfiles

ansible-playbook casestudy.yaml -i hosts

application access

http://<target_ip>:<nodeport>/casestudy/login.html

Note: you can get Nodeport from jenkins build or from K8S dashboard. 

Jenkins and K8S Automation using Ansible:
------------------------------------------

Uisng Ansible, automated manual installation.. set up files are available in Ansible folder.. First understand manual set up and then go for automation using Ansible.. Follow Readme files..

Complete Automation using Terraform:
-------------------------------------
Automated everything from creation of EC2 instance to installing Ansible and installing Java, Jenkins, Maven, Nexus3, Docker and K8S installation using Ansible after instance creation.. Manual interaction is very minimal.. Files are available under K8S-Terraform folder.. Follow Readme files..

Upcoming:
-----------

#Planning to use Prometheus K8S monitoring tool

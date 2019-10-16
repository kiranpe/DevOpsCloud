#Ansible
-----------

This folder has K8S master and worker set up guide using Ansible..

Use yaml files to install K8S.. FIrst always set up master node.

Launch two ec2 instances first..

Login in to masternode box and install ansible first:

sudo apt-get update

sudo apt-get install ansible -y

Create RSA Key in local

ssh-keygen -t rsa

Now push it to nodes using pem file

ansible-playbook push_rsa_key.yaml -i hosts --private-key /your pem file/

Then download yml and host files to local.. update hosts file with your IP's and key file and run yml files from local like below

ex:

ansible-playbook k8s-master-node-installation.yml -i hosts

Automated k8s WORKER Node set up using ansible.. File is available under K8SSetup folder.. 

Login in to workernode box and install ansible first:

sudo apt-get update

sudo apt-get install ansible -y

Then download yml and host files to local.. update hosts file with your IP's and run yml files from local

ex:

ansible-playbook k8s-worker-node-installation.yml -i hosts

Once everything is done follow dashboard-setup file under K8SSetup for setting up k8s dashboard.

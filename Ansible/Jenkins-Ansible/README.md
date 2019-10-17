Jenkins Set up:
----------------

Befor starting with Jenkins set up.. create rsa key in LOCAL..

cd /home/ubuntu/.ssh

ssh-keygen -t rsa (No password)

Now Set up Jenkins Instance using Terraform

Clone repo to your local https://github.com/kiranpe/DevOpsCloud.git 

Go to Jenkins-Ansible folder and follow below to set up jenkins instance

Download Required java jdk(jdk-xxx-linux-x64.tar.gz) and apache maven(apache-maven-x.x.x-bin.tar.gz) tar files and keep them inside this folder

Launch ec2 instance and update host value in java and jenkins files in hostfiles folder

add below line to sudoers

jenkins  ALL=(ALL)  NOPASSWD: ALL

Test connection from local

ssh ubuntu@publicip

Manual Tasks on Jenkins: (Don't Forget this before setting up build)
--------------------------------------------------------------------
For now only Manual tasks in Jenkins is configuring Rsa key, aws credentials and Docker login (Security purpose.. Always manual)

Login to Jenkins box and do below

Set up rsa key to ssh to K8S instances

sudo su - jenkins (do it as jenkins user.. )

ssh-keygen -t rsa

don't use any passwords(better to go with open) 

aws configure

sudo docker login

Both will ask for login deatials and enter them and then set up below kubernetes


--------------------------------------------------------------------------------------
Adding Jenkins user to root and rsa key creation was Automated with ansible.. still if you want to add it manually follow below process and remove ansible task from install java and jenkins yaml file.. Below is just for knowledge 

sudo visudo

jenkins  ALL=(ALL)  NOPASSWD: ALL

Create rsa key:(you can use your pem file but you can do in this as well)

ssh-keygen -t rsa

copy iy to remote server using .pem file

cat .ssh/id_rsa.pub | ssh ubuntu@publicip -i yourkey.pem 'cat >> .ssh/authorized_keys'

Use id_rsa key to login to servers

ssh ubuntu@public ip

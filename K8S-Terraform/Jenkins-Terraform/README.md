Jenkins Set up:
----------------

Befor starting with Jenkins set up.. create rsa key in LOCAL  

cd /home/ubuntu/.ssh

ssh-keygen -t rsa (It's not required when you are setting up K8S from local using terraform.. this is for jenkins build)

don't use any passwords(better to go with open)

Now Set up Jenkins Instance using Terraform

Clone repo to your local https://github.com/kiranpe/DevOpsCloud.git 

Go to Jenkins-Terraform folder and run below to set up jenkins instance

Download Required java jdk(jdk-xxx-linux-x64.tar.gz) and apache maven(apache-maven-x.x.x-bin.tar.gz) tar files and keep them inside this folder

terraform init 

terraform plan 

Once your plan shows up cleanly then go a head and run apply otherwise fix the issue.

terraform apply or terraform apply -auto-approve

terraform destroy --> to terminate instace

This will create ec2 and install java, jenkins , Terraform and awscli and Adds the below line to sudoers file.

jenkins  ALL=(ALL)  NOPASSWD: ALL

Test connection from local

ssh ubuntu@public ip

Manual Tasks on Jenkins: (Don't Forget this before setting up build)
--------------------------------------------------------------------
For now only Manual tasks in Jenkins is configuring Rsa key, aws credentials and Docker login (Security purpose.. Always manual)

Login to Jenkins box and do below

Automated this part.. go to next steps
----------------------------------------------
Set up rsa key to ssh to K8S instances

sudo su - jenkins (do it as jenkins user.. )

ssh-keygen -t rsa

don't use any passwords(better to go with open) 

-----------------------------------------------------------

aws configure (Required when doing k8s set up using jenkins)

sudo docker login

Both will ask for login deatials and enter them

update .m2/settings.xml with your nexus logins...


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


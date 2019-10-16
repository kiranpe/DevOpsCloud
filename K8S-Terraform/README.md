#Terraform
------------
Below is the Set up For Single node Architecture..

Do the terraform set up.. follow my notes terraform_setup..

First Set up Jenkins instance using Jenkins-Terraform files..

Before setting up instance login to you AWS console and create keypair and security group.. update their names in .tf files

#Setting up K8S Cluster(Using Jenkins.. We can run below manually also)
---------------------------------------------------------------------------------------

Clone the git repo

cd "$WORKSPACE"/K8S-Terraform/SingleNode-K8S-Terraform/

terraform init

sleep 5

terraform plan

sleep 5

terraform apply -auto-approve

sleep 5

Copy SingleNode-K8S-Terraform/hostfiles/workerhost file to SingleNode-K8S-Terraform/ymlfiles/hosts (In Real Time We just need to update one time.. we don't stop instances regularly so ip's will be same)

Jenkins Build For K8S Set up and Docker Image deploy on K8S:(Not Maven.. Just HTML) 
------------------------------------------------------------------------------------

Set up Jenkins build with below Repo

Repo: https://github.com/kiranpe/DevOpsCloud.git

And add below in Build --> Execute Shell

#Checking Docker image Quality before deploying to k8s

cd "$WORKSPACE/Docker-Image"

ansible-playbook docker-image.yaml

#Deploying image on K8S

cd "$WORKSPACE"/K8S-Terraform/SingleNode-K8S-Terraform/ymlfiles/

#push rsa key to master node

ansible-playbook push_rsa_key.yaml -i hosts --private-key /sites/keyfile.pem

#Deploy image

ansible-playbook casestudy.yaml -i hosts

----------------------------------------------------------------------------------------
k8s-terraform.tf file will lanuch your ec2 instances and will install ansible and k8s and copy the rsa key to ssh. 

docker script will create image and checks the status and push to docker hub

casestudy.yaml will do the deployment on k8s cluster

--------------------------------------------------------------------------------------------------

Now use rsa key to login to K8S cluster from Jenkins server

ssh ubuntu@masternodeip

ssh ubuntu@workerNodeip

Once everything is done follow dashboard-setup file under K8SSetup for setting up k8s dashboard.

MultiNode set up:
---------------------
Creating multiple worker nodes in one go and joining them with master.

Set up is similar to Single node cluster set up.. Run the tf file and update host file in Git..

-------------------------------------------------------------------------------------------------------------
Maven Project:
---------------
Follow Readme file of below repo

https://github.com/kiranpe/maven-project.git

This will deploy webapp application on K8S cluster and will upload your snapshot or release version to your nexus

----------------------------------------------------------------------

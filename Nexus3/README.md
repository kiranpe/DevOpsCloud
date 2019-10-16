#Nexus3 Set up:
------------------
This folder contains terraform files and nexus-repo.yaml.. 

.tf file will create the instance and yaml file do the nexus installation..

settings.xml:
---------------
Create deployment user in nexus or else use your nexus logins in settings.xml..

Login in to Jenkins server..

sudo as jenkins user..

sudo su - jenkins

update in .m2/settings.xml..

and updated pom.xml distribution management.. please check pom.xml of maven-project repo

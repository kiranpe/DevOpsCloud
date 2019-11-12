This Folder is not for begginers.. 

This folder contains .tf and yaml files to install all the tools in one go..

This tf file is not like other files.. you need to pass your docker hub username and password in install-all.tf(hub_username and hub_password) file so that it will complete your docker installation process.

once you pass the values and run the terrafor apply, watch the screen carefully.. if incase it breaks then run terraform plan again and then run apply command again.. your manual work is just zero.

After servers installation is complete, set up pipeline build by following the maven-project README.md file..

Creating Maven security file..

mvn -emp yourmasterpassword --> generates master encrypted password and update in settings-security.xml

mvn -ep yourdeploymentuserpassword --> generates deployment user encryoted password and update it in settings.xml

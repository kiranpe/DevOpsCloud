This yaml file is to set up terraform and docker in your local system.

How to run playbook:
-------------------------
ansible-playbook install-terraform-awscli.yaml --extra-vars "ansible_sudo_pass=yourPassword ansible_python_interpreter=/usr/bin/python3"

This yaml file is to install awscli and configure credentials in local system

configuring aws:
-------------------
ansible-playbook awscli-configure.yaml --extra-vars "ansible_sudo_pass=Chinni.23 ansible_python_interpreter=/usr/bin/python3"

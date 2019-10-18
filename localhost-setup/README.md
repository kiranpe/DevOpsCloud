Installation terraform and docker:

How to run playbook:
-------------------------
ansible-playbook install-terraform-docker.yaml --extra-vars "ansible_sudo_pass=yourPassword ansible_python_interpreter=/usr/bin/python3"

-------------------------------------------------------------------------------

Install awscli:

configuring aws:
-------------------
ansible-playbook awscli-configure.yaml --extra-vars "ansible_sudo_pass=yourPassword ansible_python_interpreter=/usr/bin/python3"

provider "aws" {
  region = "us-east-2"
}

variable "private_key" {
  default = "/sites/keyfile.pem"
}

variable "ansible_user" {
  default = "ubuntu"
}

resource "aws_instance" "jenkins" {
  ami           = "ami-05c1fa8df71875112"
  instance_type = "t2.micro"

  security_groups = ["k8scluster"]
  key_name        = "k8skey"

  connection {
    user        = "${var.ansible_user}"
    private_key = "${file(var.private_key)}"
    host        = "${aws_instance.jenkins.public_ip}"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update && sleep 15 && sudo apt-get install -f ansible -y && sudo hostnamectl set-hostname jenkins"]
  }

  # This is where we configure the instance with ansible-playbook
  # Jenkins requires Java to be installed 
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
	  >hostfiles/java;
	  echo "[java]" | tee -a hostfiles/java;
	  echo "${aws_instance.jenkins.public_ip} ansible_user=${var.ansible_user} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a hostfiles/java;
	  ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/java jenkins/install-java-mvn.yaml
    EOT
  }

  # This is where we configure the instance with ansible-playbook
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      >hostfiles/jenkins;
      echo "[jenkinsci]" | tee -a hostfiles/jenkins;
      echo "${aws_instance.jenkins.public_ip} ansible_user=${var.ansible_user} ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_python_interpreter=/usr/bin/python3" | tee -a hostfiles/jenkins;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/jenkins jenkins/install-jenkins-docker.yaml -e "hub_username=DockerHubUName hub_password=DockerHubPswrd"
    EOT
  }

  root_block_device {
    volume_size = "8"
  }

  tags = {
    Name = "jenkins-instance"
  }
}

resource "aws_instance" "nexus" {
  ami           = "ami-05c1fa8df71875112"
  instance_type = "t2.medium"

  security_groups = ["k8scluster"]
  key_name        = "k8skey"

  connection {
    user        = "${var.ansible_user}"
    private_key = "${file(var.private_key)}"
    host        = "${aws_instance.nexus.public_ip}"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update && sleep 15 && sudo apt-get install -f ansible -y && sudo hostnamectl set-hostname nexus"]
  }

  # This is where we configure the instance with ansible-playbook
  # Jenkins requires Java to be installed
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
          >hostfiles/nexus;
          echo "[nexus]" | tee -a hostfiles/nexus;
          echo "${aws_instance.nexus.public_ip} ansible_user=${var.ansible_user} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a hostfiles/nexus;
          ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/nexus nexus/nexus-repo.yaml
    EOT
  }

  root_block_device {
    volume_size = "10"
  }

  tags = {
    Name = "nexus-instance"
  }
  depends_on = ["aws_instance.jenkins"]
}

resource "aws_instance" "k8smaster" {
  ami           = "ami-05c1fa8df71875112"
  instance_type = "t2.medium"

  security_groups = ["k8scluster"]
  key_name        = "k8skey"

  connection {
    user        = "${var.ansible_user}"
    private_key = "${file(var.private_key)}"
    host        = "${aws_instance.k8smaster.public_ip}"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update && sleep 15 && sudo apt-get install -f ansible -y && sudo hostnamectl set-hostname master-node"]
  }

  # This is where we configure the instance with ansible-playbook
  # install K8S on master node
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      >hostfiles/masterhost;
      echo "[k8smaster]" | tee -a hostfiles/masterhost;
      echo "${aws_instance.k8smaster.public_ip} ansible_user=${var.ansible_user} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a hostfiles/masterhost;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/masterhost K8S/k8s-master-node-installation.yaml
    EOT
  }

  tags = {
    Name = "k8smaster-node"
  }
  depends_on = ["aws_instance.nexus"]
}

resource "aws_instance" "k8sworkernode" {
  ami           = "ami-05c1fa8df71875112"
  instance_type = "t2.medium"

  security_groups = ["k8scluster"]
  key_name        = "k8skey"

  connection {
    user        = "${var.ansible_user}"
    private_key = "${file(var.private_key)}"
    host        = "${aws_instance.k8sworkernode.public_ip}"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update && sleep 15 && sudo apt-get install -f ansible -y && sudo hostnamectl set-hostname worker-node"]
  }

  # This is where we configure the instance with ansible-playbook
  # install K8S on worker node
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      >hostfiles/workerhost;
      echo "[k8sworker]" | tee -a hostfiles/workerhost;
      echo "${aws_instance.k8sworkernode.public_ip} ansible_user=${var.ansible_user} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a hostfiles/workerhost;
      cat hostfiles/masterhost | tee -a hostfiles/workerhost;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/workerhost K8S/k8s-worker-node-installation.yaml
    EOT
  }

  tags = {
    Name = "k8sworker-node"
  }

  depends_on = ["aws_instance.k8smaster"]
}

output "jenkins-url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "nexus-repo" {
  value = "http://${aws_instance.nexus.public_ip}:8081"
}

output "ec2_masternode_publicip" {
  value = "${aws_instance.k8smaster.public_ip}"
}

output "ec2_workernode_publicip" {
  value = "${aws_instance.k8sworkernode.public_ip}"
}

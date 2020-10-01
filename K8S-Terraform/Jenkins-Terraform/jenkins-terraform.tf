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
	  ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/java install-java-mvn.yaml
    EOT
  }

  # This is where we configure the instance with ansible-playbook
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      >hostfiles/jenkins;
      echo "[jenkinsci]" | tee -a hostfiles/jenkins;
      echo "${aws_instance.jenkins.public_ip} ansible_user=${var.ansible_user} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a hostfiles/jenkins;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/jenkins install-jenkins.yaml
    EOT
  }

  root_block_device {
    volume_size = "15"
  }

  tags = {
    Name = "jenkins-instance"
  }
}

output "ec2_publicip" {
  value = "${aws_instance.jenkins.public_ip}"
}

output "jenkins-url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}

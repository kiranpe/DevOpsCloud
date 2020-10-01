provider "aws" {
  region = "us-east-2"
}

variable "private_key" {
  default = "/sites/keyfile.pem"
}

variable "ansible_user" {
  default = "ubuntu"
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
	  ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/nexus nexus-repo.yaml
    EOT
  }

  root_block_device {
    volume_size = "10"
  }

  tags = {
    Name = "nexus-instance"
  }
}

output "ec2_publicip" {
  value = "${aws_instance.nexus.public_ip}"
}

output "nexus-repo" {
  value = "http://${aws_instance.nexus.public_ip}:8081"
}

provider "aws" {
  region = "us-east-2"
}

variable "private_key" {
  default = "/home/ubuntu/keyfile.pem"
}

variable "ansible_user" {
  default = "ubuntu"
}

resource "aws_instance" "masternode" {
  ami           = "ami-05c1fa8df71875112"
  instance_type = "t2.medium"

  security_groups = ["k8scluster"]
  key_name        = "k8skey"

  connection {
    user        = "${var.ansible_user}"
    private_key = "${file(var.private_key)}"
    host        = "${aws_instance.masternode.public_ip}"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update && sleep 15 && sudo apt-get install -f ansible -y && sudo hostnamectl set-hostname master-node"]
  }

  # This is where we configure the instance with ansible-playbook
  # install K8S on master node
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      >masterhost;
      echo "[k8smaster]" | tee -a masterhost;
      echo "${aws_instance.masternode.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.private_key} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a masterhost;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i masterhost k8s-master-node-installation.yaml
    EOT
  }

  tags = {
    Name = "master-node"
  }
}

output "ec2_masternode_publicip" {
  value = "${aws_instance.masternode.public_ip}"
}

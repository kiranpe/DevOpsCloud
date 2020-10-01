provider "aws" {
  region = "us-east-2"
}

variable "private_key" {
  default = "/home/ubuntu/keyfile.pem"
}

variable "ansible_user" {
  default = "ubuntu"
}

resource "aws_instance" "workernode" {
  ami           = "ami-05c1fa8df71875112"
  instance_type = "t2.medium"

  security_groups = ["k8scluster"]
  key_name        = "k8skey"

  connection {
    user        = "${var.ansible_user}"
    private_key = "${file(var.private_key)}"
    host        = "${aws_instance.workernode.public_ip}"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update && sleep 15 && sudo apt-get install -f ansible -y && sudo hostnamectl set-hostname worker-node"]
  }

  # This is where we configure the instance with ansible-playbook
  # install K8S on worker node
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      >workerhost;
      echo "[k8sworker]" | tee -a workerhost;
      echo "${aws_instance.workernode.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.private_key} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a workerhost;
      cat masterhost | tee -a workerhost;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i workerhost k8s-worker-node-installation.yaml
    EOT
  }

  tags = {
    Name = "worker-node"
  }
}

output "ec2_workernode_publicip" {
  value = "${aws_instance.workernode.public_ip}"
}

provider "aws" {
  region = "us-east-2"
}

variable "private_key" {
  default = "/sites/keyfile.pem"
}

variable "ansible_user" {
  default = "ubuntu"
}

variable "instance_count" {
  default = "2"
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
      ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/masterhost k8s-master-node-installation.yaml
    EOT
  }

  tags = {
    Name = "k8smaster-node"
  }
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
   #   ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/workerhost k8s-worker-node-installation.yaml
    EOT
  }

  tags = {
    Name = "k8sworker-node"
  }

  depends_on = ["aws_instance.k8smaster"]
}

resource "aws_instance" "k8sworkernode1" {
  ami           = "ami-05c1fa8df71875112"
  instance_type = "t2.medium"

  security_groups = ["k8scluster"]
  key_name        = "k8skey"

  connection {
    user        = "${var.ansible_user}"
    private_key = "${file(var.private_key)}"
    host        = "${aws_instance.k8sworkernode1.public_ip}"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update && sleep 15 && sudo apt-get install -f ansible -y && sudo hostnamectl set-hostname worker-node1"]
  }

  # This is where we configure the instance with ansible-playbook
  # install K8S on worker node
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      >>hostfiles/workerhost;
      echo "${aws_instance.k8sworkernode1.public_ip} ansible_user=${var.ansible_user} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a hostfiles/workerhost;
      cat hostfiles/masterhost | tee -a hostfiles/workerhost;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/workerhost k8s-worker-node-installation.yaml
    EOT
  }

  tags = {
    Name = "k8sworker-node1"
  }
  depends_on = ["aws_instance.k8sworkernode"]

}


output "ec2_masternode_publicip" {
  value = "${aws_instance.k8smaster.public_ip}"
}

output "ec2_workernode_publicip" {
  value = "${aws_instance.k8sworkernode.public_ip}"
}

output "ec2_workernode1_publicip" {
  value = "${aws_instance.k8sworkernode1.public_ip}"
}

//
// MySQL Dump Restore = This is the TARGET piece of the configuration.
//
provider "aws" {
  profile = var.profile
  region  = var.region
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["Matrix VPC"]
  }
}

data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["Matrix Public A"]
  }
}


// AWS Instance Definition
resource "aws_instance" "ec2-target" {
  ami                    = var.amz-ubuntu-ami
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.selected.id
  vpc_security_group_ids = [aws_security_group.Matrix-SG.id]
  monitoring             = true
  key_name               = var.target_key_name
  user_data              = file("../common/ec2_setup.sh")
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  provisioner "file" {
    source      = "../../../Bash/dump-restore"
    destination = "/home/ubuntu/"
  }

  provisioner "file" {
    source      = "/tmp/bucket_id"
    destination = "/tmp/bucket_id"
  }

  provisioner "file" {
    #source     = "../common/source_my_cnf"
    source      = "../../rds/target_rds/.my.cnf"
    destination = "/home/ubuntu/.my.cnf"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x dump-restore/*.sh",
      "echo 'banner Target' >> ~ubuntu/.profile",
      "echo  `cat /tmp/bucket_id` >> ~ubuntu/.profile"
    ]

  }

  connection {
    type        = "ssh"
    host        = aws_instance.ec2-target.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/ReedCDS2020.pem")
    timeout     = "4m"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }


  volume_tags = {
    Name = "Target EC2"
  }

  tags = {
    Name = "dump-restore"
  }
}

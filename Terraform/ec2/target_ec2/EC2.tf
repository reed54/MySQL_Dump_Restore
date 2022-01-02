provider "aws" {
  profile = var.profile
  region  = var.region
}


// AWS Instance Definition
resource "aws_instance" "ec2-target" {
  ami                    = var.amz-linux2-ami
  instance_type          = "t3.micro"
  subnet_id              = var.ec2_subnet_id
  vpc_security_group_ids = [aws_security_group.Matrix-SG.id]
  monitoring             = true
  key_name               = var.target_key_name
  user_data              = file("../common/ec2_setup.sh")
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  provisioner "file" {
    source      = "/home/jdreed/code/EM/dump-restore"
    destination = "/home/ec2-user/"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x dump-restore/*.sh",
    ]

  }

  connection {
    type        = "ssh"
    host        = aws_instance.ec2-target.public_ip
    user        = "ec2-user"
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


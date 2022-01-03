provider "aws" {
  profile = var.profile
  region  = var.region
}


// AWS Instance Definition
resource "aws_instance" "ec2-source" {
  ami                    = var.amz-ubuntu-ami
  instance_type          = "t3.micro"
  subnet_id              = var.ec2_subnet_id
  vpc_security_group_ids = [aws_security_group.Matrix-SG.id]
  monitoring             = true
  key_name               = var.source_key_name
  user_data              = file("../common/ec2_setup.sh")
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  provisioner "file" {
    source      = "../../../Bash/dump-restore"
    destination = "/home/ubuntu/"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x dump-restore/*.sh",
      "echo 'banner Source' >> ~ubuntu/.profile",
    ]

  }

  connection {
    type        = "ssh"
    host        = aws_instance.ec2-source.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/mysql-src-kp.pem")
    timeout     = "4m"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }


  volume_tags = {
    Name = "Source EC2"
  }

  tags = {
    Name = "dump-restore"
  }
}

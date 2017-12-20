resource "aws_subnet" "ad_subnet" {
  vpc_id                  = "${aws_vpc.appsvpc.id}"
  cidr_block              = "${var.ad_subnet_cidr_block}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.az}"

  tags {
    Name = "${local.name_prefix}ad-subnet"
  }
}

resource "aws_route_table_association" "apps_route_table_association" {
  subnet_id      = "${aws_subnet.ad_subnet.id}"
  route_table_id = "${aws_route_table.apps_route_table.id}"
}

resource "aws_instance" "win" {
  instance_type = "t2.nano"
  ami           = "${data.aws_ami.win.id}"
  key_name      = "test_instance"

  iam_instance_profile = "${var.ad_writer_instance_profile_name}"
  subnet_id            = "${aws_subnet.ad_subnet.id}"

  vpc_security_group_ids = [
    "${aws_security_group.sg.id}",
  ]

  count = "${local.windows}"

  tags {
    Name        = "ec2-ad-${var.service}-apps-win-${var.environment}"
    Service     = "${var.service}"
    Environment = "${var.environment}"
  }
}

locals {
  windows = 1
  rhel    = 1
}

resource "aws_ssm_association" "win" {
  name        = "${var.ad_aws_ssm_document_name}"
  instance_id = "${element(aws_instance.win.*.id, count.index)}"
  count       = "${local.windows}"
}

resource "aws_security_group" "sg" {
  vpc_id = "${aws_vpc.appsvpc.id}"

  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags {
    Name        = "sg-ad-${var.service}-${var.environment}"
    Service     = "${var.service}"
    Environment = "${var.environment}"
  }
}

resource "aws_instance" "another_rhel" {
  instance_type = "t2.micro"
  ami           = "${data.aws_ami.rhel.id}"
  subnet_id     = "${aws_subnet.ad_subnet.id}"
  key_name      = "cns"

  vpc_security_group_ids = [
    "${aws_security_group.sg.id}",
  ]

  user_data = <<EOF
#!/bin/bash
yum -y install sssd realmd krb5-workstation adcli samba-common-tools expect
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl reload sshd
systemctl start sssd.service
echo "%Domain\\ Admins@myapp.com ALL=(ALL:ALL) ALL" >>  /etc/sudoers
expect -c "spawn realm join -U admin@MYAPP.COM MYAPP.COM; expect \"*?assword for admin@MYAPP.COM:*\"; send -- \"$foooooo\r\" ; expect eof"
reboot
EOF

  count = "${local.rhel}"

  tags {
    Name        = "ec2-ad-${var.service}-apps-rhel-${var.environment}"
    Service     = "${var.service}"
    Environment = "${var.environment}"
  }
}

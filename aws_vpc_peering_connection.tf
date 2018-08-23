provider "aws" {
    alias   = "peer"
    region  = "${var.peer_region}"

    shared_credentials_file = "${var.peer_credentials}"
}

data "aws_region" "peer" {
  provider = "aws.peer"
}

resource "aws_vpc_peering_connection" "peer_from_vpc" {
  peer_vpc_id   = "${data.aws_vpc.peer_to_vpc.id}"
  vpc_id        = "${data.aws_vpc.peer_from_vpc.id}"
  peer_region   = "${data.aws_region.peer.id}"

  auto_accept = false

  tags = {
    Name    = "${var.peer_from_vpc_name} to ${var.peer_to_vpc_name}"
    Comment = "Managed By Terraform"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer_to_vpc" {
  provider                  = "aws.peer"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer_from_vpc.id}"
  auto_accept               = "${var.auto_accept}"

  tags = {
    Name    = "${var.peer_from_vpc_name} to ${var.peer_to_vpc_name}"
    Comment = "Managed By Terraform"
  }
}

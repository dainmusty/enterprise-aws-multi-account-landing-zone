# Network Firewall
resource "aws_networkfirewall_firewall" "core_fw" {
  name                = "core-network-firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.policy.arn
  vpc_id              = aws_vpc.core.id

  subnet_mapping {
    subnet_id = aws_subnet.firewall_a.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.firewall_b.id
  }
}


# update route tables:
# Private Subnets → Route 0.0.0.0/0 → Firewall Endpoint
# Firewall → NAT Gateway → IGW

# Firewall subnets for AWS Network Firewall
resource "aws_subnet" "firewall_a" {
  provider          = aws.network
  vpc_id            = aws_vpc.core.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "core-firewall-subnet-a"
  }
}

resource "aws_subnet" "firewall_b" {
  provider          = aws.network
  vpc_id            = aws_vpc.core.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "core-firewall-subnet-b"
  }
}

# Network Firewall policy
resource "aws_networkfirewall_firewall_policy" "policy" {
  provider = aws.network

  name = "core-firewall-policy"

  firewall_policy {
    # Use AWS-managed default action to forward traffic to the firewall endpoints
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    # No custom rules defined yet; add rule groups below as needed
  }
}

variable "dcos_install_mode" {
  description = "specifies which type of command to execute. Options: install or upgrade"
  default     = "install"
}

variable "provider" {
  description = "Provider to use"
  default     = "aws"
}

variable "os" {
  description = "Operating system to use"
  default     = "coreos_1855.5.0"
}

variable "region" {
  description = "region"
  default     = "cn-northwest-1"
}

variable "aws_default_os_user" {
  description = "Map OS name to default login user (e.g. centos -> centos, coreos -> coreos)"
  type        = "map"

  default = {
    coreos = "core"
    centos = "centos"
    ubuntu = "ubuntu"
    rhel   = "ec2-user"
    coreos_1855.5.0 = "core"
  }
}

variable "aws_ami" {
  description = "AMI that will be used for the instances instead of Mesosphere provided AMIs"
  type        = "map"

  default = {
    # CoreOS 1855.5.0
    coreos_1855.5.0_ap-northeast-1 = "ami-0a8c6be5f87b35dd4"
    coreos_1855.5.0_ap-northeast-2 = "ami-0cac5781f008b2bda"
    coreos_1855.5.0_ap-south-1     = "ami-0cd820071bc8b5305"
    coreos_1855.5.0_ap-southeast-1 = "ami-00aa99ecc25144574"
    coreos_1855.5.0_ap-southeast-2 = "ami-008d71c75e5ae947c"
    coreos_1855.5.0_ca-central-1   = "ami-07d53410c0f2b0132"
    coreos_1855.5.0_eu-central-1   = "ami-09699c9a5df9e662b"
    coreos_1855.5.0_eu-west-1      = "ami-07c86c6e70759b682"
    coreos_1855.5.0_eu-west-2      = "ami-074e993e6c24f801b"
    coreos_1855.5.0_eu-west-3      = "ami-09cb56d44bcbdde4b"
    coreos_1855.5.0_sa-east-1      = "ami-01b155f0246dad1a8"
    coreos_1855.5.0_us-east-1      = "ami-0bb5afc82c391abb7"
    coreos_1855.5.0_us-east-2      = "ami-068b76746d50afb12"
    coreos_1855.5.0_us-west-1      = "ami-07d8f0cf1498b72f4"
    coreos_1855.5.0_us-west-2      = "ami-0884a563b7da04715"
    coreos_1855.5.0_cn-northwest-1      = "ami-00435c26c02508dc7"
  }
}

# Used to determine your public IP for forwarding rules
data "http" "whatismyip" {
  url = "http://whatismyip.akamai.com/"
}

module "dcos" {
  source  = "dcos-terraform/dcos/aws"
  version = "~> 0.1"

  dcos_instance_os    = "coreos_1855.5.0"
  cluster_name        = "my-open-dcos"
  ssh_public_key_file = "~/.ssh/id_rsa.pub"
  admin_ips           = ["${data.http.whatismyip.body}/32"]

  num_masters        = "1"
  num_private_agents = "2"
  num_public_agents  = "1"

  dcos_version = "1.11.4"

  # dcos_variant              = "ee"
  # dcos_license_key_contents = "${file("./license.txt")}"
  dcos_variant = "open"

  dcos_install_mode = "${var.dcos_install_mode}"
  aws_ami = "ami-00435c26c02508dc7"
  bootstrap_aws_ami = "ami-00435c26c02508dc7"
  masters_aws_ami = "ami-00435c26c02508dc7"
  private_agents_aws_ami = "ami-00435c26c02508dc7"
  public_agents_aws_ami = "ami-00435c26c02508dc7"
}

output "masters-ips" {
  value = "${module.dcos.masters-ips}"
}

output "cluster-address" {
  value = "${module.dcos.masters-loadbalancer}"
}

output "public-agents-loadbalancer" {
  value = "${module.dcos.public-agents-loadbalancer}"
}
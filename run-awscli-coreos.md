## run aws cli on CoreOS

```
https://github.com/jdrago999/aws-cli-on-CoreOS
git clone https://github.com/jdrago999/aws-cli-on-CoreOS.git
cd aws-cli-on-CoreOS/
docker build -t jdrago999/aws-cli .
vi ~/.aws/config
[default]
region = us-east-1
vi ~/.aws/credentials
[default]
aws_access_key_id = AKIXXXXXXXXXXXXXXXXX
aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

docker run -it -v $HOME/.aws:/home/aws/.aws -v /mnt:/mnt jdrago999/aws-cli aws s3 cp /mnt/mesosroot.img s3://mastercard-poc-bucket/
```

## install docker on CentOS

```
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
  
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
[centos@ip-10-0-2-157 aws-cli-on-CoreOS]$ sudo yum install docker-ce
[centos@ip-10-0-2-157 aws-cli-on-CoreOS]$ sudo systemctl start docker
[centos@ip-10-0-2-157 aws-cli-on-CoreOS]$ sudo systemctl enable docker
[centos@ip-10-0-2-157 aws-cli-on-CoreOS]$ sudo usermod -a -G docker $USER
```

## install docker on Amazon Linux 2

```
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
sudo yum update -y
sudo amazon-linux-extras install docker
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
logout/login
docker info
```
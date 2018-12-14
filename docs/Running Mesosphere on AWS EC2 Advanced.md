# Running DC/OS on AWS EC2 Advanced
In this guide will walk you through step-by-step on how to Running DC/OS on AWS EC2 Advanced.

## Hightlight
- Follow the [official document](https://docs.mesosphere.com/1.12/installing/evaluation/community-supported-methods/aws/advanced/) for Global region
- Update the IAM policy as China region format, such as `"Service": "ec2.amazonaws.com.cn"` 
- Update the IBM policy ARN as China region format, such as `"Resource": "arn:aws-cn:s3" `
- By default instance type is `m4` serial
 

## Prerequisites
- Download the [dcos_generate_config.sh](https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh)
- The CLI JSON processor [jq](https://github.com/stedolan/jq/wiki/Installation)
- The s3 policy
Global

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AddPerm",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::YOUR_ACCOUNTS:role/ray-ec2-role"
            },
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::mesos-exhibitors3bucket-s35u65kxm5qu/demo/*"
            ]
        }
    ]
}
```

China Region

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AddPerm",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws-cn:iam::YOUR_ACCOUNTS:role/ray-ec2-role"
            },
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws-cn:s3:::mesos-exhibitors3bucket-s35u65kxm5qu/demo/*"
            ]
        }
    ]
}
```

## Create a configuration file in the `genconf` directory in your home directory and save as `config.yaml`
Note due to the [dcos_generate_config.sh](https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh) will access the Global s3.amazonaws.com, so you need specify the info of Global Region
For configuration parameters descriptions, see the [document](https://docs.mesosphere.com/1.12/installing/production/advanced-configuration/configuration-reference/)

```
[ec2-user@ip-10-0-0-33 ~]$ cat genconf/config.yaml 
aws_template_storage_bucket: mesos-exhibitors3bucket-s35u65kxm5qu
aws_template_storage_bucket_path: demo
aws_template_storage_region_name: us-east-1
aws_template_upload: true
aws_template_storage_access_key_id: xxxx
aws_template_storage_secret_access_key: xxxx
```
For parameters descriptions and configuration examples, see the [documentation](https://installing/ent/custom/configuration/configuration-parameters/)

## Make sure the [dcos_generate_config.sh](https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh) is under the parent directory of `genconf` directory. Then, run the `dcos_generate_config.sh` script to create the cloudformation template.
```
[ec2-user@ip-10-0-0-33 ~]$ sudo bash dcos_generate_config.sh --aws-cloudformation
====> EXECUTING AWS CLOUD FORMATION TEMPLATE GENERATION
Generating configuration files...
Starting new HTTPS connection (1): s3.amazonaws.com
```
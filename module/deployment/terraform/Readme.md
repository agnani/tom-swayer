# Deploy the Web Application in AWS with Terraform

Created using Tom Sawyer Perspectives.

The following instructions deploy the web application in a AWS-EC2 instance with Terraform.

Terraform is an IaC (Infrastructure as Code) tool that allows you to manage infrastructure
with configuration files rather than through a graphical user interface. IaC allows you to
build, change, and manage your infrastructure in a safe, consistent, and repeatable
way by defining resource configurations that you can version, reuse, and share.

## Initial Setup

To run these instructions you need:

1. Ensure you built the web application using the instructions in the ```Readme.md```
file located at the root of the application.

2. These instructions use Java version 17 to run the web application as service in the
EC2 instance. If you need to change the version review the section [Possible Issues](#possible-issues)
step **Use a EC2 instance with different operative system or architecture** to do so.

3. The [Terraform CLI (1.2.0+)](https://developer.hashicorp.com/terraform/downloads?product_intent=terraform)
installed.

4. The [AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
installed.

5. An [AWS account](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all)
and [associated credentials](https://docs.aws.amazon.com/IAM/latest/UserGuide/security-creds.html)
that allow you to create resources.

6. Ensure you have a VPC created to use in the correct region, and it includes all subnets.
For more information, see [Create a virtual private cloud](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/get-set-up-for-amazon-ecs.html#create-a-vpc).

7. Create a key-pair in the Amazon EC2 for Linux Instances. We need a private key file
with format ```.pem``` to access our instance by SSH. To create one do the following:

    1. Go to your AWS console.

    2. Select ```EC2``` from ```Services``` drop-down, click on ```Key Pairs```, then click
    on ```Create key pair``` button.

    3. Enter a ```Name``` for your key, we will refer to it as ```<pem_file_name>```.

    4. Select ```.pem``` for ```openSSH``` and then click on ```Create key pair```.

    5. Download the key and move it to your machine’s ```.ssh``` folder. For Linux and
    MacOS, this will most likely be ```~/.ssh```.

    6. Restrict permission to the ```pem``` file with:
    ```shell
    $ chmod 400 <pem_file_name>
    ```

    7. The way you name the key-pair file will count when we refer to it later in these
    instructions. If you added ```.pem``` at the end of the name, consider it when we
    refer to ```<pem_file_name>```. If you did not add ```.pem``` at the end of the
    name, exclude it when we refer to ```<pem_file_name>```. If you do not know that
    information, review it in your AWS console in section ```Key Pairs```, the name
    listed in there will be the value for ```<pem_file_name>```.

    8. For more information, see [Create key-pair for for Linux Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html).
   
This tutorial will provision resources that qualify under the [AWS free tier](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all).
If your account does not qualify for free tier resources, we are not responsible for any
charges that you may incur.

## Run Instructions

1. To use your IAM credentials to authenticate the Terraform AWS provider, set the
environment variables:
```shell
$ export AWS_ACCESS_KEY_ID=
$ export AWS_SECRET_ACCESS_KEY=
```

2. Change the configuration file located in ```deployment/terraform/aws/main.tf```.
By default, it sets the AMI ID to an Amazon Linux 64-bit (x86) image and instance
type ```t2.micro``` available for region ```us-east-1```, which qualifies for
AWS' free tier:

    1. If you use a region other than ```us-east-1``` change the following line:
    ```text
    provider "aws" {
        region = "us-east-1"
    }
    ```

    2. Replace the following line to use your VPC ID:
    ```text
    variable "vpc_id" {
        type    = string
        default = "vpc-0adc32e81d2804255" // VPC US East
    }
    ```

    3. If you use a region other than ```us-east-1```, you also need to change your
    AMI since AMI IDs are region-specific. Choose an AMI ID specific to your region by
    following [these instructions](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html#finding-quick-start-ami),
    and replace the ```ami_id``` variable. We recommend using an Amazon Linux 64-bit (x86)
    instance since these instructions were written thinking in these types of instances.
    ```text
    variable "ami_id" {
        type    = string
        default = "ami-0889a44b331db0194" // Amazon Linux 64-bit (x86) Free Tier Eligible
    }
    ```

    4. If you use another AMI with a different CPU capacity and memory, change the value
    ```t2.micro``` in the variable ```instance_type```:
    ```text
    resource "aws_instance" "app_server" {
        ami                         = var.ami_id
        instance_type               = "t2.micro"
        vpc_security_group_ids      = [aws_security_group.allow_traffic.id]
        ...
    }
    ```

    5. If you use an instance other than Amazon Linux 64-bit (x86), you have to change
    the instructions to install Java 17. Please review the section [Possible Issues](#possible-issues)
    step **Use a EC2 instance with different operative system or architecture** to do so.

    6. Look for the ```<pem_file_name>``` word and replace it with your PEM file name.
    There are three variables ```key_name```, ```scp-cmd.value```, and ```ssh-cmd.value```.
    After replacing ```<pem_file_name>``` your file should look like:
    ```text
    resource "aws_instance" "app_server" {
        key_name = "my.aws.developer.pem"
    }

    output "scp-cmd" {
        value = "scp -i ~/.ssh/my.aws.developer.pem my-project.zip ec2-user@${aws_instance.app_server.public_dns}:/home/ec2-user/."
    }

    output "ssh-cmd" {
        value = "ssh -i ~/.ssh/my.aws.developer.pem ec2-user@${aws_instance.app_server.public_dns}"
    }
    ```

3. Go to the directory where the ```main.tf``` file is located:
```shell
$ cd deployment/terraform/aws
```

4. Initialize the directory. When you create a new configuration you need to initialize
the directory. Initializing a configuration directory downloads and installs the providers
defined in the configuration, which in this case is the ```aws``` provider.
```shell
$ terraform init
```

5. Create infrastructure. Before applies any changes, Terraform prints out the execution
plan which describes the actions Terraform will take in order to change your
infrastructure to match the configuration.

    1. Run the command:
    ```shell
    $ terraform apply
    ```

    2. Terraform will now pause and wait for your approval before proceeding. If anything
    in the plan seems incorrect or dangerous, it is safe to abort here before Terraform
    modifies your infrastructure.

    3. In this case the plan is acceptable, so type ```yes``` at the confirmation prompt
    to proceed. Executing the plan will take a few minutes since Terraform waits for the
    EC2 instance to become available.

    4. After applying changes this command will print the variables ```scp-cmd```,
    ```ssh-cmd```, ```app-url```, and ```app-server-public-dns```. Write them down, we
    will use them later.

    5. Review your EC2 Dashboard in AWS console to be sure the EC2 instance is running
    and able to access it.

6. Go to the ```terraform``` directory:
```shell
$ cd terraform/
```

7. Give execution permission to the script:
```shell
$ chmod 700 package.sh
```

8. Compress your application in a ZIP file with:
```shell
$ ./package.sh
```

9. Send the ZIP file to the EC2 instance with the variable ```scp-cmd``` printed
before:
```shell
$ scp -i ~/.ssh/<pem_file_name> my-project.zip ec2-user@<app-server-public-dns>:/home/ec2-user/.
```

10. Access the EC2 instance with the variable ```ssh-cmd``` printed before:
```shell
$ ssh -i ~/.ssh/<pem_file_name> ec2-user@<app-server-public-dns>
```

11. In the EC2 instance unzip the ZIP file with:
```shell
$ unzip my-project.zip
```

12. In the EC2 instance go to the directory:
```shell
$ cd my-project/
```

13. In the EC2 instance give execution permission to the script:
```shell
$ chmod 700 installService.sh
```

14. In the EC2 instance install the service by typing:
```shell
$ sudo ./installService.sh
```

15. In the EC2 instance start the service with:
```shell
$ sudo systemctl start my-project
```

16. To access the web application use the value ```<app_url>``` printed before,
```http://<app-server-public-dns>:8080```.


## Uninstall service in the EC2 instance

In the EC2 instance you can change your installation or uninstall service using
the script ```uninstallService.sh``` which was created when running the script
```installService.sh```.

1. Give to ```uninstallService.sh``` execution permissions with:
```shell
$ chmod 700 uninstallService.sh
```

2. Run the script:
```shell
$ sudo ./uninstallService.sh
```

3. The service will be destroyed in the EC2 instance.


## Destroy the Terraform deployment

The command ```terraform destroy``` terminates resources managed by your Terraform
project. This command is the inverse of ```terraform apply``` in that it terminates
all the resources specified in your Terraform state. It does not destroy resources
running elsewhere that are not managed by the current Terraform project.

To destroy the Terraform deployment run the following command from your local:
```shell
$ terraform destroy
```


## Possible Issues

1. **Change the AWS region**. If you use a region other than ```us-east-1```, you will
also need to change your AMI, since AMI IDs are region-specific. Choose an AMI ID
specific to your region by following [these instructions](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html#finding-quick-start-ami),
and modify ```main.tf``` with this ID. Then re-run ```terraform apply```.

2. **Create a VPC**. If you do not have a default VPC in your AWS account in the correct
region, navigate to the AWS VPC Dashboard in the web UI, create a new VPC in your region,
and associate all subnets. Then replace the VPC variable ```vpc_id``` with your value in
the file ```main.tf```. For more information about how to create a VPC see [Create a virtual private cloud](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/get-set-up-for-amazon-ecs.html#create-a-vpc).

3. **Use a EC2 instance with more CPU and memory**. If your application cannot start
maybe you need to use another AMI with more CPU capacity and memory, please review
[find a Linux AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html#finding-quick-start-ami).
Remember, AWS only provides a small number of resources that qualifies as free tier. If
your account does not qualify for free tier resources or uses an EC2 instance that does
not qualify for free tier we are not responsible for any charges that you may incur.

    1. Once you selected the correct AMI, change the ```ami_id``` variable in the file
    ```main.tf```.

    2. Open the file ```deployment/terraform/installService.sh``` and change the Java
    variable ```-Xmx700m``` to increase the maximum memory to use by the application:
    ```shell
    echo "ExecStart=/usr/bin/java -Xms512m -Xmx700m -Dspring.index.ignore=true -Djava.security.egd=file:/dev/./urandom -Duser.home=$ScriptDir -jar $ScriptDir/$JarFile" >> /etc/systemd/system/$ServiceName.service
    ```

4. **Use a EC2 instance with different operative system or architecture**. If you use an
EC2 instance other than Amazon Linux 64-bit (x86), you have to change the instructions to
install Java 17. First, look for the correct instructions to install Java 17 in your
instance. Amazon Linux instances uses ```YUM``` as command-line package management utility.

    1. Change the script ```deployment/terraform/installService.sh``` before run the script
    ```package.sh```.

        1. Go to lines where Java is installed and replace them with the correct ones:
        ```shell
        yum update -y
        yum install -y java-17-amazon-corretto.x86_64
        ```

        2. Continue with the main instructions.

    2. To install Java 17 manually.

        1. Access to your EC2 instance by SSH:
        ```shell
        $ ssh -i ~/.ssh/<pem_file_name> ec2-user@<app-server-public-dns>
        ```

        2. Stop the service:
        ```shell
        $ chmod 700 uninstallService.sh
        $ sudo ./uninstallService.sh
        ```

        3. Open the file ```installService.sh``` with a text editor. For example using
        the ```VI``` editor:
        ```shell
        $ sudo vi installService.sh
        ```

        4. Type ```i``` to enable editing the file.

        5. Go to lines where Java is installed and replace them with the correct ones:
        ```shell
        yum update -y
        yum install -y java-17-amazon-corretto.x86_64
        ```

        6. Save your changes and exit from the ```VI``` editor by typing:
        ```text
        [ESC] : w q
        ```

        7. Re-run the script to install the service:
        ```shell
        $ sudo ./installService.sh
        ```

## Documentation

For further details please refer to the [Tom Sawyer Perspectives Documentation](https://support.tomsawyer.com/docs/tsp.j.11.1.0/graph%20and%20data%20visualization/docs/main/).

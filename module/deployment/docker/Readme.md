# Deploy the Web Application in Docker locally

Created using Tom Sawyer Perspectives.

These instructions help to deploy the web application in Docker locally.

## Initial Setup

1. Ensure you built the web application using the instructions in the ```Readme.md```
file located at the root of the application.

2. Ensure you use Java version 17 (or lower) to build the web application since
these instructions use Java 17 to create the Docker image.

3. Ensure you have the latest version of [Docker](https://docs.docker.com/engine/install/) installed.

## Run Instructions

1. To deploy the web application in Docker locally, go to the ```deployment/docker```
directory.

    1. Give execution permission to the script:
    ```shell
    $ chmod 700 deployLocal.sh
    ```

    2. Run the script:
    ```shell
    $ sudo ./deployLocal.sh
    ```

2. A Docker container with the web application name will start. Review it with:
```shell
$ docker ps
```

3. Access the web application at ```http://localhost:8080```.


## Delete the Docker deployment in your local

To remove the Docker deployment in your local use the ```stopLocal.sh``` script.
It will remove the Docker container, the Docker image, and the Docker network
created with the ```deployLocal.sh``` script.

1. Give execution permission to the script with:
```shell
$ chmod 700 stopLocal.sh
```

2. Run the script with:
```shell
$ ./stopLocal.sh
```

## Documentation

For further details please refer to the [Tom Sawyer Perspectives Documentation](https://support.tomsawyer.com/docs/tsp.j.11.1.0/graph%20and%20data%20visualization/docs/main/).



# Deploy the Web Application in AWS as Elastic Container Service

The following instructions help to deploy the web application in AWS with Elastic
Container Service (ECS). We assume you have knowledge of the following AWS topics:

* Elastic Container Service (ECS) configured for AWS Fargate.

* Elastic Container Registry (ECR).

* CloudFormation.

* Task IAM roles.

* AWS CLI version 2.

The web application will be deployed from your local computer.

We assume that Elastic Container Service (ECS) uses machines with architecture ```amd64```,
therefore all the following instructions have been written for architecture ```amd64```.

ECS will incur charges in your AWS account, be sure you have the permissions to create an ECS,
task definitions, and services in the ECS. By default, the web application will use services
with ```3GB``` of memory.

## Initial Setup

1. Ensure you built the web application using the instructions in the ```Readme.md```
file located at the root of the application.

2. Ensure you use Java version 17 (or lower) to build the web application since
these instructions use Java 17 to create the Docker image.

3. Ensure you have [Docker](https://docs.docker.com/engine/install/) installed.

4. If you do not have an AWS account [sign up for an AWS account](https://portal.aws.amazon.com/billing/signup#/start/email)
and follow the online instructions.

5. Ensure you have installed [AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

6. Ensure you have a VPC created to use. For more information, see
[Create a virtual private cloud](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/get-set-up-for-amazon-ecs.html#create-a-vpc).

7. Configure your AWS CLI Profile.

    1. Execute the following command replacing ```<profile_name>``` with the profile
    name that you want:
    ```shell
    $ aws configure --profile <profile_name>
    ```

    2. Enter the required information according to your AWS account. You have to use the AWS
    region where you created the VPC, for example:
    ```
    AWS Access Key ID [None]: ABABABABABABABABABAB
    AWS Secret Access Key [None]: 1z9zVaaa/fff77777vvvvv6666aaaaTTTTTT
    Default region name [None]: us-east-1
    Default output format [None]: json
    ```

8. Create a cluster using the AWS console.

    1. Go to your AWS account > Elastic Container Service > Clusters > Create Cluster.

    2. Use a VPC with public and private subnets. By default, VPCs are created for your
    AWS account. To create a new VPC, go to the VPC Console.

    3. Add the information related to your VPC and select the subnets where your tasks will run.

    4. In "Infrastructure" section select ```AWS Fargate (serverless)```.

    5. Click "Create".

    6. For more information, see [Create a cluster for the Fargate launch type using the console](https://docs.aws.amazon.com/AmazonECS/latest/userguide/create-cluster-console-v2.html).

9. Create a repository (ECR) using the AWS console.

    1. Go to your AWS account > Elastic Container Service > Repositories > Create Repository.

    2. Configure ```Visibility``` as ```Private```.

    3. Provide a name to your repository, for example, ```ts-repository```. The console
    will show the repository's full name at the bottom of the page with form
    ```<repository_url>/<repository_name>```, for example, ```401234567891.dkr.ecr.us-east-1.amazonaws.com/ts-repository```.
    Where ```<repository_url>``` is ```401234567891.dkr.ecr.us-east-1.amazonaws.com``` and
    ```<repository_name>``` is ```ts-repository```. Write them down we will use it later.
    These instructions assume the ```<repository_name>``` is called ```ts-repository```,
    however, you can use whatever name you want, just remember to change it when it is used.

    4. Enable ```Tag Immutability``` to prevent image tags from being overwritten by
    subsequent image pushes using the same tag. Disable ```Tag Immutability``` to allow
    image tags to be overwritten.

    5. Click "Create".

    6. For more information, see [Create a private repository](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html).

## Run Instructions

1. Go to ```deployment/docker```.

2. Give execution permission to the script:
```shell
$ chmod 700 deployECS.sh
```

3. Build the Docker image with:
```shell
$ sudo ./deployECS.sh
```

4. Tag the Docker image to send it to the AWS Repository. Replace the
```<repository_url>``` variable with the value got in the step "Create a repository":
```shell
$ docker tag my-project:latest <repository_url>/ts-repository:my-project-1.0.0
```

5. Give Docker access to your AWS Access Key and Secret Key (replace the
```<profile_name>``` and ```<repository_url>``` variables with your information):
```shell
$ docker login --password $(aws ecr get-login-password --profile <profile_name>) --username AWS <repository_url>
```

6. Push the image to your AWS repository (replace the ```<repository_url>```
variable with your information):
```shell
$ docker push <repository_url>/ts-repository:my-project-1.0.0
```

7. Go to your repository (ECR) created before to ensure the image is already on it.
Click on it to see full details. Write down the ```<image_uri>``` we will use it
later, for example:
```shell
401234567891.dkr.ecr.us-east-1.amazonaws.com/ts-repository:my-project-1.0.0
```

8. Create an AWS ECS Task Definition.

    1. Go to your AWS account > Elastic Container Service > Task Definitions > Create
    New Task Definition.

    2. Task definition family: Specify a unique task definition family name, for
    example: ```my-project-TaskDefinition```.

    3. Container details: Specify a unique name, the container image URI, and whether
    the container should be marked as essential. Each task definition must have at
    least one essential container.
        * Name: ```my-project-Container```.
        * Image URI: It is the ```<image_uri>```, for example, ```401234567891.dkr.ecr.us-east-1.amazonaws.com/ts-repository:my-project-1.0.0```.
        * Essential Container: Yes.

    4. Port mappings:
        * Container Port: 80.
        * Protocol: TCP.

    5. Add any environmental variable that uses your application. Add the followings:
        * ```server.tomcat.redirect-context-root=false```.
        * ```server.forward-headers-strategy=native```.
        * ```server.port=80```.

    6. HealthCheck: Leave it empty.

    7. Docker Configuration is the information in the Dockerfile:
        * Entry point: ```java,-Xms512m,-Xmx3G,-Djava.security.egd=file:/dev/./urandom,-jar,my-project-1.0.0.jar```.
        * Working directory: ```/opt/TomSawyer```.
        * Command: leave it empty.

    8. Click Next to set up all the task definition.

    9. App Environment: AWS Fargate (serverless).

    10. Operating System/Architecture: ```Linux/x86_64```.

    11. Task size: Select the required CPU and memory.

    12. Task Role: A task IAM role allows containers in the task to make API requests
    to AWS services. Create a new one if you needed.

    13. Task Execution Role: A task execution IAM role is used by the container agent
    to make AWS API requests on your behalf. Select Create New Role.

    14. Review the information configured.

    15. Create Task Definition.

    16. For more information, see [Create a task definition using the console](https://docs.aws.amazon.com/AmazonECS/latest/userguide/create-task-definition.html)

9. Create a Service in your cluster.

    1. Go to your AWS account > Elastic Container Service > Clusters > "your-cluster-name" >
    Services > Create.

    2. Launch type: Fargate.

    3. Deployment configuration: Service.

    4. Task definition:
        * Family: select ```my-project-TaskDefinition```.
        * Revision: (Latest).

    5. Service name: Assign a unique name for this service, for example,
    ```network-editor```.

    6. Service Type: Replica.

    7. Desired tasks: 1.

    8. Networking: Use the same VPC used for the Cluster.

    9. Security Group: Create a new security group.

    10. Load balancing. You can configure a load balancer to distribute incoming traffic
    across the tasks running in your service. It is not needed.

    11. Service auto-scaling: Automatically adjust your service's desired count up and
    down within a specified range in response to CloudWatch alarms. You can modify
    your service auto-scaling configuration at any time to meet the needs of your
    application.

    12. Create Service.

    13. For more information, see [Create a service using the console](https://docs.aws.amazon.com/AmazonECS/latest/userguide/create-service-console-v2.html)

10. Use the Public IP of the new service to access your application. The
public IP looks like ```ec2-54-85-57-102.compute-1.amazonaws.com```. You can access your
application at ```http://ec2-54-85-57-102.compute-1.amazonaws.com:8080```


## Delete the AWS infrastructure

After running your Web Application in AWS as an Elastic Container Service, it is recommended
to delete the cluster (and all services associated to it) if you don't want to incur additional
charges in your AWS account.

Also, remove the Docker image locally:
```shell
docker rmi <image_uri>
```

## Documentation

For further details please refer to the [Tom Sawyer Perspectives Documentation](https://support.tomsawyer.com/docs/tsp.j.11.1.0/graph%20and%20data%20visualization/docs/main/).

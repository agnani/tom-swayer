# Deploy the Web Application in Kubernetes

Created using Tom Sawyer Perspectives.

The following instructions deploy the web application in Kubernetes using
Docker Desktop.

Follow these sections to deploy the web application in Kubernetes:

1. Build the web application.

2. Enable Kubernetes.

3. Deploy the web application to Kubernetes.

4. Tear down the application


## Build the web application

1. Ensure you built the web application using the instructions in the ```Readme.md```
file located at the root of the application.

2. Ensure you use Java version 17 (or lower) to build the web application since
these instructions use Java 17 to create the Docker image.


## Enable Kubernetes

1. After installing Docker Desktop, you should see a Docker icon in your menu bar.
Click on it, and navigate to Settings > Kubernetes.

2. Check the checkbox labeled "Enable Kubernetes", and click "Apply & Restart".
Docker Desktop will automatically set up Kubernetes for you. You’ll know that
Kubernetes has been successfully enabled when you see a green light beside
"Kubernetes running" in Settings.

3. For more information, see [Enable Kubernetes](https://docs.docker.com/desktop/kubernetes/#enable-kubernetes).


## Deploy the web application to Kubernetes

1. Go to the directory ```deployment/kubernetes```.

2. Give execution permission to the script:
```shell
$ chmod 700 deployLocal.sh
```

3. Run the script:
```shell
$ sudo ./deployLocal.sh
```

The script will build a Docker image and leave it in your local Docker repository.

Once the script is finished, deploy your application to Kubernetes with:
```shell
$ kubectl apply -f kubernetes-local.yaml
```

You should see output that looks like the following, indicating your Kubernetes objects
were created successfully:
```text
deployment.apps/ts-webapp created
service/ts-entrypoint created
```

Make sure everything worked by listing your deployments:
```shell
$ kubectl get deployments
```

If all is well, your deployment should be listed as follows:
```text
NAME        READY   UP-TO-DATE   AVAILABLE   AGE
ts-webapp   1/1     1            1           6s
```

This indicates all one of the pods you asked for in your YAML are up and running.

Do the same check for your services:
```shell
$ kubectl get services
```

If all is well, your services should be listed as follows:
```text
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
kubernetes      ClusterIP   10.96.0.1        <none>        443/TCP          5h3m
ts-entrypoint   NodePort    10.103.214.212   <none>        8080:30001/TCP   13s
```

In addition to the default kubernetes service, we see our ts-entrypoint service,
accepting traffic on port ```30001/TCP```.

Open a browser and visit your web application at ```http://localhost:30001```.

## Tear down the application

Once satisfied, tear down your application with:
```shell
$ kubectl delete -f kubernetes-local.yaml
```

## Documentation

For further details please refer to the [Tom Sawyer Perspectives Documentation](https://support.tomsawyer.com/docs/tsp.j.11.1.0/graph%20and%20data%20visualization/docs/main/).

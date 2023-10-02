# Generated Web Application

Created using Tom Sawyer Perspectives.

## Initial Setup

To download the necessary dependencies, first you must configure access to Tom Sawyer's
Maven repository. To do so follow these steps:

1. Ensure that [Apache Maven](https://maven.apache.org/) is installed.

2. Follow these steps to configure your `settings.xml` file:

    a. Copy the `modules/graph and data visualization/examples/settings.xml` file over
       the `settings.xml` file located under your Maven home directory (for example,
       `/user.home/.m2/settings.xml`).

    b. Log in to https://repository.tomsawyer.com with the e-mail address and password
       you used to download Tom Sawyer Perspectives from the Tom Sawyer Software website.

    c. Click your e-mail address in the top right of the Tom Sawyer Repository website
       and choose **Edit Profile**.

    d. Enter your password again and click **Unlock**.

    e. Scroll down the page and click the **Copy** icon after the Encrypted Password field.

    f. Modify your `settings.xml` file and replace the two your_password_encrypted
       strings in the servers section with the encrypted password you just copied.

    g. Replace the two your_email strings in the servers section with the e-mail address
       you used to download Tom Sawyer Perspectives.

**Note**: Only the shipping contact of the License Agreement will be able to
access our repository.

## Build Instructions

Run the following command:

```shell
$ mvn clean install
```

## Run Instructions

From the project's root directory run the application with:

```shell
$ java -jar target/my-project-1.0.0.jar
```

After the server starts up, the application can be accessed at http://localhost:8080.

## Deployment Instructions

Deployment instructions and example configuration files and scripts for Linux and macOS
are provided under the generated deployment folder. See the `Readme.md` files in the
`deployment/docker`, `deployment/kubernetes`, and `deployment/terraform` folders for
more information.

If appropriate, you can switch to a deployment license before you follow these
instructions by replacing `ts-perspectives-dev` with `ts-perspectives-dep` in your
`pom.xml` file and updating the `com.tomsawyer.licensing.licenseName` property in your
`application.properties` file.

## Documentation

For further details please refer to the [Tom Sawyer Perspectives Documentation](https://support.tomsawyer.com/docs/tsp.j.11.1.0/graph%20and%20data%20visualization/docs/main/).

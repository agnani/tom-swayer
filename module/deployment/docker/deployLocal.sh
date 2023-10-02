#!/usr/bin/env bash

TAB="    "

## Make sure we are running script as root.
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root or use sudo."
  echo
  echo "${TAB}sudo ./deployLocal.sh"
  echo
  exit 1
fi

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ApplicationName="my-project"
AppNameToLowerCase="my-project"
JarFile=""${ApplicationName}"-1.0.0.jar"
ImageName="${AppNameToLowerCase}"
ContainerName=""${AppNameToLowerCase}"-container"
DockerNetwork=""${AppNameToLowerCase}"-network"
TemporaryDirectory="temp"

echo "Creating a temporary directory."
if [[ -d ""${ScriptDir}"/"${TemporaryDirectory}"" ]]; then
  echo "Temporary directory already exists."
else
  mkdir "$TemporaryDirectory"
fi

if [[ ! -f "../../target/"${JarFile}"" ]]; then
  echo "Please build your application "${ApplicationName}" first."
  exit 1;
else
  echo "Copying resources on temporary directory."
  if [[ -d "../../config" ]]; then
    cp -r ../../config "$TemporaryDirectory"/.
  fi

  if [[ -d "../../data" ]]; then
    cp -r ../../data "$TemporaryDirectory"/.
  fi

  if [[ -d "../../project" ]]; then
    cp -r ../../project "$TemporaryDirectory"/.
  fi

  cp -r ../../target/"$JarFile" "$TemporaryDirectory"/.
fi

echo "Pulling amazoncorreto 17."
docker pull amazoncorretto
docker pull amazoncorretto:17-alpine-jdk

echo "Creating a docker attachable network."
if [[ "$(docker network ls |grep "$DockerNetwork" 2> /dev/null)" == "" ]]; then
  docker network create --attachable "$DockerNetwork"
else
  echo "Network "${DockerNetwork}" already exists."
fi

echo "Running "${ContainerName}"."
docker stop "$ContainerName" || true && docker rm "$ContainerName" || true
docker build -f dockerfile-local -t "$ImageName" .
docker run --name "$ContainerName" -p 8080:8080 --network "$DockerNetwork" -d "$ImageName":latest --restart on-failure

echo "Removing temporary directory."
if [[ -d ""${ScriptDir}"/"${TemporaryDirectory}"" ]]; then
	rm -rf "$TemporaryDirectory"
fi

echo
echo "Your application is now accessible at:"
echo
echo "${TAB}http://localhost:8080/"
echo

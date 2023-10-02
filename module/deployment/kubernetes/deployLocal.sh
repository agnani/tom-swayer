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
JarFile=""${ApplicationName}"-1.0.0.jar"
ImageName="my-project"
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

echo "Building image "${ImageName}"."
docker build -f dockerfile-local -t "$ImageName" .

echo
echo "Continue with the instructions in file Readme.md or do:"
echo
echo "1. kubectl apply -f kubernetes-local.yaml"
echo "2. kubectl get deployments"
echo "3. kubectl get services"
echo "4. Access your application at http://localhost:30001"
echo

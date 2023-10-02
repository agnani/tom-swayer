#!/usr/bin/env bash

TAB="    "

## Make sure we are running script as root.
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root or use sudo."
  echo
  echo "${TAB}sudo ./deployECS.sh"
  echo
  exit 1
fi

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ApplicationName="my-project"
ImageName="my-project"
JarFile=""${ApplicationName}"-1.0.0.jar"
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

## Review the processor, if it is M1 install amazoncorreto for amd64.
if [[ $(uname -m) == 'arm64' ]]; then
  echo "Pulling amazoncorreto 17 for amd64."
  docker pull amd64/amazoncorretto
  docker pull amd64/amazoncorretto:17-alpine-jdk
else
  echo "Pulling amazoncorreto 17."
  docker pull amazoncorretto
  docker pull amazoncorretto:17-alpine-jdk
fi

## Compile from M1 to amd64
if [[ $(uname -m) == 'arm64' ]]; then
  echo "Compiling from arm64 (M1) to amd64."
  docker buildx build -f dockerfile-ecs-arm --platform=linux/amd64 -t "$ImageName" .
else
  echo "Compiling from amd64 to amd64."
  docker build -f dockerfile-ecs-amd -t "$ImageName" .
fi

echo "Removing temporary directory."
if [[ -d ""${ScriptDir}"/"${TemporaryDirectory}"" ]]; then
	rm -rf "$TemporaryDirectory"
fi

echo
echo "Continue with the instructions in file Readme.md."
echo

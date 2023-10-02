#!/usr/bin/env bash

ApplicationName="my-project"
AppNameToLowerCase="my-project"
ImageName="${AppNameToLowerCase}"
ContainerName=""${AppNameToLowerCase}"-container"
DockerNetwork=""${AppNameToLowerCase}"-network"

docker stop "$ContainerName" || true && docker rm "$ContainerName" || true
docker image rm "$ImageName"
docker network rm "$DockerNetwork"

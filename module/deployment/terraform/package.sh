#!/usr/bin/env bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ApplicationName="my-project"
JarFile=""${ApplicationName}"-1.0.0.jar"
ZipFile=""${ApplicationName}".zip"

echo "Creating a temporary directory."
if [[ -d ""${ScriptDir}"/"${ApplicationName}"" ]]; then
	echo "Temporary directory already exists."
else
  mkdir "$ApplicationName"
fi

if [[ ! -f "../../target/"${JarFile}"" ]]; then
	echo "Please build your application "${ApplicationName}" first."
	exit 1;
else
  echo "Copying resources on temporary directory."
  if [[ -d "../../config" ]]; then
    cp -r ../../config "$ApplicationName"/.
  fi

  if [[ -d "../../data" ]]; then
    cp -r ../../data "$ApplicationName"/.
  fi

  if [[ -d "../../project" ]]; then
    cp -r ../../project "$ApplicationName"/.
  fi

  cp -r ../../target/"$JarFile" "$ApplicationName"/.
  cp installService.sh "$ApplicationName"/.
fi

## Compress files
echo "Creating ZIP file"
zip -r "$ZipFile" "$ApplicationName"

echo "Removing temporary directory."
if [[ -d ""${ScriptDir}"/"${ApplicationName}"" ]]; then
	rm -rf "$ApplicationName"
fi

echo
echo "Continue with the instructions in file Readme.md."
echo

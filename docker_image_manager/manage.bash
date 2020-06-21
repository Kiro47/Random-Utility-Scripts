#!/bin/bash

#######################################################################
# Used to manage the saving of running containers from their images
# as well as restoring them.
#######################################################################

HELP_MSG="usage: $0 [load|save] <directory>"
DIRECTORY=""


## Command checks
if [ $# -eq 0 ]
then
	echo "$HELP_MSG"
	exit 0
fi

if ! [[ "$1" =~ ^(load|save)$ ]];
then
	echo "$HELP_MSG"
	exit 0
fi

if [ -z "$2" ]
then
	DIRECTORY="$(pwd)"
	echo "Setting directory as ${DIRECTORY}"
else
	# Validate dir
	echo ""
fi


if [ "$1" = "save" ];
then
	## Collect docker info
	CONTAINER_IDS="$(docker container ls --all --format '{{.ID}}')"

	if [ -z "$CONTAINER_IDS" ];
	then
		echo "No containers to save"
		exit 1
	fi

	for container_id in $CONTAINER_IDS
	do
		image="$(docker container ls --all --filter "id=${container_id}" --format '{{.Image}}')"
		if [ -z "$image" ];
		then
			echo ""
			echo "Container ${container_id} does not have an image name. Skipping..."
			docker container ls --all --filter "id=${container_id}"
			echo ""
			continue
		fi
		#image_tag="${image#*/}"
		image_name="${image%:*}"

		container_name="$(docker container ls --all --filter "id=${container_id}" --format '{{.Names}}')"
		if [ -z "$container_name" ];
		then
			echo ""
			echo "Container ${container_id} does not have a container name.  Skipping..."
			docker container ls --all --filter "id=${container_id}"
			echo ""
			continue
		fi

		echo "Saving: ${image_name} at ${DIRECTORY}/${container_name}.tar.gz"
		docker save "$image_name" | gzip > "${DIRECTORY}/${container_name}.tar.gz"
	done
	echo "Finished saving"
elif [ "$1" = "load" ]
then
	## Collect images
	# Positive I can ignore this shellcheck, it's valid "correct code"
	# it just isn't well comprehending the variable.
	# shellcheck disable=SC2010
	IMAGES="$(/bin/ls -1 "${DIRECTORY}" | grep '[.]tar[.]gz')"
	if [ -z "$IMAGES" ];
	then
		echo "No images to load"
		exit 1
	fi

	for image in $IMAGES
	do
		echo "Loading: ${image}"
		# docker load pulls metadata of old name
		zcat "${image}" | docker load
	done
	echo "Finished loading"
fi

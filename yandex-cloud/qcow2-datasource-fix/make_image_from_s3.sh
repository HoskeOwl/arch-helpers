#!/usr/bin/env bash

set -x

QCOW2_URL="$1"
FOLDER_ID="$FOLDER_ID"
IMAGE_NAME="arch-linux-cloud-init-$(date '+%Y%m%d-%H%M%S')"
IMAGE_FAMILY=${IMAGE_FAMILY:='arch-base'}
PROFILE="$PROFILE"

if [ -z "$QCOW2_URL" ]; then
    echo "QCOW2_URL should be passed as argument"
    exit 1
fi

if [ -z "$FOLDER_ID" ]; then
    echo "FOLDER_ID environment variable is required"
    exit 1
fi

if [ -z "$PROFILE" ]; then
    echo "PROFILE environment variable is required"
    exit 1
fi

if [ -z "$IMAGE_FAMILY" ]; then
    echo "IMAGE_FAMILY environment variable is required"
    exit 1
fi

yc compute image create --profile "${PROFILE}" --name "${IMAGE_NAME}" --family "${IMAGE_FAMILY}" --os-type linux --min-disk-size 2 --folder-id ${FOLDER_ID} --source-uri  "${QCOW2_URL}"

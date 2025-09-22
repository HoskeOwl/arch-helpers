#!/usr/bin/env bash

# Check required environment variables
check_variable() {
    local var_name="$1"
    local var_value="$2"
    
    if [ -z "$var_value" ]; then
        echo "Error: Required environment variable $var_name is not set or empty" >&2
        exit 1
    fi
}

# Check all required variables
check_variable "YC_BUILD_FOLDER_ID" "$YC_BUILD_FOLDER_ID"
check_variable "YC_BUILD_SERVICE_ACCOUNT_SECRET" "$YC_BUILD_SERVICE_ACCOUNT_SECRET"
check_variable "YC_BUILD_SUBNET" "$YC_BUILD_SUBNET"
check_variable "YC_ZONE" "$YC_ZONE"

export YC_BUILD_FOLDER_ID="$YC_BUILD_FOLDER_ID"
export YC_BUILD_SERVICE_ACCOUNT_SECRET="$YC_BUILD_SERVICE_ACCOUNT_SECRET"
export YC_BUILD_SUBNET="$YC_BUILD_SUBNET"
export YC_ZONE="$YC_ZONE"


if [ -z "$DEBUG" ];then
    packer build base.pkr.hcl
else
    packer build -on-error=abort -debug base.pkr.hcl
fi

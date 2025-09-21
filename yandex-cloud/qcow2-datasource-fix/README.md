# QCOW2 Datasource Fix

This repository contains scripts to modify Arch Linux QCOW2 cloud images to fix datasource issues and prepare them for deployment in Yandex Cloud.

**If you need your own image - use [arch-box](https://github.com/HoskeOwl/arch-boxes) scripts first.**

## Scripts

### 1. `get_stable_image.sh`

Downloads the latest stable Arch Linux cloud image with verification.

**Features:**
- Downloads the latest Arch Linux x86_64 cloud image from the official mirror
- Verifies image integrity using SHA256 checksums
- Verifies image authenticity using GPG signatures
- Configurable via environment variables

**Environment Variables:**
- `IMG_URL` - Image download URL (default: `https://geo.mirror.pkgbuild.com/images/latest`)
- `IMG_PATH` - Local directory to save images (default: `./images`)
- `IMG_NAME` - Image filename (default: `Arch-Linux-x86_64-cloudimg.qcow2`)

**Usage:**
```bash
./get_stable_image.sh
# Or with custom settings:
IMG_URL="https://custom-mirror.com/images" IMG_PATH="/tmp/images" ./get_stable_image.sh
```

### 2. `prepare.sh`

Modifies the downloaded QCOW2 image to fix cloud-init datasource issues.

**Features:**
- Mounts the QCOW2 image using NBD (Network Block Device)
- Copies cloud-init configuration files to fix datasource detection
- Safely unmounts and disconnects the image
- Configurable image path and name

**Environment Variables:**
- `IMG_PATH` - Path to the image directory (default: `./image`)
- `IMG_NAME` - Image filename (default: `Arch-Linux-x86_64-cloudimg.qcow2`)

**Requirements:**
- Root privileges (uses `sudo`)
- NBD kernel module
- qemu-nbd utility

**Usage:**
```bash
sudo ./prepare.sh
# Or with custom image:
IMG_PATH="/path/to/images" IMG_NAME="custom-image.qcow2" sudo ./prepare.sh
```

### 3. `make_image_from_s3.sh`

Creates a Yandex Cloud compute image from a QCOW2 file stored in S3-compatible storage.

**Features:**
- Creates a timestamped image name
- Supports Yandex Cloud CLI profiles
- Configurable image family
- Requires environment variables for security

**Requirements:**
- Yandex [Cloud CLI](https://yandex.cloud/en/docs/cli/quickstart) (`yc`) utility installed and configured
- Valid Yandex Cloud credentials and access to the specified folder

**Required Environment Variables:**
- `FOLDER_ID` - Yandex Cloud folder ID where the image will be created
- `PROFILE` - Yandex Cloud CLI profile name

**Optional Environment Variables:**
- `IMAGE_FAMILY` - Image family name (default: `arch-base`)

**Usage:**
```bash
# Set required environment variables
export FOLDER_ID="your-folder-id"
export PROFILE="your-yc-profile"

# Create image from S3 URL
./make_image_from_s3.sh "https://s3.example.com/path/to/image.qcow2"
```

## Workflow

1. **Download**: Use `get_stable_image.sh` to download the latest Arch Linux cloud image
2. **Prepare**: Use `prepare.sh` to modify the image with cloud-init fixes
3. **Upload**: Upload the prepared image to S3-compatible storage (with s3cmd, for example)
4. **Deploy**: Use `make_image_from_s3.sh` to create a Yandex Cloud compute image

## Configuration Files

The `config/` directory contains cloud-init configuration files that are copied into the image:
- `etc/cloud/cloud.cfg.d/90_datasource.cfg` - Datasource configuration
- `etc/cloud/ds-identify.cfg` - Datasource identification settings


#!/usr/bin/env bash

export IMG_URL=${IMG_URL:-"https://geo.mirror.pkgbuild.com/images/latest"}
export IMG_PATH=${IMG_PATH:=-"./images"}
export IMG_NAME=${IMG_NAME:-"Arch-Linux-x86_64-cloudimg.qcow2"}
export IMG_HASH="${IMG_NAME}.SHA256"
export IMG_SIG="${IMG_NAME}.sig"

mkdir -p "$IMG_PATH"
cd "$IMG_PATH" || (echo "Cant change directory to '${IMG_PATH}'" & exit 1)

date > "$IMG_NAME.date"
echo "Get hash"
curl --progress-bar "${IMG_URL}/${IMG_HASH}" -o "$IMG_HASH"
echo "Get signature"
curl --progress-bar "${IMG_URL}/${IMG_SIG}" -o "$IMG_SIG"
echo "Get image"
curl --progress-bar "${IMG_URL}/${IMG_NAME}" -o "$IMG_NAME"

echo "Compare hashes"
(sha256sum -c "$IMG_HASH" 2>&1 | grep "OK" && echo "OK") || (echo "Image is corrupted!" && exit 1)
echo "Check signature"
(gpg --keyserver-options auto-key-retrieve --verify "$IMG_SIG" 2>&1 >/dev/null | grep -i 'Good Signature' && echo "OK") || (echo "Image isn't original!" && exit 1)

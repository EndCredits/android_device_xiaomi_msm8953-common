#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

LINEAGE_ROOT="$MY_DIR"/../../..

HELPER="$LINEAGE_ROOT"/vendor/aosp/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

while [ "$1" != "" ]; do
    case $1 in
        -n | --no-cleanup )     CLEAN_VENDOR=false
                                ;;
        -s | --section )        shift
                                SECTION=$1
                                CLEAN_VENDOR=false
                                ;;
        * )                     SRC=$1
                                ;;
    esac
    shift
done

if [ -z "$SRC" ]; then
    SRC=adb
fi

function blob_fixup() {
    case "${1}" in
        product/lib64/libdpmframework.so)
            "${PATCHELF}" --add-needed "libshim_dpmframework.so" "${2}"
            ;;
        vendor/lib/mediadrm/libwvdrmengine.so|vendor/lib64/mediadrm/libwvdrmengine.so)
            "${PATCHELF}" --replace-needed "libprotobuf-cpp-lite.so" "libprotobuf-cpp-lite-v29.so" "${2}"
            ;;
        vendor/lib64/libsettings.so)
            "${PATCHELF}" --replace-needed "libprotobuf-cpp-full.so" "libprotobuf-cpp-full-v29.so" "${2}"
            ;;
        vendor/lib64/libwvhidl.so)
            "${PATCHELF}" --replace-needed "libprotobuf-cpp-lite.so" "libprotobuf-cpp-lite-v29.so" "${2}"
            ;;
    esac
}

if [ -z "${ONLY_TARGET}" ]; then
    # Initialize the helper for common device
    setup_vendor "${DEVICE_COMMON}" "${VENDOR}" "${ANDROID_ROOT}" true "${CLEAN_VENDOR}"

extract "$MY_DIR"/proprietary-files-qc.txt "$SRC" "$SECTION"

if [ -s "$MY_DIR"/../$DEVICE/proprietary-files.txt ]; then
    # Reinitialize the helper for device
    setup_vendor "$DEVICE" "$VENDOR" "$LINEAGE_ROOT" false "$CLEAN_VENDOR"

    extract "$MY_DIR"/../$DEVICE/proprietary-files.txt "$SRC" "$SECTION"
fi

DEVICE_BLOB_ROOT="$LINEAGE_ROOT"/vendor/"$VENDOR"/"$DEVICE"/proprietary

if [ "$DEVICE" = "tissot" ]; then
patchelf --remove-needed libbacktrace.so "$DEVICE_BLOB_ROOT"/lib64/hw/gf_fingerprint.default.so
patchelf --remove-needed libunwind.so "$DEVICE_BLOB_ROOT"/lib64/hw/gf_fingerprint.default.so
patchelf --remove-needed libkeystore_binder.so "$DEVICE_BLOB_ROOT"/lib64/hw/gf_fingerprint.default.so
patchelf --remove-needed libsoftkeymasterdevice.so "$DEVICE_BLOB_ROOT"/lib64/hw/gf_fingerprint.default.so
patchelf --remove-needed libsoftkeymaster.so "$DEVICE_BLOB_ROOT"/lib64/hw/gf_fingerprint.default.so
patchelf --remove-needed libkeymaster_messages.so "$DEVICE_BLOB_ROOT"/lib64/hw/gf_fingerprint.default.so

patchelf --remove-needed libbacktrace.so "$DEVICE_BLOB_ROOT"/lib64/libgoodixfingerprintd_binder.so
patchelf --remove-needed libunwind.so "$DEVICE_BLOB_ROOT"/lib64/libgoodixfingerprintd_binder.so
patchelf --remove-needed libkeystore_binder.so "$DEVICE_BLOB_ROOT"/lib64/libgoodixfingerprintd_binder.so
patchelf --remove-needed libsoftkeymasterdevice.so "$DEVICE_BLOB_ROOT"/lib64/libgoodixfingerprintd_binder.so
patchelf --remove-needed libsoftkeymaster.so "$DEVICE_BLOB_ROOT"/lib64/libgoodixfingerprintd_binder.so

patchelf --remove-needed libbacktrace.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so
patchelf --remove-needed libunwind.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so
patchelf --remove-needed libkeystore_binder.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so
patchelf --remove-needed libsoftkeymasterdevice.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so
patchelf --remove-needed libsoftkeymaster.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so
patchelf --remove-needed libkeymaster_messages.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so

patchelf --remove-needed libbacktrace.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so
patchelf --remove-needed libunwind.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so
patchelf --remove-needed libkeystore_binder.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so
patchelf --remove-needed libsoftkeymasterdevice.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so
patchelf --remove-needed libsoftkeymaster.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so
patchelf --remove-needed libkeymaster_messages.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so

fi

if [ "$DEVICE" = "tiffany" ]; then
patchelf --remove-needed libbacktrace.so "$DEVICE_BLOB_ROOT"/lib64/hw/gf_fingerprint.default.so
patchelf --remove-needed libunwind.so "$DEVICE_BLOB_ROOT"/lib64/hw/gf_fingerprint.default.so
patchelf --remove-needed libkeystore_binder.so "$DEVICE_BLOB_ROOT"/lib64/hw/gf_fingerprint.default.so
patchelf --remove-needed libsoftkeymasterdevice.so "$DEVICE_BLOB_ROOT"/lib64/hw/gf_fingerprint.default.so
patchelf --remove-needed libsoftkeymaster.so "$DEVICE_BLOB_ROOT"/lib64/hw/gf_fingerprint.default.so
patchelf --remove-needed libkeymaster_messages.so "$DEVICE_BLOB_ROOT"/lib64/hw/gf_fingerprint.default.so

patchelf --remove-needed libbacktrace.so "$DEVICE_BLOB_ROOT"/lib64/libgoodixfingerprintd_binder.so
patchelf --remove-needed libunwind.so "$DEVICE_BLOB_ROOT"/lib64/libgoodixfingerprintd_binder.so
patchelf --remove-needed libkeystore_binder.so "$DEVICE_BLOB_ROOT"/lib64/libgoodixfingerprintd_binder.so
patchelf --remove-needed libsoftkeymasterdevice.so "$DEVICE_BLOB_ROOT"/lib64/libgoodixfingerprintd_binder.so
patchelf --remove-needed libsoftkeymaster.so "$DEVICE_BLOB_ROOT"/lib64/libgoodixfingerprintd_binder.so

patchelf --remove-needed libbacktrace.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so
patchelf --remove-needed libunwind.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so
patchelf --remove-needed libkeystore_binder.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so
patchelf --remove-needed libsoftkeymasterdevice.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so
patchelf --remove-needed libsoftkeymaster.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so
patchelf --remove-needed libkeymaster_messages.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so

patchelf --remove-needed libbacktrace.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so
patchelf --remove-needed libunwind.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so
patchelf --remove-needed libkeystore_binder.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so
patchelf --remove-needed libsoftkeymasterdevice.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so
patchelf --remove-needed libsoftkeymaster.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so
patchelf --remove-needed libkeymaster_messages.so "$DEVICE_BLOB_ROOT"/vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0.so

fi

if [ "$DEVICE" = "mido" ] || [ "$DEVICE" = "tiffany" ]; then
    # Hax for cam configs
    CAMERA2_SENSOR_MODULES="$LINEAGE_ROOT"/vendor/"$VENDOR"/"$DEVICE"/proprietary/vendor/lib/libmmcamera2_sensor_modules.so
    sed -i "s|/system/etc/camera/|/vendor/etc/camera/|g" "$CAMERA2_SENSOR_MODULES"
fi

"$MY_DIR"/setup-makefiles.sh

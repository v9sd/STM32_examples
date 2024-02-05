#!/usr/bin/env bash

# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself#4774063
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
ZEPHYR_SDK_PATH="/opt/zephyr-sdk-0.16.1"
SOURCE_DIR="${SCRIPTPATH}"
BUILD_DIR="${SCRIPTPATH}/../mass_storage_with_led-build/Debug"

cmake \
  -S  "${SOURCE_DIR}" \
  -B  "${BUILD_DIR}" \
  -DCMAKE_EXPORT_COMPILE_COMMANDS:Bool=ON \
  "-GUnix Makefiles" \
  -DCMAKE_BUILD_TYPE:String=Debug \
  -DCMAKE_C_COMPILER:STRING="${ZEPHYR_SDK_PATH}/arm-zephyr-eabi/bin/arm-zephyr-eabi-gcc" \
  -DCMAKE_CXX_COMPILER:STRING="${ZEPHYR_SDK_PATH}/arm-zephyr-eabi/bin/arm-zephyr-eabi-g++"
if [ $? -ne 0 ]; then
  exit 1
fi

cmake --build "${BUILD_DIR}" --verbose
if [ $? -ne 0 ]; then
  exit 1
fi

ln -s "${BUILD_DIR}/compile_commands.json"  "${SOURCE_DIR}/compile_commands.json"
if [ $? -ne 0 ]; then
  exit 1
fi

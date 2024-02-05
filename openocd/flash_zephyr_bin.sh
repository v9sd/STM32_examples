#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

HELP_IS_ACTIVE=0
SAMPLE_NAME=""
BIN_PATH=""

while getopts n:p:h flag
do
  case "${flag}" in
    n) SAMPLE_NAME=${OPTARG};;
    p) BIN_PATH=${OPTARG};;
    h) HELP_IS_ACTIVE=1;;
  esac
done

if [ ${HELP_IS_ACTIVE} -eq 1 ]; then
  echo 'That is script flash bin throught openocd telnet interface'
  echo 'Next arguments is possibly:'
  echo '  -n "sample_name" - Using sample for standart build path'
  echo '  -p "bin_path" - Using path to bin file witd firmware'
  echo "  -h - Print this help"
  exit 0
fi

if [ -z ${SAMPLE_NAME} ] && [ -z ${BIN_PATH} ]; then
  echo "Please use -p or -n for inform about bin file"
  exit 1
fi

if [ ! -z ${SAMPLE_NAME} ] && [ ! -z ${BIN_PATH} ]; then
  echo "Please use only one -p or -n argument"
  exit 1
fi

if [ ! -z ${SAMPLE_NAME} ]; then
  echo "SAMPLE NAME IS NOT BEEN EMPTY"
  BIN_PATH="${SCRIPT_DIR}/../zephyr/samples/${SAMPLE_NAME}-build/Debug/zephyr/zephyr.bin"
fi

BIN_PATH=$(realpath "${BIN_PATH}")

if [ ! -f ${BIN_PATH} ]; then
  echo "File ${BIN_PATH} isn't exist"
  exit 1
fi

echo "================================"
echo "${SAMPLE_NAME}"
echo "${BIN_PATH}"
echo "================================"

{ echo "program "${BIN_PATH}" 0x08000000"; echo "reset"; sleep 10;} | telnet 127.0.0.1 4444


#!/usr/bin/env bash

# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself#4774063
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

HELP_IS_ACTIVE=0
SAMPLE_NAME=""
ELF_PATH=""
while getopts n:p:h flag
do
  case "${flag}" in
    n) SAMPLE_NAME=${OPTARG};;
    p) ELF_PATH=${OPTARG};;
    h) HELP_IS_ACTIVE=1;;
  esac
done

if [ ${HELP_IS_ACTIVE} -eq 1 ]; then
  echo 'That is script for run cgdb and connect to openocd gdb server'
  echo 'Next arguments is possibly:'
  echo '  -n "sample_name" - Using sample for standart build path'
  echo '  -p "elf_path" - Using path to elf file witd debug information'
  echo "  -h - Print this help"
  exit 0
fi

if [ -z ${SAMPLE_NAME} ] && [ -z ${ELF_PATH} ]; then
  echo "Please use -p or -n for inform about elf file"
  exit 1
fi

if [ ! -z ${SAMPLE_NAME} ] && [ ! -z ${ELF_PATH} ]; then
  echo "Please use only one -p or -n argument"
  exit 1
fi

if [ ! -z ${SAMPLE_NAME} ]; then
  ELF_PATH="${SCRIPTPATH}/samples/${SAMPLE_NAME}-build/zephyr/zephyr.elf"
fi

ELF_PATH=$(realpath "${ELF_PATH}")

if [ ! -f ${ELF_PATH} ]; then
  echo "File ${ELF_PATH} isn't exist"
  exit 1
fi

cgdb  -d /opt/zephyr-sdk-0.15.2/arm-zephyr-eabi/bin/arm-zephyr-eabi-gdb \
  "${ELF_PATH}" -ex "target remote localhost:3333" 

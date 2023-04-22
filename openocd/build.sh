#!/usr/bin/env bash

# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself#4774063
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

INSTALL_DIR="${SCRIPTPATH}/install"
OPENOCD_SRC_DIR="${SCRIPTPATH}/openocd-code"

mkdir -p ${INSTALL_DIR}
if [ $? -ne 0 ]; then
  exit 1
fi

git clone https://git.code.sf.net/p/openocd/code "${SCRIPTPATH}/openocd-code"
if [ $? -ne 0 ]; then
  exit 1
fi

cd "${OPENOCD_SRC_DIR}" && "${OPENOCD_SRC_DIR}/bootstrap" && "${OPENOCD_SRC_DIR}/configure" --enable-jlink --prefix=${INSTALL_DIR} && make && make install 




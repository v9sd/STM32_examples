#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

INSTALL_DIR="${SCRIPTPATH}/install"

"${INSTALL_DIR}/bin/openocd" \
    -f "${INSTALL_DIR}/share/openocd/scripts/interface/jlink.cfg" \
    -f "${SCRIPTPATH}/openocd-scripts/target/stm32f4x.cfg"

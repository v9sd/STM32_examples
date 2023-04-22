# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required(VERSION 3.20.0)

set(BOARD "stm32f401_mini")

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(mass_storage_with_led)

FILE(GLOB app_sources src/*.c)
target_sources(app PRIVATE
  src/main.c
  src/tled_disk.c)

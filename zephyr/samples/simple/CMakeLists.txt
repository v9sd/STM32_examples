cmake_minimum_required(VERSION 3.20.0)
project(simple_app LANGUAGES C)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE} PACKAGE_FIND_VERSION 0.16.1)

target_sources(app PRIVATE src/main.c)

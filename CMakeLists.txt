cmake_minimum_required(VERSION 3.15.2)

## define the project
project(foo_proj
        VERSION 1.2.3
        DESCRIPTION "Some project description"
        HOMEPAGE_URL http://www.example.com
        LANGUAGES Fortran)

################################################################################
## Configure CMake project paths
################################################################################

## configure CMake module search paths that depend on the project
## proj src dir is location of this file
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
# list(APPEND CMAKE_MODULE_PATH ${PROJECT_BINARY_DIR})

## path for *.mod files
## proj build dir is set by CMake user (usually build/)
set(CMAKE_Fortran_MODULE_DIRECTORY ${PROJECT_BINARY_DIR}/mod)

## define the project default install path, if necessary
##
## CMake's native defaults are:
## Windows: C:\\Program Files
## Else: /usr/local
##
## The lines below default to using this file's directory as install root
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR} CACHE PATH "Choose the installation directory" FORCE)
endif()

## Set the project default build type
include(DefaultBuildType)

## Hide the configuration types list
mark_as_advanced(CMAKE_CONFIGURATION_TYPES)

################################################################################
## Define project contents
################################################################################

## Add the subproject subdirectories
add_subdirectory(src/bar)
add_subdirectory(src/foo)

## for VS, set the startup target (the one that starts in debugger by default)
set_property(DIRECTORY PROPERTY VS_STARTUP_PROJECT foo)

## If we had unit tests, we could define them here like below
# set(FOO_BUILD_TESTS OFF CACHE BOOL "Build the unit tests")
# if(FOO_BUILD_TESTS)
#   enable_testing()

#   ## configure the test and its dependencies here like any other target
#   add_executable(test_foo test.f90)
#   target_link_libraries(test_foo bar)

#   ## add the test target to the project
#   add_test(NAME FooTests COMMAND test_foo)
# endif()

# CMake Fortran Template #

I have found there is a dirth of information about how to create Fortran projects with CMake on the web.
For this reason, I have created a template project for Fortran using CMake as the build system.

## The directory structure ##

    CMakeLists.txt
    README.md
    cmake/
        CheckFortran90Support.cmake
        DefaultBuildType.cmake
        SetUpLAPACK.cmake
    src/
        foo/
            CMakeLists.txt
            foo.f90
            constants.f90
        bar/
            CMakeLists.txt
            bar.f90

### CMakeLists.txt ###

This file contains all the boilerplate that you will need to set up your program.  Pretty much all you will need to edit in this file is the name of the project/program and uncomment any lines pertaining to options you may need.

### cmake/ ###

This directory contains CMake scripts that aid in configuring the build system.

#### SetUpLAPACK.cmake ####

This file takes care of some oddities with CMake related to setting up LAPACK, such as the fact that finding MKL requires a C compiler.

### src/ ###

This directory contains the source for your project.  In this project example, there is a library (in `bar/`) and the executable itself (in `foo/`).  Each of these subdirectories contains a `CMakeLists.txt`.

#### bar/CMakeLists.txt ####

All that is contained in this file is a list of the source files for the library bar and a statement that these sources should be compiled to a library.  You will need to edit the source list (and the `STATIC` modifier to `SHARED` if you want a shared library instead of static.).

#### foo/CMakeLists.txt ####

This file contains the sources for the foo executable.  It also specifies that this executable must link to the bar library.  You will need to edit the source list (and whether or not there are libraries to link to).  There is commented code related to parallelization and LAPACK that you may uncomment if required.

## Configuring the build ##

It is usually preferred that you do an "out-of-source" build.  To do this, create a `build/` directory at the top level of your project and build there.

    mkdir build
    cd build
    cmake ..
    make

When you do this, temporary CMake files will not be created in your `src/` directory.

As written, this template will allow you to specify one of three different sets of compiler flags.
The default is RELEASE.  You can change this using:

    cmake .. -DCMAKE_BUILD_TYPE=DEBUG

## History ##

Please see the [CHANGELOG.md](https://github.com/SethMMorton/cmake_fortran_template/blob/master/CHANGELOG.md) in this repository for how this template has changed over time.

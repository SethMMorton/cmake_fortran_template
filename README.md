# CMake Fortran Template #

I have found there is a dirth of information about how to create Fortran projects with CMake on the web.  For this reason, I have created a template project for Fortran using CMake as the build system.

## The directory structure ##

    CMakeLists.txt
    README.md
    bin/
    cmake/
        Modules/
            FindOpenMP_Fortran.cmake
            SetCompileFlag.cmake
            SetFortranFlags.cmake
            SetParallelizationLibrary.cmake
            SetUpLAPACK.cmake
    distclean.cmake
    lib/
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

### distclean.cmake ###

This is a CMake script that will remove all files and folder that are created after running `make`.  You can run this code in one of two ways:

* Execute `cmake -P distclean.cmake`. (The `-P` option to `cmake` will execute a CMake script)
* Execute `make distclean` after your Makefile has been generated.

You shouldn't need to edit this file.

### cmake/Modules/ ###

This directory contains CMake scripts that aid in configuring the build system.

###### FindOpenMP_Fortran.cmake ######

The `FindOpenMP.cmake` file that comes with CMake does not have support for Fortran compilers.  This file finds the correct OpenMP flags for many Fortran compilers.

###### SetCompileFlag.cmake ######

This file defines a function that will test a set of compiler flags to see which one works and adds that flag to a list of compiler flags.  This is used to set compile flags when you don't know which compiler will be used.

###### SetFortranFlags.cmake ######

This file uses the function from `SetCompilerFlag.cmake` to set the DEBUG, TESTING, and RELEASE compile flags for your build.  You might want to inspect this file and edit the flags to your liking.

###### SetParallelizationLibrary.cmake ######

This file takes care of locating OpenMP or MPI as well as issues with switching between the two.

###### SetUpLAPACK.cmake ######

This file takes care of some oddities with CMake related to setting up LAPACK, such as the fact that the LAPACK variables are not saved to the cache, and that finding MKL requires a C compiler.

### src/ ###

This directory contains the source for your project.  In this project example, there is a library (in `bar/`) and the executable itself (in `foo/`).  Each of these subdirectories contains a `CMakeLists.txt`.  

###### bar/CMakeLists.txt ######

All that is contained in this file is a list of the source files for the library bar and a statement that these sources should be compiled to a library.  You will need to edit the source list (and the `STATIC` modifier to `SHARED` if you want a shared library instead of static.).

###### foo/CMakeLists.txt ######

This file contains the sources for the foo executable.  It also specifies that this executable must link to the bar library.  You will need to edit the source list (and whether or not there are libraries to link to).  There is commented code related to parallelization and LAPACK that you may uncomment if required.

### bin/ and lib/ ###

These folders are created after running `make`.  Any libraries created end up in `lib/`, as well as compiled Fortran `.mod` files.  The executable will end up in `bin/`.  

## Configuring the build ##

It is usually preferred that you do an out-of-source build.  To do this, create a `build/` directory at the top level of your project and build there.  

    $ mkdir build
    $ cd build
    $ cmake ..
    $ make
    
When you do this, temporary CMake files will not be created in your `src/` directory.  

As written, this template will allow you to specify one of three different sets of compiler flags.  The default is RELEASE.  You can change this using to TESTING or DEBUG using

    $ cmake .. -DCMAKE_BUILD_TYPE=DEBUG
    
or

    $ cmake .. -DCMAKE_BUILD_TYPE=TESTING
    
There are also options you may uncomment to add support for OpenMP or MPI.  To use these, use

    $ cmake .. -DUSE_OPENMP=ON
    
or

    $ cmake .. -DUSE_MPI=ON
    
Of course, you can also edit the template so that OpenMP or MPI is always used.
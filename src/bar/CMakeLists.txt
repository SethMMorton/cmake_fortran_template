# create a shared (DLL) library...if you want static instead, change SHARED to STATIC
add_library(bar SHARED bar.f90)
target_sources(bar PRIVATE bar.f90)

## if you want the version number in your library name
set_target_properties(bar PROPERTIES OUTPUT_NAME "bar_v${PROJECT_VERSION}")
install(TARGETS bar
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
        )

## if you want the installer to save the module files in the lib folder, you can adjust that here
foreach(config ${CMAKE_CONFIGURATION_TYPES})
  install(FILES ${CMAKE_Fortran_MODULE_DIRECTORY}/${config}/bar_module.mod CONFIGURATIONS ${config} DESTINATION lib)
endforeach()

## Uncomment if you need to link to LAPACK
# include(SetUpLAPACK)
# target_compile_options(bar PUBLIC ${LAPACK_LINKER_FLAGS})
# target_link_libraries(bar ${LAPACK_LIBRARIES})

## Uncomment if you need threads.  At one point, threads were necessary when
## using LAPACK with MKL.  This may no longer be necessary.
## Please submit an issue at
## https://github.com/SethMMorton/cmake_fortran_template/issues
## if you can confirm whether or not this is necessary.
# find_package(Threads)
# target_link_libraries(bar ${CMAKE_THREAD_LIBS_INIT})


################################################################################
##  SOME EXAMPLE COMPILER FLAGS
################################################################################

################################################################################
## GENERAL FLAGS
################################################################################

## Don't add underscores in symbols for C-compatability
# target_compile_options(bar PRIVATE -fno-underscoring)

## Optimize for the host's architecture
# target_compile_options(bar PRIVATE
#   $<$<Fortran_COMPILER_ID:PGI>:-ta=host>
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<PLATFORM_ID:Windows>>:
#     /QxHost
#   >
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<NOT:$<PLATFORM_ID:Windows>>>:
#     -xHost
#   >
#   ## There is some bug where -march=native doesn't work on Mac
#   $<$<AND:$<Fortran_COMPILER_ID:GNU>,$<PLATFORM_ID:Darwin>>:
#     -mtune=native
#   >
#   $<$<AND:$<Fortran_COMPILER_ID:GNU>,$<NOT:$<PLATFORM_ID:Darwin>>>:
#     -march=native
#   >
# )

################################################################################
### DEBUG FLAGS
################################################################################

## NOTE: debugging symbols (-g or /debug:full) are already on by default

## Turn on all warnings
target_compile_options(bar PRIVATE
  $<$<OR:$<CONFIG:debug>,$<CONFIG:relwithdebinfo>>:
    $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<PLATFORM_ID:Windows>>:
      /warn:all
    >
    $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<NOT:$<PLATFORM_ID:Windows>>>:
      -warn all
    >
    $<$<Fortran_COMPILER_ID:GNU>:-Wall>
  >
)

## Traceback
target_compile_options(bar PRIVATE
  $<$<OR:$<CONFIG:debug>,$<CONFIG:relwithdebinfo>>:
    $<$<Fortran_COMPILER_ID:GNU>:-fbacktrace>
    $<$<Fortran_COMPILER_ID:G95>:-ftrace=full>
    $<$<OR:$<Fortran_COMPILER_ID:Intel>,$<Fortran_COMPILER_ID:PGI>>:
      -traceback
    >
  >
)

## Check array bounds
# target_compile_options(bar PRIVATE
#   $<$<OR:$<CONFIG:debug>,$<CONFIG:relwithdebinfo>>:
#     $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<PLATFORM_ID:Windows>>:
#       /check:bounds
#     >
#     $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<NOT:$<PLATFORM_ID:Windows>>>:
#       -check bounds
#     >
#     $<$<Fortran_COMPILER_ID:GNU>:-fcheck=bounds>
#     # $<$<Fortran_COMPILER_ID:GNU>:-fbounds-check>  # GNU (Old style)
#     $<$<Fortran_COMPILER_ID:PGI>:-Mbounds>
#   >
# )

################################################################################
### RELEASE FLAGS
################################################################################

## Unroll loops
# target_compile_options(bar PRIVATE
#   $<$<Fortran_COMPILER_ID:GNU>:-funroll-loops>
#   $<$<Fortran_COMPILER_ID:PGI>:-Munroll>
#   $<$<Fortran_COMPILER_ID:Intel>:-unroll>
# )

## Inline functions
# target_compile_options(bar PRIVATE
#   $<$<Fortran_COMPILER_ID:GNU>:-finline-functions>
#   $<$<Fortran_COMPILER_ID:PGI>:-Minline>
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<PLATFORM_ID:Windows>>:
#     /Qinline
#   >
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<NOT:$<PLATFORM_ID:Windows>>>:
#     -inline
#   >
# )

## Interprocedural (link-time) optimizations
# target_compile_options(bar PRIVATE
#   $<$<Fortran_COMPILER_ID:GNU>:-flto>
#   $<$<Fortran_COMPILER_ID:PGI>:-Mipa>
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<PLATFORM_ID:Windows>>:
#     /Qipo
#   >
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<NOT:$<PLATFORM_ID:Windows>>>:
#     -ipo
#   >
# )

## Single-file optimizations
# target_compile_options(bar PRIVATE
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<PLATFORM_ID:Windows>>:
#     /Qip
#   >
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<NOT:$<PLATFORM_ID:Windows>>>:
#     -ip
#   >
# )

## Vectorize code
# target_compile_options(bar PRIVATE
#   $<$<Fortran_COMPILER_ID:PGI>:-Mvect>
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<PLATFORM_ID:Windows>>:
#     /Qvec-report0
#   >
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<NOT:$<PLATFORM_ID:Windows>>>:
#     -vec-report0
#   >
# )

################################################################################
## all of the stuff below is specific to DLLs
## if you are building a static library, comment out everything below this
################################################################################

## Enable RPATH on Mac/Linux so that shared libraries can be found
## relative to each other without having to specify (DY)LD_LIBRARY_PATH.
## Set RPATH to find dependencies in same directory as loading libraries.
## Linux searches the RPATH before the system LD_LIBRARY_PATH, so enable
## the use of RUNPATH which is searched after LD_LIBRARY_PATH. This makes
## the Linux search order similar to Mac/Windows.
if(UNIX)
  if(APPLE)
    set_target_properties(bar PROPERTIES MACOSX_RPATH TRUE INSTALL_RPATH "@loader_path/")
  else()
    set_target_properties(bar PROPERTIES INSTALL_RPATH "\$ORIGIN/")
    target_link_options(bar PUBLIC "LINKER:--enable-new-dtags")
  endif()
endif()

## disable incremental linking so we can get tracebacks from the DLL when called from Python.
target_link_options(bar PRIVATE
  $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<PLATFORM_ID:Windows>>:
    $<$<OR:$<CONFIG:debug>,$<CONFIG:relwithdebinfo>>:
      /INCREMENTAL:NO
    >
  >
)

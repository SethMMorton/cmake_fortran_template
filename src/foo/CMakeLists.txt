add_executable(foo foo.f90 constants.f90)
# find_package(bar)
target_link_libraries(foo bar)
source_group("Module Sources" FILES constants.f90)

## for debugging in VS, foo cannot find the bar dll.
## Let's manually copy it to the exe location
add_custom_command(TARGET foo POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E
                     copy $<TARGET_FILE:bar> $<TARGET_FILE_DIR:foo>)

## Uncomment if you need to link to LAPACK
# include(SetUpLAPACK)
# target_compile_options(foo PUBLIC ${LAPACK_LINKER_FLAGS})
# target_link_libraries(foo ${LAPACK_LIBRARIES})

## Uncomment if you need threads.  At one point, threads were necessary when
## using LAPACK with MKL.  This may no longer be necessary.
## Please submit an issue at
## https://github.com/SethMMorton/cmake_fortran_template/issues
## if you can confirm whether or not this is necessary.
# find_package(Threads)
# target_link_libraries(foo ${CMAKE_THREAD_LIBS_INIT})


################################################################################
##  SOME EXAMPLE COMPILER FLAGS
################################################################################

################################################################################
## GENERAL FLAGS
################################################################################

## Don't add underscores in symbols for C-compatability
# target_compile_options(foo PRIVATE -fno-underscoring)

## Optimize for the host's architecture
# target_compile_options(foo PRIVATE
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
target_compile_options(foo PRIVATE
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
target_compile_options(foo PRIVATE
  $<$<OR:$<CONFIG:debug>,$<CONFIG:relwithdebinfo>>:
    $<$<Fortran_COMPILER_ID:GNU>:-fbacktrace>
    $<$<Fortran_COMPILER_ID:G95>:-ftrace=full>
    $<$<OR:$<Fortran_COMPILER_ID:Intel>,$<Fortran_COMPILER_ID:PGI>>:
      -traceback
    >
  >
)

## Check array bounds
# target_compile_options(foo PRIVATE
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
# target_compile_options(foo PRIVATE
#   $<$<Fortran_COMPILER_ID:GNU>:-funroll-loops>
#   $<$<Fortran_COMPILER_ID:PGI>:-Munroll>
#   $<$<Fortran_COMPILER_ID:Intel>:-unroll>
# )

## Inline functions
# target_compile_options(foo PRIVATE
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
# target_compile_options(foo PRIVATE
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
# target_compile_options(foo PRIVATE
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<PLATFORM_ID:Windows>>:
#     /Qip
#   >
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<NOT:$<PLATFORM_ID:Windows>>>:
#     -ip
#   >
# )

## Vectorize code
# target_compile_options(foo PRIVATE
#   $<$<Fortran_COMPILER_ID:PGI>:-Mvect>
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<PLATFORM_ID:Windows>>:
#     /Qvec-report0
#   >
#   $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<NOT:$<PLATFORM_ID:Windows>>>:
#     -vec-report0
#   >
# )

install(TARGETS foo DESTINATION bin)

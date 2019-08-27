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

## An example usage of configuring compiler flags to set debug traceback
target_compile_options(foo PRIVATE
  $<$<CONFIG:DEBUG>:
    $<$<Fortran_COMPILER_ID:GNU>:-fbacktrace>
    $<$<Fortran_COMPILER_ID:G95>:-ftrace=full>
    $<$<OR:$<Fortran_COMPILER_ID:Intel>,$<Fortran_COMPILER_ID:PGI>>:
      -traceback
    >
    $<$<AND:$<Fortran_COMPILER_ID:Intel>,$<PLATFORM_ID:Windows>>:
      /traceback
    >
  >
)

install(TARGETS foo DESTINATION bin)

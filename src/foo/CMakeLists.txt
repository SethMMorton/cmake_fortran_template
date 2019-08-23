add_executable(foo foo.f90 constants.f90)
# find_package(bar)
target_link_libraries(foo bar)
source_group("Modules" FILES constants.f90)

## for debugging in VS, foo cannot find the bar dll.  Let's manually copy it to the exe location
add_custom_command(TARGET foo POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:bar> $<TARGET_FILE_DIR:foo>)

## Uncomment if you need to link to LAPACK
# include(SetUpLAPACK)
# target_compile_options(foo PUBLIC ${LAPACK_LINKER_FLAGS})
# target_link_libraries(foo ${LAPACK_LIBRARIES})

## Uncomment if you need threads
# find_package(Threads)
# target_link_libraries(foo ${CMAKE_THREAD_LIBS_INIT})

install(TARGETS foo DESTINATION bin)

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
target_link_options(bar PRIVATE $<$<PLATFORM_ID:Windows>:$<$<OR:$<CONFIG:debug>,$<CONFIG:relwithdebinfo>>:/INCREMENTAL:NO>>)

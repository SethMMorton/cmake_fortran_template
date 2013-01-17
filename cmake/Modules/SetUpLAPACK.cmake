# Determine if the user wants to find MKL, and set the appropriate variable
IF(USE_MKL)
    # We need a C compiler to check for MKL
    # (Even though it's a Fortran project...write to Kitware, it's not my fault)
    ENABLE_LANGUAGE(C)
    # Choose the proper MKL libraries to search for
    IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
        SET(BLA_VENDOR "Intel10_64lp")
    ELSE()
        SET(BLA_VENDOR "Intel10_32")
    ENDIF(CMAKE_SIZEOF_VOID_P EQUAL 8)
    # Unset BLAS and LAPACK so we can search for MKL
    UNSET(BLAS_FOUND CACHE)
    UNSET(LAPACK_FOUND CACHE)
    UNSET(BLAS_LIBRARIES CACHE)
    UNSET(LAPACK_LIBRARIES CACHE)
ENDIF(USE_MKL)

# Find LAPACK (finds BLAS also) if not already found
IF(NOT LAPACK_FOUND)
    FIND_PACKAGE(LAPACK REQUIRED)
    # Remember that LAPACK (and BLAS) was found.  For some reason the
    # FindLAPACK routine doesn't place these into the CACHE.
    SET(BLAS_FOUND TRUE CACHE INTERNAL "BLAS was found" FORCE)
    SET(LAPACK_FOUND TRUE CACHE INTERNAL "LAPACK was found" FORCE)
    SET(BLAS_LIBRARIES ${BLAS_LIBRARIES} CACHE INTERNAL "BLAS LIBS" FORCE)
    SET(LAPACK_LIBRARIES ${LAPACK_LIBRARIES} CACHE INTERNAL "LAPACK LIBS" FORCE)
    # Turn off the USE_MKL switch now that LAPACK was found
    IF(USE_MKL)
        SET(USE_MKL OFF CACHE BOOL "Attempt to specifically locate the MKL libraries" FORCE)
    ENDIF(USE_MKL)
ENDIF(NOT LAPACK_FOUND)

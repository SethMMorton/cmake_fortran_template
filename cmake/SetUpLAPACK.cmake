# Find LAPACK (finds BLAS also) if not already found
if(NOT LAPACK_FOUND)
    enable_language(C)  # Some libraries need a C compiler to find
    find_package(LAPACK REQUIRED)
endif()

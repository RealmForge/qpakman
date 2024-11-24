cmake_minimum_required(VERSION 3.22)

project(QPAKMAN CXX)

if ("${CMAKE_TOOLCHAIN_FILE}" MATCHES "vcpkg.cmake")
    if (APPLE)
        include ("vcpkg-triplets/vcpkg-triplets-mac.cmake")
    elseif (CMAKE_HOST_UNIX)
        include ("vcpkg-triplets/vcpkg-triplets-linux.cmake")
    else()
        include ("vcpkg-triplets/vcpkg-triplets-windows.cmake")
    endif()
endif()

find_package(PNG REQUIRED)

include_directories(${PNG_INCLUDE_DIRS} ${ZLIB_INCLUDE_DIRS})

if(UNIX)
	add_definitions(-DUNIX)
elseif(WIN32)
	add_definitions(-DWIN32)
    if (MSVC)

        # get the number of logical cores for parallel build
        cmake_host_system_information(RESULT LOGICAL_CORES QUERY NUMBER_OF_LOGICAL_CORES)
        math(EXPR COMPILE_CORES "${LOGICAL_CORES} - 1")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /MP${COMPILE_CORES}")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP${COMPILE_CORES}")

        # CRT security and POSIX deprecation warnings
        add_definitions("-D_CRT_SECURE_NO_WARNINGS /wd4996")
    endif()

else()
	message(SEND_ERROR "You are building on unsupported platform")
endif()

set( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)
set( CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_SOURCE_DIR}/bin )
set( CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${CMAKE_SOURCE_DIR}/bin )
set( CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_SOURCE_DIR}/bin )

add_executable(qpakman
    arc_spec.cc 
    u_assert.cc 
    u_file.cc 
    u_util.cc 
    im_color.cc 
    im_image.cc
    im_gen.cc 
    im_mip.cc 
    im_png.cc 
    im_tex.cc 
    archive.cc 
    pakfile.cc 
    main.cc )

target_link_libraries(qpakman ${PNG_LIBRARIES})

set_target_properties(qpakman PROPERTIES DEBUG_POSTFIX "_DEBUG")
set_target_properties(qpakman PROPERTIES RELWITHDEBINFO_POSTFIX "_RELWITHDEBINFO")




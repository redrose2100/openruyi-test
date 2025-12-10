cmake_minimum_required(VERSION 3.10)
project(turbotest_ubturbo_plugin)

file(GLOB TURBOTEST_SRCS
    ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/common/*.cpp
)

add_library(turbotest_ubturbo_plugin SHARED ${TURBOTEST_SRCS})

target_include_directories(turbotest_ubturbo_plugin PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${CMAKE_CURRENT_SOURCE_DIR}/common
        ${UBTURBO_INCLUDE_DIR}
)
set(BOUNDSCHECK_TURBOTEST_LIB /usr/lib64/libboundscheck.so)
target_link_libraries(turbotest_ubturbo_plugin PRIVATE
        ${BOUNDSCHECK_TURBOTEST_LIB}
)

set_target_properties(turbotest_ubturbo_plugin PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

set(BOUNDSCHECK_LIB /usr/lib64/libboundscheck.so)
target_link_libraries(turbotest_ubturbo_plugin PRIVATE ${BOUNDSCHECK_LIB})

file(COPY conf/plugin_turbotest.conf DESTINATION ${CMAKE_BINARY_DIR}/conf
        FILE_PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ)



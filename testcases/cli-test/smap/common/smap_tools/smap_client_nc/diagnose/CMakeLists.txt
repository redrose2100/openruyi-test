aux_source_directory(${CMAKE_CURRENT_LIST_DIR} SMAP_DIAGNOSE_SRCS)

add_library(smap_diagnose STATIC ${SMAP_DIAGNOSE_SRCS})

include_directories(${PROJECT_SOURCE_DIR}/src/user ${PROJECT_SOURCE_DIR}/benchmarks/cli/include)

target_link_libraries(smap_diagnose PUBLIC smap)
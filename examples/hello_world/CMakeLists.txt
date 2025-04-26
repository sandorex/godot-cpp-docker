cmake_minimum_required(VERSION 3.23)

set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Main project information
project(gdextension LANGUAGES CXX VERSION 0.1.0)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build." FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release")
endif()
message(STATUS "Build type set to: ${CMAKE_BUILD_TYPE}")

add_library(${PROJECT_NAME} SHARED)

target_compile_features(${PROJECT_NAME}
    PRIVATE
        cxx_std_20
)

set(LIB_DIR "lib-${CMAKE_CONFIG}/${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}")

set_target_properties(${PROJECT_NAME}
    PROPERTIES
        CXX_VISIBILITY_PRESET hidden
        VISIBILITY_INLINES_HIDDEN true

        # output into the gdextension directory
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/${gdextension}/${LIB_DIR}"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/${gdextension}/${LIB_DIR}"

        DEBUG_POSTFIX "d"
)

set(GODOT_CPP_SYSTEM_HEADERS ON CACHE INTERNAL "")
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../godot-cpp" "${CMAKE_CURRENT_BINARY_DIR}/godot-cpp" EXCLUDE_FROM_ALL)

set_target_properties(godot-cpp PROPERTIES CXX_VISIBILITY_PRESET hidden)

target_sources(${PROJECT_NAME}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/gdextension/register_types.cpp
)

target_include_directories(${PROJECT_NAME}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/gdextension
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        godot-cpp
)


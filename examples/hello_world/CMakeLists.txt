cmake_minimum_required( VERSION 3.23 )
# Turn on link time optimization for everything
set( CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ON )

# Output compile commands to compile_commands.json (for debugging CMake issues)
set( CMAKE_EXPORT_COMPILE_COMMANDS ON )

# Main project information
project( GDExtensionTemplate LANGUAGES CXX VERSION 0.1.0)

# Create our library
add_library( ${PROJECT_NAME} SHARED )

target_compile_features( ${PROJECT_NAME}
    PRIVATE
        cxx_std_17
)

# LIB_DIR is where the actual library ends up. This is used in both the build directory and the
# install directory and needs to be consistent with the paths in the gdextension file.
#   e.g. linux.release.x86_64 = "lib/Linux-x86_64/libGDExtensionTemplate.so"
# set( LIB_DIR "lib/${CMAKE_SYSTEM_NAME}-${LIB_ARCH}" )

# message( STATUS "Building ${PROJECT_NAME} for ${LIB_ARCH} on ${CMAKE_SYSTEM_NAME}")

# BUILD_OUTPUT_DIR is where we put the resulting library (in the build directory)
set( BUILD_OUTPUT_DIR "${PROJECT_BINARY_DIR}/${PROJECT_NAME}/" )

set_target_properties( ${PROJECT_NAME}
    PROPERTIES
        CXX_VISIBILITY_PRESET hidden
        VISIBILITY_INLINES_HIDDEN true
        RUNTIME_OUTPUT_DIRECTORY "${BUILD_OUTPUT_DIR}/${LIB_DIR}"
        LIBRARY_OUTPUT_DIRECTORY "${BUILD_OUTPUT_DIR}/${LIB_DIR}"
)

if( NOT DEFINED CMAKE_DEBUG_POSTFIX )
    set_target_properties( ${PROJECT_NAME}
        PROPERTIES
            DEBUG_POSTFIX "-d"
    )
endif()

# # Copy over additional files from the support_files directory
# add_custom_command(
#     TARGET ${PROJECT_NAME} POST_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_directory
#             "${CMAKE_SOURCE_DIR}/support_files"
#             ${BUILD_OUTPUT_DIR}
# )
# godot-cpp
# From here: https://github.com/godotengine/godot-cpp
if ( NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/godot-cpp/Makefile" )
    message(
        FATAL_ERROR
            "[${PROJECT_NAME}] The godot-cpp submodule was not downloaded. Please update submodules: git submodule update --init --recursive."
    )
endif()

set( GODOT_CPP_SYSTEM_HEADERS ON CACHE BOOL "" FORCE )

add_subdirectory( godot-cpp )

# get_target_property(my_foo_original godot::cpp ALIASED_TARGET)
# message(STATUS "Alias my::foo refers to the target ${my_foo_original}")

set_target_properties( godot-cpp.template_debug PROPERTIES CXX_VISIBILITY_PRESET hidden)

add_subdirectory( "${CMAKE_CURRENT_LIST_DIR}/gdextension" )

target_link_libraries( ${PROJECT_NAME}
    PRIVATE
        godot-cpp.template_debug
)


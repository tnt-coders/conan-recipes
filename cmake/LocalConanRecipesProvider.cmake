include_guard()

# Register this checkout as a Conan local-recipes-index before delegating to cmake-conan.
#
# The recipe root is derived from this provider's location so consuming projects can place this
# repository at any checkout path and only point CMAKE_PROJECT_TOP_LEVEL_INCLUDES at this file.
get_filename_component(LOCAL_CONAN_RECIPES_PROVIDER_DIR "${CMAKE_CURRENT_LIST_DIR}" ABSOLUTE)
get_filename_component(LOCAL_CONAN_RECIPES_ROOT "${LOCAL_CONAN_RECIPES_PROVIDER_DIR}/.." ABSOLUTE)

set(LOCAL_CONAN_RECIPES_REMOTE_NAME
    "local_conan_recipes"
    CACHE STRING "Conan remote name used for the local recipes index")
set(LOCAL_CONAN_RECIPES_CMAKE_CONAN_PROVIDER
    "${CMAKE_SOURCE_DIR}/project-config/cmake-conan/conan_provider.cmake"
    CACHE FILEPATH "Path to the cmake-conan provider included after registering local recipes")
set(LOCAL_CONAN_RECIPES_ALLOWED_PACKAGES
    ""
    CACHE STRING "Optional semicolon-separated Conan package patterns permitted from this index")

find_program(CONAN_COMMAND conan REQUIRED)

set(_local_conan_remote_args
    remote
    add
    "${LOCAL_CONAN_RECIPES_REMOTE_NAME}"
    "${LOCAL_CONAN_RECIPES_ROOT}"
    --index
    0
    --type
    local-recipes-index
    --recipes-only
    --force)

foreach(_allowed_package IN LISTS LOCAL_CONAN_RECIPES_ALLOWED_PACKAGES)
    if(NOT _allowed_package STREQUAL "")
        list(APPEND _local_conan_remote_args --allowed-packages "${_allowed_package}")
    endif()
endforeach()

execute_process(
    COMMAND "${CONAN_COMMAND}" ${_local_conan_remote_args}
    RESULT_VARIABLE LOCAL_CONAN_RECIPES_REMOTE_RESULT
    OUTPUT_VARIABLE LOCAL_CONAN_RECIPES_REMOTE_OUTPUT
    ERROR_VARIABLE LOCAL_CONAN_RECIPES_REMOTE_ERROR
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")

if(NOT LOCAL_CONAN_RECIPES_REMOTE_RESULT EQUAL 0)
    message(FATAL_ERROR "Failed to register local Conan recipes: "
                        "${LOCAL_CONAN_RECIPES_REMOTE_ERROR}")
endif()

if(NOT EXISTS "${LOCAL_CONAN_RECIPES_CMAKE_CONAN_PROVIDER}")
    message(FATAL_ERROR "LOCAL_CONAN_RECIPES_CMAKE_CONAN_PROVIDER does not exist: "
                        "${LOCAL_CONAN_RECIPES_CMAKE_CONAN_PROVIDER}")
endif()

include("${LOCAL_CONAN_RECIPES_CMAKE_CONAN_PROVIDER}")

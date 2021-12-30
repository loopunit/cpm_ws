cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# ---- Project ----

project(
	ocornut_imgui
	VERSION 0.0.0
	LANGUAGES CXX)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
	message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.")
endif()

include(${CPM_DOWNLOAD_LOCATION} REQUIRED)
include(${CPM_WS_SOURCE_DIR}/cmake/cpm_ws.cmake REQUIRED)

message(STATUS "Expect a \'Cache for <XXX> is dirty\' warning")

CPMAddPackage(
	NAME ocornut_imgui
	GITHUB_REPOSITORY ocornut/imgui
	GIT_TAG 31290807dc169d4ee62b16f42bcb1d9a294be93b
	DOWNLOAD_ONLY TRUE)

if(NOT ${ocornut_imgui_ADDED})
	message(FATAL_ERROR "Could not find imgui")
endif()

configure_file(patch_CMakeLists.txt ${ocornut_imgui_SOURCE_DIR}/CMakeLists.txt COPYONLY)
configure_file(patch_imconfig.h ${ocornut_imgui_SOURCE_DIR}/imconfig.h COPYONLY)
configure_file(patch_imconfig.cpp ${ocornut_imgui_SOURCE_DIR}/imconfig.cpp COPYONLY)

set(BUILD_TESTING Off)
add_subdirectory(${ocornut_imgui_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR}/cpm_ws)

CPM_WSInstallTarget("imgui" "staticlib")

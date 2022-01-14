cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# ---- Project ----

project(
	boostorg_leaf
	VERSION 1.0
	LANGUAGES CXX)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
	message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.")
endif()

include(${CPM_DOWNLOAD_LOCATION} REQUIRED)
include(${CPM_WS_SOURCE_DIR}/cmake/cpm_ws.cmake REQUIRED)

if(DEFINED CPM_LOCAL_PACKAGE_DIR)
	set(CPM_boostorg_leaf_SOURCE ${CPM_LOCAL_PACKAGE_DIR} CACHE PATH)
endif()

CPMAddPackage(
	NAME boostorg_leaf
	GITHUB_REPOSITORY boostorg/leaf
	GIT_TAG 0d51eb85ece592c154a8a1515488b50f284eeae5)

CPM_WSInstallTargets(TARGETS leaf)

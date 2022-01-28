cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# ---- Project ----

project(
	loopunit_lu
	VERSION 1.0
	LANGUAGES CXX)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
	message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.")
endif()

include(${CPM_DOWNLOAD_LOCATION} REQUIRED)
include(${CPM_WS_SOURCE_DIR}/cmake/cpm_ws.cmake REQUIRED)

if(DEFINED CPM_LOCAL_PACKAGE_DIR)
	set(CPM_loopunit_lu_SOURCE ${CPM_LOCAL_PACKAGE_DIR} CACHE PATH)
endif()

CPMAddPackage(
	NAME loopunit_lu
	GITHUB_REPOSITORY loopunit/lu
	GIT_TAG 4ba3240742f4d0cdad877134b72aa1c0e439a49f
	OPTIONS
		CPM_WS_BUILD=1)

if(NOT DEFINED CPM_LOCAL_PACKAGE_DIR)
	CPM_WSInstallTargets(
		TARGETS
			lu)
endif()
cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# ---- Project ----

project(
	DiligentGraphics_DiligentEngine
	VERSION 1.0
	LANGUAGES CXX)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
	message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.")
endif()

include(${CPM_DOWNLOAD_LOCATION} REQUIRED)
include(${CPM_WS_SOURCE_DIR}/cmake/cpm_ws.cmake REQUIRED)

if(DEFINED CPM_LOCAL_PACKAGE_DIR)
	set(CPM_DiligentGraphics_DiligentEngine_SOURCE ${CPM_LOCAL_PACKAGE_DIR} CACHE PATH)
endif()

CPMAddPackage(
	NAME DiligentGraphics_DiligentEngine
	GITHUB_REPOSITORY DiligentGraphics/DiligentEngine
	GIT_TAG cd8b04e7d799bf33e084349f39de941963a63287
	OPTIONS
		DILIGENT_BUILD_SAMPLES=Off)

if(NOT DEFINED CPM_LOCAL_PACKAGE_DIR)
	CPM_WSInstallTargets(
		TARGETS
			Diligent-Archiver-shared
			Diligent-GraphicsEngineD3D12-shared)
endif()
if(NOT TARGET DiligentEngine)
	CPM_WSAddPackage(DiligentGraphics DiligentEngine USE_VSTUDIO)
	include(${CPM_WS_INSTALL_CACHE}/DiligentGraphics/DiligentEngine/cpm_ws_package.cmake)
endif()
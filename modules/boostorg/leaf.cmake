if(NOT TARGET boostorg::leaf)
	CPM_WSAddPackage(boostorg leaf)
	include(${CPM_WS_INSTALL_CACHE}/boostorg/leaf/cpm_ws_package.cmake)
endif()
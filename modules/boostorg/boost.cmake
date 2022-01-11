if(NOT TARGET boostorg::leaf)
	CPM_WSAddPackage(boostorg boost)
	include(${CPM_WS_INSTALL_CACHE}/boostorg/boost/cpm_ws_package.cmake)
endif()
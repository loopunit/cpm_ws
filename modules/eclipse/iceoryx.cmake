if(NOT TARGET eclipse_iceoryx)
	CPM_WSAddPackage(eclipse iceoryx)
	include(${CPM_WS_INSTALL_CACHE}/eclipse/iceoryx/cpm_ws_package.cmake)
endif()
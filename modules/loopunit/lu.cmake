if(NOT TARGET lu)
	CPM_WSAddPackage(loopunit lu)
	include(${CPM_WS_INSTALL_CACHE}/loopunit/lu/cpm_ws_package.cmake)

	target_link_libraries(lu 
		INTERFACE 
			boost_config)
endif()
if(NOT TARGET boost_config)
	CPM_WSAddPackage(boostorg boost)
	include(${CPM_WS_INSTALL_CACHE}/boostorg/boost/cpm_ws_package.cmake)

	target_link_libraries(boost_interprocess 
		INTERFACE 
			boost_assert
			boost_config
			boost_container
			boost_core
			boost_static_assert
			boost_throw_exception
			boost_intrusive
			boost_container_hash
			boost_detail
			boost_preprocessor
			boost_type_traits
			boost_integer
			boost_move
			boost_winapi
			boost_predef
			boost_unordered
			boost_smart_ptr
			boost_tuple)
endif()
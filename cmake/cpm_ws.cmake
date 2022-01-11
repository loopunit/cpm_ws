set(CPM_WS_SCRIPTS "${CMAKE_CURRENT_LIST_DIR}")

if(NOT DEFINED CPM_WS_INSTALL_CACHE)
	message(FATAL_ERROR "CPM_WS_INSTALL_CACHE must be configured")
endif()

if(NOT DEFINED CPM_WS_SOURCE_CACHE)
	message(FATAL_ERROR "CPM_WS_SOURCE_CACHE must be configured")
endif()

if(NOT DEFINED CPM_SOURCE_CACHE)
	message(FATAL_ERROR "CPM_SOURCE_CACHE must be configured")
endif()

if(NOT DEFINED CPM_WS_BUILD_CACHE)
	message(FATAL_ERROR "CPM_WS_BUILD_CACHE must be configured")
endif()

if(NOT DEFINED CPM_WS_DEV_ROOT)
	message(FATAL_ERROR "CPM_WS_DEV_ROOT must be configured")
endif()

if(NOT DEFINED CPM_WS_SOURCE_DIR)
	message(FATAL_ERROR "CPM_WS_SOURCE_DIR must be configured")
endif()

function(CPM_WSAddPackage ARG_ORG_NAME ARG_MODULE_NAME)
	set(ARG_MODULE_FULLNAME		"${ARG_ORG_NAME}_${ARG_MODULE_NAME}")
	set(ARG_MODULE_SUBDIR		"${ARG_ORG_NAME}/${ARG_MODULE_NAME}")
	set(ARG_MODULE_DEV_DIR		"${CPM_WS_DEV_ROOT}/${ARG_MODULE_SUBDIR}")
	set(ARG_MODULE_WORKING_DIR	"${CPM_WS_BUILD_CACHE}/${ARG_MODULE_SUBDIR}")
	set(ARG_MODULE_INSTALL_DIR	"${CPM_WS_INSTALL_CACHE}/${ARG_MODULE_SUBDIR}")
	set(ARG_MODULE_DIR			"${CPM_WS_SOURCE_DIR}/modules/${ARG_MODULE_SUBDIR}")
	
	message(STATUS "CPM_WS: ${ARG_MODULE_FULLNAME} via ${ARG_MODULE_DIR}\n Building in ${ARG_MODULE_WORKING_DIR}, installing to ${ARG_MODULE_INSTALL_DIR}")
	
	file(MAKE_DIRECTORY ${ARG_MODULE_WORKING_DIR})

	execute_process(
		COMMAND ${CMAKE_COMMAND}
			-DCMAKE_INSTALL_PREFIX:PATH=${ARG_MODULE_INSTALL_DIR}
			-DCPM_DOWNLOAD_LOCATION:PATH=${CPM_DOWNLOAD_LOCATION}
			-DCPM_SOURCE_CACHE:PATH=${CPM_SOURCE_CACHE}
			-DCPM_WS_SOURCE_DIR:PATH=${CPM_WS_SOURCE_DIR}
			-DCPM_WS_INSTALL_CACHE:PATH=${CPM_WS_INSTALL_CACHE}
			-DCPM_WS_SOURCE_CACHE:PATH=${CPM_WS_SOURCE_CACHE}
			-DCPM_WS_BUILD_CACHE:PATH=${CPM_WS_BUILD_CACHE}
			-DCPM_WS_DEV_ROOT:PATH=${CPM_WS_DEV_ROOT}
			-G Ninja
			-S ${ARG_MODULE_DIR} 
			-B ${ARG_MODULE_WORKING_DIR}
			WORKING_DIRECTORY ${ARG_MODULE_WORKING_DIR})
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} 
			--build .
			--target cpm_ws_install 
			--config ${CMAKE_BUILD_TYPE}
		WORKING_DIRECTORY ${ARG_MODULE_WORKING_DIR})
endfunction()

function(CPM_WSRefPackage ARG_ORG_NAME ARG_MODULE_NAME)
	include("${CPM_WS_SOURCE_DIR}/modules/${ARG_ORG_NAME}/${ARG_MODULE_NAME}.cmake" REQUIRED)
endfunction()

function(CPM_WSInstallTargets)
	set(oneValueArgs)
	set(multiValueArgs TARGETS)
	cmake_parse_arguments(arg "" "${oneValueArgs}" "${multiValueArgs}" "${ARGN}")
	
	#file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/include)
	#file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/lib)
	#file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX}/bin)
	file(WRITE ${CMAKE_INSTALL_PREFIX}/cpm_ws_package.cmake "#\n")

	foreach(targetName ${arg_TARGETS})
		get_target_property(cpm_ws_target_TYPE ${targetName} TYPE)
		get_target_property(cpm_ws_target_BINARY_DIR ${targetName} BINARY_DIR)
		get_target_property(cpm_ws_target_INTERFACE_INCLUDE_DIRECTORIES ${targetName} INTERFACE_INCLUDE_DIRECTORIES)
		get_target_property(cpm_ws_target_COMPILE_DEFINITIONS ${targetName} COMPILE_DEFINITIONS)
		
		# NOTE: can't do this due to a bunch of LINK_ONLY bullshit
		#get_target_property(cpm_ws_target_LINK_LIBRARIES ${targetName} INTERFACE_LINK_LIBRARIES)
		
		unset(targetType)
		unset(_include_args)
		unset(_definition_args)
		unset(_link_libraries_args)

		if(${cpm_ws_target_TYPE} STREQUAL "STATIC_LIBRARY")
			set(targetType "staticlib")
		elseif(${cpm_ws_target_TYPE} STREQUAL "INTERFACE_LIBRARY")
			set(targetType "headerlib")
		#elseif(${cpm_ws_target_TYPE} STREQUAL "MODULE_LIBRARY")
		#	set(targetType "staticlib")
		elseif(${cpm_ws_target_TYPE} STREQUAL "SHARED_LIBRARY")
			set(targetType "dynamiclib")
		elseif(${cpm_ws_target_TYPE} STREQUAL "EXECUTABLE")
			set(targetType "pipelinetool")
		else()
			message(FATAL_ERROR "Cannot determine target type (${cpm_ws_target_TYPE}) of ${targetName}")
		endif()
		
		if(DEFINED cpm_ws_target_INTERFACE_INCLUDE_DIRECTORIES)
			string(
				APPEND _include_args
					"$<JOIN:$<TARGET_PROPERTY:${targetName},INTERFACE_INCLUDE_DIRECTORIES>,,>")
		endif()

		if(DEFINED cpm_ws_target_COMPILE_DEFINITIONS)
			string(
				APPEND _definition_args
					"$<JOIN:$<TARGET_PROPERTY:${targetName},COMPILE_DEFINITIONS>,,>")
		endif()
		
		#if(DEFINED cpm_ws_target_LINK_LIBRARIES)
		#	string(
		#		APPEND _link_libraries_args
		#			"$<JOIN:$<TARGET_PROPERTY:${targetName},INTERFACE_LINK_LIBRARIES>,,>")
		#endif()
		
		if(DEFINED cpm_ws_target_BINARY_DIR AND NOT ${targetType} STREQUAL "headerlib" )
			if (DEFINED _link_libraries_args)
				if(DEFINED _definition_args AND DEFINED _include_args)
					set(optional_args -target_file $<TARGET_FILE:${targetName}> -binary ${cpm_ws_target_BINARY_DIR} -includes ${_include_args} -defines ${_definition_args} -link_libraries ${_link_libraries_args})
				elseif(NOT DEFINED _definition_args AND DEFINED _include_args)
					set(optional_args -target_file $<TARGET_FILE:${targetName}> -binary ${cpm_ws_target_BINARY_DIR} -includes ${_include_args} -link_libraries ${_link_libraries_args})
				elseif(DEFINED _definition_args AND NOT DEFINED _include_args)
					set(optional_args -target_file $<TARGET_FILE:${targetName}> -binary ${cpm_ws_target_BINARY_DIR} -defines ${_definition_args} -link_libraries ${_link_libraries_args})
				elseif(NOT DEFINED _definition_args AND NOT DEFINED _include_args)
					set(optional_args -target_file $<TARGET_FILE:${targetName}> -binary ${cpm_ws_target_BINARY_DIR} -link_libraries ${_link_libraries_args})
				endif()
			else()
				if(DEFINED _definition_args AND DEFINED _include_args)
					set(optional_args -target_file $<TARGET_FILE:${targetName}> -binary ${cpm_ws_target_BINARY_DIR} -includes ${_include_args} -defines ${_definition_args})
				elseif(NOT DEFINED _definition_args AND DEFINED _include_args)
					set(optional_args -target_file $<TARGET_FILE:${targetName}> -binary ${cpm_ws_target_BINARY_DIR} -includes ${_include_args})
				elseif(DEFINED _definition_args AND NOT DEFINED _include_args)
					set(optional_args -target_file $<TARGET_FILE:${targetName}> -binary ${cpm_ws_target_BINARY_DIR} -defines ${_definition_args})
				elseif(NOT DEFINED _definition_args AND NOT DEFINED _include_args)
					set(optional_args -target_file $<TARGET_FILE:${targetName}> -binary ${cpm_ws_target_BINARY_DIR})
				endif()
			endif()
		else()
			if (DEFINED _link_libraries_args)
				if(DEFINED _definition_args AND DEFINED _include_args)
					set(optional_args -includes ${_include_args} -defines ${_definition_args} -link_libraries ${_link_libraries_args})
				elseif(NOT DEFINED _definition_args AND DEFINED _include_args)
					set(optional_args -includes ${_include_args} -link_libraries ${_link_libraries_args})
				elseif(DEFINED _definition_args AND NOT DEFINED _include_args)
					set(optional_args -defines ${_definition_args} -link_libraries ${_link_libraries_args})
				elseif(NOT DEFINED _definition_args AND NOT DEFINED _include_args)
					set(optional_args -link_libraries ${_link_libraries_args})
				endif()
			else()
				if(DEFINED _definition_args AND DEFINED _include_args)
					set(optional_args -includes ${_include_args} -defines ${_definition_args})
				elseif(NOT DEFINED _definition_args AND DEFINED _include_args)
					set(optional_args -includes ${_include_args})
				elseif(DEFINED _definition_args AND NOT DEFINED _include_args)
					set(optional_args -defines ${_definition_args})
				elseif(NOT DEFINED _definition_args AND NOT DEFINED _include_args)
					set(optional_args )
				endif()
			endif()
		endif()

		#message(STATUS "****${optional_args}")
		
		file(APPEND ${CMAKE_INSTALL_PREFIX}/cpm_ws_package.cmake "# ${targetName}\n")
		file(APPEND ${CMAKE_INSTALL_PREFIX}/cpm_ws_package.cmake "include(\"\$\{CMAKE_CURRENT_LIST_DIR\}/cpm_ws_${targetName}.cmake\")\n")

		add_custom_target(
			cpm_ws_install_${targetName}
			ALL
			DEPENDS ${targetName}
			BYPRODUCTS
				${CMAKE_INSTALL_PREFIX}/cpm_ws_${targetName}.cmake
			COMMAND 
				python ${CPM_WS_SOURCE_DIR}/cpm_ws_install.py -install_prefix ${CMAKE_INSTALL_PREFIX} -config ${CMAKE_BUILD_TYPE} -type ${targetType} -name ${targetName} ${optional_args}
			COMMAND_EXPAND_LISTS)
	
		list(APPEND cpm_ws_install_list cpm_ws_install_${targetName})
	endforeach()

	add_custom_target(
		cpm_ws_install
		ALL
		DEPENDS "${cpm_ws_install_list}")

endfunction()

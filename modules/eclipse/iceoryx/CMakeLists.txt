cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# ---- Project ----

project(
	eclipse_iceoryx
	VERSION 1.0.0.0
	LANGUAGES CXX)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
	message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.")
endif()

include(${CPM_DOWNLOAD_LOCATION} REQUIRED)
include(${CPM_WS_SOURCE_DIR}/cmake/cpm_ws.cmake REQUIRED)

if(DEFINED CPM_LOCAL_PACKAGE_DIR)
	set(CPM_eclipse_iceoryx_SOURCE ${CPM_LOCAL_PACKAGE_DIR} CACHE PATH)
	unset(CPM_LOCAL_PACKAGE_DIR)
endif()

CPMAddPackage(
	NAME eclipse_iceoryx
	GITHUB_REPOSITORY eclipse-iceoryx/iceoryx
	GIT_TAG 6c923090e90e2bd354b1ec84f54d7a55bb9e11c7
	DOWNLOAD_ONLY)

########

set(iceoryx_posh_SOURCE_DIR ${eclipse_iceoryx_SOURCE_DIR}/iceoryx_posh)
set(iceoryx_hoofs_SOURCE_DIR ${eclipse_iceoryx_SOURCE_DIR}/iceoryx_hoofs)

include("${iceoryx_hoofs_SOURCE_DIR}/cmake/IceoryxPlatform.cmake")

########

message(STATUS "[i] <<<<<<<<<<<<< Start iceoryx_posh configuration: >>>>>>>>>>>>>")
if(ONE_TO_MANY_ONLY)
     message(STATUS "[i] Using 1:n communication only!")
     set(IOX_COMMUNICATION_POLICY OneToManyPolicy)
endif()

if(NOT IOX_COMMUNICATION_POLICY)
    message(STATUS "[i] Using m:n communication!")
    set(IOX_COMMUNICATION_POLICY ManyToManyPolicy)
endif()

if(NOT IOX_MAX_PUBLISHERS)
    set(IOX_MAX_PUBLISHERS 512)
endif()
message(STATUS "[i] IOX_MAX_PUBLISHERS:" ${IOX_MAX_PUBLISHERS})

if(NOT IOX_MAX_SUBSCRIBERS)
    set(IOX_MAX_SUBSCRIBERS 1024)
endif()
message(STATUS "[i] IOX_MAX_SUBSCRIBERS:" ${IOX_MAX_SUBSCRIBERS})

if(NOT IOX_MAX_INTERFACE_NUMBER)
    set(IOX_MAX_INTERFACE_NUMBER 4)
endif()
message(STATUS "[i] IOX_MAX_INTERFACE_NUMBER:" ${IOX_MAX_INTERFACE_NUMBER})

if(NOT IOX_MAX_SUBSCRIBERS_PER_PUBLISHER)
    set(IOX_MAX_SUBSCRIBERS_PER_PUBLISHER 256)
endif()
message(STATUS "[i] IOX_MAX_SUBSCRIBERS_PER_PUBLISHER:" ${IOX_MAX_SUBSCRIBERS_PER_PUBLISHER})

if(NOT IOX_MAX_CHUNKS_ALLOCATED_PER_PUBLISHER_SIMULTANEOUSLY)
    set(IOX_MAX_CHUNKS_ALLOCATED_PER_PUBLISHER_SIMULTANEOUSLY 8)
endif()
message(STATUS "[i] IOX_MAX_CHUNKS_ALLOCATED_PER_PUBLISHER_SIMULTANEOUSLY:" ${IOX_MAX_CHUNKS_ALLOCATED_PER_PUBLISHER_SIMULTANEOUSLY})

if(NOT IOX_MAX_PUBLISHER_HISTORY)
    set(IOX_MAX_PUBLISHER_HISTORY 16)
endif()
message(STATUS "[i] IOX_MAX_PUBLISHER_HISTORY:" ${IOX_MAX_PUBLISHER_HISTORY})

if(NOT IOX_MAX_CHUNKS_HELD_PER_SUBSCRIBER_SIMULTANEOUSLY)
    set(IOX_MAX_CHUNKS_HELD_PER_SUBSCRIBER_SIMULTANEOUSLY 256)
endif()
message(STATUS "[i] IOX_MAX_CHUNKS_HELD_PER_SUBSCRIBER_SIMULTANEOUSLY:" ${IOX_MAX_CHUNKS_HELD_PER_SUBSCRIBER_SIMULTANEOUSLY})
message(STATUS "[i] <<<<<<<<<<<<<< End iceoryx_posh configuration: >>>>>>>>>>>>>>")

configure_file("${iceoryx_posh_SOURCE_DIR}/cmake/iceoryx_posh_deployment.hpp.in"
  "${CMAKE_BINARY_DIR}/generated/iceoryx/include/iceoryx_posh/iceoryx_posh_deployment.hpp" @ONLY)

execute_process(COMMAND
  git describe --match=None --always --abbrev=40 --dirty
  WORKING_DIRECTORY "${iceoryx_posh_SOURCE_DIR}"
  OUTPUT_VARIABLE ICEORYX_SHA1
  OUTPUT_STRIP_TRAILING_WHITESPACE)

string(TIMESTAMP ICEORYX_BUILDDATE UTC)

set(IOX_VERSION_TWEAK "0")

if(DEFINED ${PROJECT_VERSION_TWEAK})
  set(IOX_VERSION_TWEAK ${PROJECT_VERSION_TWEAK})
endif()

configure_file("${iceoryx_posh_SOURCE_DIR}/cmake/iceoryx_versions.hpp.in"
  "${CMAKE_BINARY_DIR}/generated/iceoryx/include/iceoryx_versions.hpp" @ONLY)

########

add_library(iceoryx_hoofs
    ${iceoryx_hoofs_SOURCE_DIR}/source/concurrent/active_object.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/concurrent/loffli.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/cxx/deadline_timer.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/cxx/helplets.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/cxx/generic_raii.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/cxx/unique_id.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/error_handling/error_handling.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/file_reader/file_reader.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/log/logcommon.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/log/logger.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/log/logging.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/log/logging_internal.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/log/logmanager.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/log/logstream.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/access_control.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/mutex.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/file_lock.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/semaphore.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/timer.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/shared_memory_object.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/signal_handler.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/message_queue.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/named_pipe.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/unix_domain_socket.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/shared_memory_object/allocator.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/shared_memory_object/memory_map.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/shared_memory_object/shared_memory.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/system_configuration.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/posix_access_rights.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/posix_wrapper/thread.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/units/duration.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/relocatable_pointer/base_relative_pointer.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/relocatable_pointer/base_relocatable_pointer.cpp
    ${iceoryx_hoofs_SOURCE_DIR}/source/relocatable_pointer/relative_pointer_data.cpp
)

set_target_properties(iceoryx_hoofs PROPERTIES
    CXX_STANDARD_REQUIRED ON
    CXX_STANDARD ${ICEORYX_CXX_STANDARD}
    POSITION_INDEPENDENT_CODE ON
)

if(LINUX)
    set(ICEORYX_PLATFORM ${iceoryx_hoofs_SOURCE_DIR}/platform/linux/)
    target_link_libraries(iceoryx_hoofs PRIVATE acl atomic ${CODE_COVERAGE_LIBS})
elseif(QNX)
    set(ICEORYX_PLATFORM ${iceoryx_hoofs_SOURCE_DIR}/platform/qnx/)
elseif(APPLE)
    set(ICEORYX_PLATFORM ${iceoryx_hoofs_SOURCE_DIR}/platform/mac/)
elseif(WIN32)
    set(ICEORYX_PLATFORM ${iceoryx_hoofs_SOURCE_DIR}/platform/win/)
else()
    message(WARNING "Could not detect supported platform, but I'm feeling lucky today." )
endif()

# this must be recurse since every platform has potentially different cpp files
file ( GLOB_RECURSE ICEORYX_PLATFORM_FILES
    ${ICEORYX_PLATFORM}/source/*.cpp
)
add_library(iceoryx_platform ${ICEORYX_PLATFORM_FILES})
target_include_directories(iceoryx_platform
    PUBLIC
    $<BUILD_INTERFACE:${ICEORYX_PLATFORM}/include/>
    $<INSTALL_INTERFACE:include>
)

set_target_properties(iceoryx_platform PROPERTIES
    CXX_STANDARD_REQUIRED ON
    CXX_STANDARD ${ICEORYX_CXX_STANDARD}
    POSITION_INDEPENDENT_CODE ON
)

target_compile_options(iceoryx_platform PRIVATE ${ICEORYX_WARNINGS})

if(LINUX)
    target_link_libraries(iceoryx_platform
        PUBLIC
        rt
        pthread
    )
endif(LINUX)

#if(PERFORM_CLANG_TIDY)
#    set_target_properties(
#        iceoryx_hoofs PROPERTIES CXX_CLANG_TIDY "${PERFORM_CLANG_TIDY}"
#    )
#endif(PERFORM_CLANG_TIDY)

if(QNX)
    target_link_libraries(iceoryx_hoofs
        PUBLIC
        iceoryx_platform
        PRIVATE
        socket)
else()
    target_link_libraries(iceoryx_hoofs
        PUBLIC
        iceoryx_platform)
endif(QNX)

target_compile_options(iceoryx_hoofs PRIVATE ${ICEORYX_WARNINGS})

target_include_directories(iceoryx_hoofs
    PUBLIC
    $<BUILD_INTERFACE:${iceoryx_hoofs_SOURCE_DIR}/include>
	$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/generated/iceoryx/include>
    $<INSTALL_INTERFACE:include>
)


###############

add_library(iceoryx_posh
    ${iceoryx_posh_SOURCE_DIR}/source/log/posh_logging.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/capro/capro_message.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/capro/service_description.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/mepoo/chunk_header.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/mepoo/chunk_management.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/mepoo/chunk_settings.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/mepoo/mepoo_config.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/mepoo/segment_config.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/mepoo/memory_manager.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/mepoo/mem_pool.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/mepoo/shared_chunk.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/mepoo/shm_safe_unmanaged_chunk.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/mepoo/segment_manager.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/mepoo/mepoo_segment.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/mepoo/memory_info.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/interface_port.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/interface_port_data.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/application_port.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/application_port_data.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/base_port_data.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/base_port.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/publisher_port_data.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/publisher_port_user.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/publisher_port_roudi.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/subscriber_port_user.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/subscriber_port_roudi.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/subscriber_port_single_producer.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/subscriber_port_multi_producer.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/subscriber_port_data.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/client_port_data.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/client_port_roudi.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/client_port_user.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/server_port_data.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/server_port_roudi.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/ports/server_port_user.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/building_blocks/condition_listener.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/building_blocks/condition_notifier.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/building_blocks/condition_variable_data.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/building_blocks/locking_policy.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/building_blocks/typed_unique_id.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/client_options.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/listener.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/notification_info.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/rpc_header.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/publisher_options.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/subscriber_options.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/trigger.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/trigger_handle.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/popo/user_trigger.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/version/version_info.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/ipc_interface_base.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/ipc_interface_user.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/ipc_interface_creator.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/ipc_runtime_interface.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/ipc_message.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/port_config_info.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/posh_runtime.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/posh_runtime_impl.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/posh_runtime_single_process.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/node.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/node_data.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/node_property.cpp
    ${iceoryx_posh_SOURCE_DIR}/source/runtime/shared_memory_user.cpp)

set_target_properties(iceoryx_posh PROPERTIES
    CXX_STANDARD_REQUIRED ON
    CXX_STANDARD ${ICEORYX_CXX_STANDARD}
    POSITION_INDEPENDENT_CODE ON)

target_include_directories(iceoryx_posh
    PUBLIC
		$<BUILD_INTERFACE:${iceoryx_posh_SOURCE_DIR}/include>
		$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/generated/iceoryx/include>
		$<INSTALL_INTERFACE:include>
    PRIVATE
		${iceoryx_posh_SOURCE_DIR}/source/capro
		${iceoryx_posh_SOURCE_DIR}/source/log
		${iceoryx_posh_SOURCE_DIR}/source/mepoo
		${iceoryx_posh_SOURCE_DIR}/source/popo
		${iceoryx_posh_SOURCE_DIR}/source/version
		${iceoryx_posh_SOURCE_DIR}/source/runtime)

target_link_libraries(iceoryx_posh
    PUBLIC
    iceoryx_hoofs)

target_compile_options(iceoryx_posh PRIVATE ${ICEORYX_WARNINGS})

###############

CPM_WSInstallTargets(TARGETS 
	iceoryx_platform
	iceoryx_hoofs
	iceoryx_posh)

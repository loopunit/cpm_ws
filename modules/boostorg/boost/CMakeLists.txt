cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# ---- Project ----

project(
	boostorg_boost
	VERSION 1.0
	LANGUAGES CXX)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
	message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.")
endif()

include(${CPM_DOWNLOAD_LOCATION} REQUIRED)
include(${CPM_WS_SOURCE_DIR}/cmake/cpm_ws.cmake REQUIRED)

CPMAddPackage(
	NAME boostorg_boost
	GITHUB_REPOSITORY boostorg/boost
	GIT_TAG 789a58b24266a49f6f72b4729a3bba9da10f7bbc
	OPTIONS
		BOOST_ENABLE_PYTHON=On)

CPM_WSInstallTargets(
	TARGETS
		boost_accumulators
		boost_algorithm
		boost_align
		boost_any
		boost_array
		boost_asio
		boost_assert
		boost_assign
		boost_atomic
		boost_beast
		boost_bimap
		boost_bind
		boost_callable_traits
		boost_chrono
		boost_circular_buffer
		boost_compatibility
		boost_compute
		boost_concept_check
		boost_config
		boost_container
		boost_container_hash
		boost_context
		boost_contract
		boost_conversion
		boost_convert
		boost_core
		boost_coroutine
		boost_coroutine2
		boost_crc
		boost_date_time
		boost_describe
		boost_detail
		boost_dll
		boost_dynamic_bitset
		boost_endian
		boost_exception
		boost_fiber
		boost_filesystem
		boost_flyweight
		boost_foreach
		boost_format
		boost_function
		boost_functional
		boost_function_types
		boost_fusion
		boost_geometry
		boost_graph
		boost_hana
		boost_heap
		boost_histogram
		boost_hof
		boost_icl
		boost_integer
		boost_interprocess
		boost_intrusive
		boost_io
		boost_iostreams
		boost_iterator
		boost_json
		boost_lambda
		boost_lambda2
		boost_leaf
		boost_lexical_cast
		boost_locale
		boost_local_function
		boost_lockfree
		boost_log
		boost_logic
		boost_math
		boost_metaparse
		boost_move
		boost_mp11
		boost_mpl
		boost_msm
		boost_multiprecision
		boost_multi_array
		boost_multi_index
		boost_nowide
		boost_numeric_conversion
		boost_numeric_interval
		boost_optional
		boost_outcome
		boost_parameter
		#boost_parameter_python
		boost_pfr
		boost_phoenix
		boost_polygon
		boost_poly_collection
		boost_pool
		boost_predef
		boost_preprocessor
		boost_process
		boost_program_options
		boost_property_map
		boost_property_tree
		boost_proto
		boost_ptr_container
		#boost_python
		boost_qvm
		boost_random
		boost_range
		boost_ratio
		boost_rational
		boost_regex
		boost_safe_numerics
		boost_scope_exit
		boost_serialization
		boost_signals2
		boost_smart_ptr
		boost_sort
		boost_spirit
		boost_stacktrace_noop
		#boost_stacktrace_backtrace
		#boost_stacktrace_addr2line
		#boost_stacktrace_basic
		#boost_stacktrace_windbg
		#boost_stacktrace_windbg_cached
		boost_statechart
		boost_static_assert
		boost_static_string
		boost_stl_interfaces
		boost_system
		boost_thread
		boost_throw_exception
		boost_timer
		boost_tokenizer
		boost_tti
		boost_tuple
		boost_typeof
		boost_type_erasure
		boost_type_index
		boost_type_traits
		boost_units
		boost_unordered
		boost_utility
		boost_uuid
		boost_variant
		boost_variant2
		boost_vmd
		boost_wave
		boost_winapi
		boost_xpressive
		boost_yap)

include(${CMAKE_CURRENT_LIST_DIR}/../utils/cmut__utils__header_guard.cmake)
cmut__utils__define_header_guard()



include(${CMAKE_CURRENT_LIST_DIR}/cmut__install__define_variables.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmut__install__install_config_file.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../utils/cmut__utils__parse_arguments.cmake)


function(cmut__install__install_config_directory)

    cmut__util__parse_arguments(cmut__install__install_config_directory
                                __ARGS
                                ""
                                "DESTINATION"
                                "DIRECTORY"
                                ${ARGN})

    if(__ARGS_DIRECTORY STREQUAL "")
        return()
    endif()


    __cmut__install__define_variables()


    foreach(dir "${__ARGS_DIRECTORY}")

        get_filename_component(absolute_dir ${dir} ABSOLUTE)
        get_filename_component(absolute_parent_dir ${absolute_dir} DIRECTORY)

        file(GLOB_RECURSE files
            LIST_DIRECTORIES false
            "${absolute_dir}/*"
            )

        foreach(f ${files})

            file(RELATIVE_PATH dst_file "${absolute_parent_dir}" "${f}")
            get_filename_component(dst_dir ${dst_file} DIRECTORY)

            cmut__install__install_config_file(
                FILES "${f}"
                DESTINATION "${__ARGS_DESTINATION}/${dst_dir}"
                )

        endforeach()
    endforeach()

endfunction()

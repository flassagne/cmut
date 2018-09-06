
## cmut__qt5__create_translations_file_target( target
##     QT_MODULES Core Multimedia
##     LANGUAGES fr en
##     OUTPUT_FILE_PREFIX path/to/dir/translate_file_prefix
## )
##
## cmut__qt5__create_translations_file_target create custom target to call cmut__qt5__create_translations_file function.
##   cf cmut__qt5__create_translations_file for parameters
##


set(__cmut__qt5__create_translations_file_target__input_script "${CMAKE_CURRENT_LIST_DIR}/cmut__qt5__create_translations_file.cmake.in")


function( cmut__qt5__create_translations_file_target target )

    set(output_file "${CMAKE_CURRENT_BINARY_DIR}/cmut/qt5/cmut__qt5__create_translations_file.cmake")

    cmut__qt5__create_translations_file__parse_argument( cmut__qt5__create_translations_file_target "${ARGN}")


    configure_file(
        "${__cmut__qt5__create_translations_file_target__input_script}"
        "${output_file}"
        @ONLY
        )

    add_custom_target(${target} ALL
        "${CMAKE_COMMAND}" -P "${output_file}"
        BYPRODUCTS "${ARG_OUTPUT_FILE_PREFIX}-done"
        COMMENT "Create Qt translations files"
    )


endfunction()
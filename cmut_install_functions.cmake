#-----------------------------------------------------------------------------
# common install command for simple project
#-----------------------------------------------------------------------------

include( CMakeParseArguments )
include( cmut_parse_functions )
include( cmut_determine_lib_postfix )
include( cmut_define_install_dirs )


# Prototype :
# INSTALL_LIBRARY( TARGET_NAME [ INCLUDE_DIRS include_dir1 [include_dir2 [...]] ]
#                              [ INCLUDE_FILES include_file1 [include_file2 [...]] DEST_DIR destination_directory ]
#                              [ INSTALL_PDB TRUE|FALSE ]
#                              [ COMPONENT component ] )
function( CMUT_INSTALL_LIBRARY TARGET_NAME )

    #set(CMUT_INSTALL_LIBRARY_COMPONENT CMAKE_INSTALL_DEFAULT_COMPONENT_NAME)
    #set(CMUT_INSTALL_LIBRARY_INSTALL_PDB FALSE)
    #
    #set(options INSTALL_PDB)
    #set(oneValueArgs COMPONENT)
    #set(multiValueArgs INCLUDE_DIRS INCLUDE_FILES)
    #cmake_parse_arguments(CMUT_INSTALL_LIBRARY "${options}" "${oneValueArgs}" "${multiValueArgs}")



    set( ARG_LIST ${ARGV} )
    set( TYPES_NAME_ARG_LIST INCLUDE_DIRS INCLUDE_FILES INSTALL_PDB COMPONENT )



    if( NOT DEFINED CMUT_LIB_POSTFIX )
        cmut_determine_lib_postfix()
    endif()

    #-----------------------------------------------------------------------------
    # define install directory
    #-----------------------------------------------------------------------------
    if( NOT CMUT_DEFINE_INSTALL_DIRS_DONE )
        cmut_define_install_dirs()
    endif()


    #-----------------------------------------------------------------------------
    # install target
    #-----------------------------------------------------------------------------
    install(
        TARGETS ${TARGET_NAME}
        RUNTIME DESTINATION ${CMUT_INSTALL_BINDIR}
        LIBRARY DESTINATION ${CMUT_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMUT_INSTALL_ARCHIVEDIR}
    )


    #-----------------------------------------------------------------------------
    # install include directories if required
    #-----------------------------------------------------------------------------
    cmut_parse_args( INCLUDE_DIRS ARG_LIST TYPES_NAME_ARG_LIST INCLUDE_DIRS_TO_INSTALL )
    list( LENGTH INCLUDE_DIRS_TO_INSTALL NUM_INCLUDE_DIRS_TO_INSTALL )
    if( NUM_INCLUDE_DIRS_TO_INSTALL GREATER 0 )
        install( DIRECTORY ${INCLUDE_DIRS_TO_INSTALL} DESTINATION ${CMUT_INSTALL_INCDIR} )
    endif()


    #-----------------------------------------------------------------------------
    # install include files if required
    #-----------------------------------------------------------------------------
    cmut_parse_args( INCLUDE_FILES ARG_LIST TYPES_NAME_ARG_LIST INCLUDE_FILES__ARG_LIST )

    set(INCLUDE_FILES__TYPES_NAME_ARG_LIST INCLUDE_FILES DEST_DIR)
    set(INCLUDE_FILES__ARG_LIST INCLUDE_FILES ${INCLUDE_FILES__ARG_LIST} )
    cmut_parse_args( INCLUDE_FILES INCLUDE_FILES__ARG_LIST INCLUDE_FILES__TYPES_NAME_ARG_LIST INCLUDE_FILES_TO_INSTALL )
    cmut_parse_args( DEST_DIR      INCLUDE_FILES__ARG_LIST INCLUDE_FILES__TYPES_NAME_ARG_LIST CUSTOM_DESTINATION_DIR_NAME )

    list( LENGTH INCLUDE_FILES_TO_INSTALL NUM_INCLUDE_FILES_TO_INSTALL )
    if( NUM_INCLUDE_FILES_TO_INSTALL GREATER 0 )
        set(DESTINATION_DIR ${CMUT_INSTALL_INCDIR})
        if(CUSTOM_DESTINATION_DIR_NAME)
            set(DESTINATION_DIR ${DESTINATION_DIR}/${CUSTOM_DESTINATION_DIR_NAME})
        endif()
        install( FILES ${INCLUDE_FILES_TO_INSTALL} DESTINATION ${DESTINATION_DIR} )
    endif()


    #-----------------------------------------------------------------------------
    # install pdb file if required
    #-----------------------------------------------------------------------------
    if( MSVC )
        cmut_parse_args( INSTALL_PDB ARG_LIST TYPES_NAME_ARG INSTALL_PDB_FILES )
        if( INSTALL_PDB_FILES )
            #get_property( TARGET_LIB_NAME_DEBUG_LOCATION TARGET ${TARGET_NAME} PROPERTY DEBUG_LOCATION )
            # set(TARGET_LIB_NAME_DEBUG_LOCATION $<TARGET_FILE:${TARGET_NAME}>)
            # get_filename_component( DEBUG_PDB_FILE_LOCATION ${TARGET_LIB_NAME_DEBUG_LOCATION} DIRECTORY )
            # get_filename_component( DEBUG_PDB_FILE_NAME ${TARGET_LIB_NAME_DEBUG_LOCATION} NAME_WE )
            # set( DEBUG_PDB_FILE_LOCATION ${DEBUG_PDB_FILE_LOCATION}/${DEBUG_PDB_FILE_NAME}.pdb )
            # can't use property PDB_NAME because it is not set with NMake Makefile Generator ...
            install(
                FILES $<TARGET_FILE_DIR:${TARGET_NAME}>/$<TARGET_PROPERTY:${TARGET_NAME},NAME>$<TARGET_PROPERTY:${TARGET_NAME},DEBUG_POSTFIX>.pdb
                DESTINATION ${CMUT_INSTALL_BINDIR}
                CONFIGURATIONS Debug
            )
        endif()
    endif()

endfunction()


# Prototype :
# CMUT_INSTALL_EXECUTABLE( TARGET_NAME [ INSTALL_PDB ]
#                                      [ COMPONENT component ]
#                                      [ CONFIGURATIONS component ] )
function( CMUT_INSTALL_EXECUTABLE TARGET_NAME )

    set(options INSTALL_PDB)
    set(oneValueArgs COMPONENT)
    set(multiValueArgs "")
    cmake_parse_arguments(CMUT_INSTALL_EXECUTABLE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(CMUT_INSTALL_EXECUTABLE_COMPONENT)
        set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME ${CMUT_INSTALL_EXECUTABLE_COMPONENT})


    #-----------------------------------------------------------------------------
    # define install directory
    #-----------------------------------------------------------------------------
    if( NOT CMUT_DEFINE_INSTALL_DIRS_DONE )
        cmut_define_install_dirs()
    endif()


    #-----------------------------------------------------------------------------
    # install target
    #-----------------------------------------------------------------------------
    install(
        TARGETS ${TARGET_NAME}
        RUNTIME DESTINATION ${CMUT_INSTALL_BINDIR}
    )


    #-----------------------------------------------------------------------------
    # install pdb file if required
    #-----------------------------------------------------------------------------
    if( MSVC )
        if( CMUT_INSTALL_EXECUTABLE_INSTALL_PDB )
            # get_property( TARGET_NAME_DEBUG_LOCATION TARGET ${TARGET_NAME} PROPERTY DEBUG_LOCATION )
            # get_filename_component( DEBUG_PDB_FILE_LOCATION ${TARGET_NAME_DEBUG_LOCATION} PATH )
            # get_filename_component( DEBUG_PDB_FILE_NAME ${TARGET_NAME_DEBUG_LOCATION} NAME_WE )
            # set( DEBUG_PDB_FILE_LOCATION ${DEBUG_PDB_FILE_LOCATION}/${DEBUG_PDB_FILE_NAME}.pdb )
            #MESSAGE("DEBUG_PDB_FILE_LOCATION = ${DEBUG_PDB_FILE_LOCATION}")
            install(
#                FILES $<TARGET_FILE_DIR:${TARGET_NAME}>/$<TARGET_PROPERTY:${TARGET_NAME},NAME>$<TARGET_PROPERTY:${TARGET_NAME},DEBUG_POSTFIX>.pdb
                FILES $<TARGET_FILE_DIR:${TARGET_NAME}>/$<TARGET_PROPERTY:${TARGET_NAME},NAME>$<TARGET_PROPERTY:${TARGET_NAME},DEBUG_POSTFIX>.pdb
                DESTINATION ${CMUT_INSTALL_BINDIR}
                CONFIGURATIONS Debug
            )
        endif()
    endif()

endfunction()



# Prototype :
# INSTALL_LIBRARY_FILE( FILENAME [ COMPONENT component ] )
function( CMUT_INSTALL_LIBRARY_FILE FILENAME )

    if( NOT DEFINED CMUT_LIB_POSTFIX )
        cmut_determine_lib_postfix()
    endif()

    #-----------------------------------------------------------------------------
    # define install directory
    #-----------------------------------------------------------------------------
    if( NOT CMUT_DEFINE_INSTALL_DIRS_DONE )
        cmut_define_install_dirs()
    endif()


    #-----------------------------------------------------------------------------
    # install target
    #-----------------------------------------------------------------------------
    install(
        FILES ${FILENAME}
        DESTINATION ${CMUT_INSTALL_LIBDIR}
    )

endfunction()




macro(cmut_add_install_component_target component dependencies)
    add_custom_target(install_${component} ${CMAKE_COMMAND} -DCOMPONENT=${component} -P ${PROJECT_BINARY_DIR}/cmake_install.cmake)
#    message("dependencies = ${dependencies}")
    foreach(dep ${dependencies})
        add_dependencies(install_${component} ${dep})
    endforeach()
endmacro()



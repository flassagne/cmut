

##--------------------------------------------------------------------------------------------------------------------##
##--------------------------------------------------------------------------------------------------------------------##
##--------------------------------------------------------------------------------------------------------------------##

function(cmut__test__set_property_environment test environment)

    set_tests_properties( ${test} PROPERTIES ENVIRONMENT "${environment}" )

endfunction()

##--------------------------------------------------------------------------------------------------------------------##

function( cmut__test__add_property_environment test environment )

    get_property( is_defined TEST ${test} PROPERTY ENVIRONMENT DEFINED )

    if( is_defined )
        get_tests_properties( ${test} ENVIRONMENT previous_environment )
    endif()

    cmut__test__set_property_environment( ${test} "${previous_environment}" "${environment}" )

endfunction()

##--------------------------------------------------------------------------------------------------------------------##
##--------------------------------------------------------------------------------------------------------------------##
##--------------------------------------------------------------------------------------------------------------------##
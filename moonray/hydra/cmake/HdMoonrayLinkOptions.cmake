
function(HdMoonray_link_options target)
if(NOT APPLE)
        target_link_options(${target}
            PRIVATE
                -Wl,--enable-new-dtags              # Use RUNPATH instead of RPATH
        )
else()
        target_link_options(${target}
            PRIVATE
                -Wl,-ld_classic
        )
endif()
endfunction()


function(MoonrayArras_cxx_compile_features target)
    target_compile_features(${target}
        PRIVATE
            cxx_std_17
    )
endfunction()


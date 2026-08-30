function _load-nixpkg-scripts --description='Automatically load a Nix pkg scripts into the environment' --on-variable=FISH_NIXPKG
    if set --query --export --global -- FISH_NIXPKG
        for init_script in {$FISH_NIXPKG}/share/fish/vendor_conf.d/*
            source -- {$init_script} # source only accepts a single path
        end

        set --global -- _old_function_path {$fish_function_path}
        set --prepend -- fish_function_path {$FISH_NIXPKG}/share/fish/vendor_functions.d

        set --global -- _old_complete_path {$fish_complete_path}
        set --prepend -- fish_complete_path {$FISH_NIXPKG}/share/fish/vendor_completions.d
    else
        set -- fish_function_path {$_old_function_path}
        set --erase --global -- _old_function_path

        set -- fish_complete_path {$_old_complete_path}
        set --erase --global -- _old_complete_path
    end
end

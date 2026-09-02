function _load-nixpkg_add --description='Load a Fish Nixpkg into an environment'
    for init_script in {$FISH_NIXPKG}/share/fish/vendor_conf.d/*
        source -- {$init_script} # source only accepts a single path
    end

    set --global -- _old_function_path {$fish_function_path}
    set --prepend -- fish_function_path {$FISH_NIXPKG}/share/fish/vendor_functions.d

    set --global -- _old_complete_path {$fish_complete_path}
    set --prepend -- fish_complete_path {$FISH_NIXPKG}/share/fish/vendor_completions.d
end

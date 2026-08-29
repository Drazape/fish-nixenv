function _load-nixpkg-scripts --description='Automatically load a Nix pkg scripts into the environment' --on-variable=FISH_DIRENV_SHELLHOOK
    if set --query --export --global -- FISH_DIRENV_SHELLHOOK
        for init_script in {$FISH_DIRENV_SHELLHOOK}/share/fish/vendor_conf.d/*
            source -- {$init_script} # source only accepts a single path
        end
        set --prepend -- fish_function_path {$FISH_DIRENV_SHELLHOOK}/share/fish/vendor_functions.d
        set --prepend -- fish_complete_path {$FISH_DIRENV_SHELLHOOK}/share/fish/vendor_functions.d
    else
        set --local -- funcpath_filter
        for funcpath in {$fish_function_path}
            # doesn't use [1] index incase the path is later further modified
            test {$funcpath} != {$FISH_DIRENV_SHELLHOOK}/share/fish/vendor_functions.d &&
                set --append -- funcpath_filter {$funcpath}
            set -- fish_function_path {$funcpath_filter}
        end
    end
end

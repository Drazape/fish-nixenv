function _load-nixpkg-scripts --description='Automatically load a Nix pkg scripts into the environment' --on-variable=FISH_NIXPKG
    if set --query --export --global -- FISH_NIXPKG
        for init_script in {$FISH_NIXPKG}/share/fish/vendor_conf.d/*
            source -- {$init_script} # source only accepts a single path
        end
        set --prepend -- fish_function_path {$FISH_NIXPKG}/share/fish/vendor_functions.d
        set --prepend -- fish_complete_path {$FISH_NIXPKG}/share/fish/vendor_completions.d
        set --global -- fish_nixpkg_save {$FISH_NIXPKG}
    else
        for component in functions completions
            set --local -- fish_path
            switch {$component}
                case functions
                    set -- fish_path fish_function_path
                case completions
                    set -- fish_path fish_complete_path
            end
            for component_path in {$$fish_path}
                set --local -- path_filter
                # doesn't use [1] index incase the path is later further modified
                test {$component_path} != {$fish_nixpkg_save}/share/fish/vendor_{$component}.d &&
                    set --append -- path_filter {$component_path}
                set -- {$fish_path} {$path_filter}
            end
        end
        set --erase --global -- fish_nixpkg_save
    end
end

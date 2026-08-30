function _run-nixpkg-hooks --description='Automatically manage a Nix pkg environment' --on-variable=FISH_{NIXPKG,DIRENV_HOOKS}
    set --global -- _fish_current_nixpkg_name (string split --fields=2 --max=1 -- - {$FISH_NIXPKG}) # checked by `add` hooks
    if set --query --export --global -- FISH_DIRENV_HOOKS || set --query --export --global -- FISH_NIXPKG
        set --query --export --global -- FISH_DIRENV_HOOKS && source -- {$FISH_DIRENV_HOOKS}
        if set --query --global -- _nixpkg_fish_loaded
            emit -- nixpkg-hook-remove
            emit -- nixpkg-hook-add
        else
            emit -- nixpkg-hook-add
            set --global -- _nixpkg_fish_loaded
        end
    else
        emit -- nixpkg-hook-remove
        set --erase --global -- _nixpkg_fish_loaded
    end
    set --global -- _fish_previous_nixpkg_name (string split --fields=2 --max=1 -- - {$FISH_NIXPKG}) # checked by `remove` hooks
end

# universal hooks
function _load-nixpkg-scripts_add --description='Load a Fish Nixpkg into an environment' --on-event=nixpkg-hook-add
    for init_script in {$FISH_NIXPKG}/share/fish/vendor_conf.d/*
        source -- {$init_script} # source only accepts a single path
    end

    set --global -- _old_function_path {$fish_function_path}
    set --prepend -- fish_function_path {$FISH_NIXPKG}/share/fish/vendor_functions.d

    set --global -- _old_complete_path {$fish_complete_path}
    set --prepend -- fish_complete_path {$FISH_NIXPKG}/share/fish/vendor_completions.d
end
function _load-nixpkg-scripts_remove --description='Erase a Fish Nixpkg from an environment' --on-event=nixpkg-hook-remove
    set -- fish_function_path {$_old_function_path}
    set --erase --global -- _old_function_path

    set -- fish_complete_path {$_old_complete_path}
    set --erase --global -- _old_complete_path
end

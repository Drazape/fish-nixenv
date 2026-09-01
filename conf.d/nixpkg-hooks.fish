function _run-nixpkg-hooks --description='Automatically manage a Nix pkg environment' --on-variable=FISH_{NIXPKG,DIRENV_HOOKS}
    if set --query --export --global -- FISH_DIRENV_HOOKS || set --query --export --global -- FISH_NIXPKG
        set --query --export --global -- FISH_DIRENV_HOOKS && source -- {$FISH_DIRENV_HOOKS}
        if set --query --global -- _nixpkg_fish_loaded
            emit -- direnv-hook-remove
            _load-nixpkg-scripts_remove
            _load-nixpkg-scripts_add
        else
            _load-nixpkg-scripts_add
        end
    else
        emit -- direnv-hook-remove
        _load-nixpkg-scripts_remove
    end
end

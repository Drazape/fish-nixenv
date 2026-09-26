function _load-nixpkg --description='Automatically manage a Nix pkg environment' --on-variable=FISH_NIXPKG
    if set --query --export --global -- FISH_NIXPKG
        if set --query --global -- _nixpkg_fish_loaded
            echo 'switching the Fish plugin currently loaded in the environment'
            _load-nixpkg_remove
            _run-direnv-scripts # trigger change hooks
        end
        echo 'loading Fish plugin provided by the current repository'
        _load-nixpkg_add
        set --global -- _nixpkg_fish_loaded
    else
        echo 'removing Fish plugin provided by the current repository'
        _load-nixpkg_remove
        set --erase --global -- _nixpkg_fish_loaded
    end
end

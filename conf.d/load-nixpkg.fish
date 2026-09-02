function _load-nixpkg --description='Automatically manage a Nix pkg environment' --on-variable=FISH_NIXPKG
    if set --query --export --global -- FISH_NIXPKG
        set --query --global -- _nixpkg_fish_loaded && _load-nixpkg_remove
        _load-nixpkg_add
        set --global -- _nixpkg_fish_loaded
    else
        _load-nixpkg_remove
        set --erase --global -- _nixpkg_fish_loaded
    end
end

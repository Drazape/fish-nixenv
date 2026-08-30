function _load-nixpkg-scripts --description='Automatically manage a Nix pkg environment' --on-variable=FISH_NIXPKG
    set --function -- funcscope (status current-function)_
    if set --query --export --global -- FISH_NIXPKG
        if set --query --global -- _nixpkg_fish_loaded
            "$funcscope"remove
            "$funcscope"add
        else
            "$funcscope"add
        end
    else
        "$funcscope"remove
    end
end

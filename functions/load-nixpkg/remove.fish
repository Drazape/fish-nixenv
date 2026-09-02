function _load-nixpkg_remove --description='Erase a Fish Nixpkg from an environment' --on-event=nixpkg-hook-remove
    set -- fish_function_path {$_old_function_path}
    set --erase --global -- _old_function_path

    set -- fish_complete_path {$_old_complete_path}
    set --erase --global -- _old_complete_path
end

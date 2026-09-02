function _run-direnv-hooks --description='Automatically manage direnv hooks' --on-variable=FISH_DIRENV_HOOKS
    if set --query --export --global -- FISH_DIRENV_HOOKS
        set --query --global -- _fish_plugin_remover && $_fish_plugin_remover
        set --erase --global -- _fish_plugin_remover
        source -- {$FISH_DIRENV_HOOKS}
    else
        $_fish_plugin_remover
    end
end

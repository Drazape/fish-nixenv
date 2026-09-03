function _run-direnv-scripts --description='Automatically manage direnv hooks' --on-variable=FISH_DIRENV_HOOKS
    if set --query --export --global -- FISH_DIRENV_HOOKS
        if set --query --global -- _fish_plugin_changer
            $_fish_plugin_changer
            set --erase --global -- _fish_plugin_changer
        else
            _run-direnv-scripts_trigger-remove
        end
        source -- {$FISH_DIRENV_HOOKS}
    else
        _run-direnv-scripts_trigger-remove
    end
end

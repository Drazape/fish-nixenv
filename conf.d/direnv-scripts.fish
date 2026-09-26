function _run-direnv-scripts --description='Automatically manage direnv hooks' --on-variable=FISH_DIRENV_HOOKS
    set --function -- log_prefix (set_color --dim)'fish-nixenv: arbitrary:'(set_color --reset)
    if set --query --export --global -- FISH_DIRENV_HOOKS
        if set --query --global -- _fish_plugin_changer
            echo {$log_prefix} 'switching Fish plugin repository'
            $_fish_plugin_changer
            set --erase --global -- _fish_plugin_changer
        else
            _run-direnv-scripts_trigger-remove {$log_prefix}
        end
        echo {$log_prefix} 'creating Fish plugin development environment'
        source -- {$FISH_DIRENV_HOOKS}
    else
        _run-direnv-scripts_trigger-remove {$log_prefix}
    end
end

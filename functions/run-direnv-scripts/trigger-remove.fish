function _run-direnv-scripts_trigger-remove --argument-names=log_prefix --description='Trigger remove hook once, if set'
    if set --query --global -- _fish_plugin_remover
        echo {$log_prefix} 'removing the Fish plugin development environment'
        $_fish_plugin_remover
        set --erase --global -- _fish_plugin_remover
    end
end

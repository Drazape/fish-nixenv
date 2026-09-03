function _run-direnv-scripts_trigger-remove --description='Trigger remove hook once, if set'
    if set --query --global -- _fish_plugin_remover
        $_fish_plugin_remover
        set --erase --global -- _fish_plugin_remover
    end
end

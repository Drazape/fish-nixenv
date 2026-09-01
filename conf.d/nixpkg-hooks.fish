function _run-direnv-hooks --description='Automatically manage direnv hooks' --on-variable=FISH_DIRENV_HOOKS
    if set --query --export --global -- FISH_DIRENV_HOOKS
        source -- {$FISH_DIRENV_HOOKS}
    else
        emit -- direnv-hook-remove
    end
end

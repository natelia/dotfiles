if status is-interactive
    # Disable flow control to allow ctrl+s and ctrl+q in terminal apps.
    stty -ixon -ixoff 2>/dev/null
end

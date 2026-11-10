if status is-interactive
    # Disable flow control to allow ctrl+s and ctrl+q in terminal apps.
    stty -ixon -ixoff 2>/dev/null

    # Show system info in top-level terminal shells only (not nested, not tmux).
    if not set -q TMUX; and test "$SHLVL" -le 2
        fastfetch
    end
end

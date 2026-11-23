function dotfiles_load_session -d "Load Home Manager session variables"
    set -l session_vars "$HOME/.local/state/home-manager/gcroots/current-home/home-path/etc/profile.d/hm-session-vars.sh"
    if not test -f "$session_vars"
        set session_vars "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
    end
    test -f "$session_vars"; or return 0

    set -l session_keys
    for line in (string match -r '^export [A-Za-z_][A-Za-z0-9_]*=' <"$session_vars")
        set -l assignment (string replace -r '^export ' '' -- $line)
        set -a session_keys (string split -m1 '=' -- $assignment)[1]
    end
    test (count $session_keys) -gt 0; or return 0

    # Import only Home Manager's exports, leaving shell-local state untouched.
    set -l session_environment (env -u __HM_SESS_VARS_SOURCED bash --noprofile --norc -c 'source "$1" >/dev/null && env' bash "$session_vars")
    or return $status

    for line in $session_environment
        set -l key (string split -m1 '=' -- $line)[1]
        if contains -- $key $session_keys
            set -l value (string split -m1 '=' -- $line)[2]
            set -gx $key $value
        end
    end
end

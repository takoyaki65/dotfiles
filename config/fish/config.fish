# define XDG paths
set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME || set -gx XDG_CACHE_HOME $HOME/.cache

# Source home-manager session variables
set -l HM_SESSION_VARS "$HOME/.local/state/home-manager/gcroots/current-home/home-path/etc/profile.d/hm-session-vars.sh"
if not test -f $HM_SESSION_VARS
    set HM_SESSION_VARS "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
end
if test -f $HM_SESSION_VARS
    set -l hm_session_keys
    for line in (string match -r '^export [A-Za-z_][A-Za-z0-9_]*=' <$HM_SESSION_VARS)
        set -l assignment (string replace -r '^export ' '' -- $line)
        set -a hm_session_keys (string split -m1 '=' -- $assignment)[1]
    end

    if test (count $hm_session_keys) -gt 0
        for line in (env -u __HM_SESS_VARS_SOURCED bash --noprofile --norc -c 'source "$1" >/dev/null; env' bash $HM_SESSION_VARS)
            set -l key (string split -m1 '=' -- $line)[1]
            if contains -- $key $hm_session_keys
                set -l value (string split -m1 '=' -- $line)[2]
                set -gx $key $value
            end
        end
    end
end

# define fish config paths
set -g FISH_CONFIG_DIR $XDG_CONFIG_HOME/fish
set -g FISH_CONFIG $FISH_CONFIG_DIR/config.fish
set -g FISH_CACHE_DIR /tmp/fish-cache

# Add home-manager packages to PATH
# Prefer the standalone home-manager gcroots (Linux / `home-manager switch`),
# falling back to the nix-darwin module profile (`/etc/profiles/per-user`).
set -l HM_PATH_BIN "$HOME/.local/state/home-manager/gcroots/current-home/home-path/bin"
if not test -d $HM_PATH_BIN
    set HM_PATH_BIN "/etc/profiles/per-user/$USER/bin"
end
fish_add_path $HM_PATH_BIN

set -l CONFIG_CACHE $FISH_CACHE_DIR/config.fish
if not test -f "$CONFIG_CACHE"; or test "$FISH_CONFIG" -nt "$CONFIG_CACHE"
    mkdir -p $FISH_CACHE_DIR

    # Build the cache in a per-process temp file and swap it into place with
    # `mv` only once fully written, so an interrupted shell never leaves a
    # truncated cache that silently drops direnv/starship/zoxide.
    set -l CONFIG_CACHE_TMP $CONFIG_CACHE.tmp.$fish_pid
    echo '' >$CONFIG_CACHE_TMP

    # tools (trailing echo: some inits end without a newline, which would
    # concatenate with the next entry and corrupt the cache)
    ensure_installed direnv hook fish >>$CONFIG_CACHE_TMP
    echo >>$CONFIG_CACHE_TMP
    ensure_installed starship init fish >>$CONFIG_CACHE_TMP
    echo >>$CONFIG_CACHE_TMP
    ensure_installed zoxide init fish >>$CONFIG_CACHE_TMP

    mv -f $CONFIG_CACHE_TMP $CONFIG_CACHE

    set_color brmagenta --bold --underline
    echo "config cache updated"
    set_color normal
end
source $CONFIG_CACHE

if not status is-interactive; and command -q direnv
    direnv export fish | source
end

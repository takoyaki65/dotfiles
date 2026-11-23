set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME || set -gx XDG_CACHE_HOME $HOME/.cache

dotfiles_load_session; or echo "Failed to load Home Manager session variables" >&2

if status is-interactive; and test (uname) = Darwin
    if test -x /opt/homebrew/bin/brew
        eval "$(/opt/homebrew/bin/brew shellenv fish)"
    end
    set -gx SSH_SK_PROVIDER /usr/lib/ssh-keychain.dylib
end

# Prefer the standalone Home Manager profile, falling back to nix-darwin's profile.
set -l home_bin "$HOME/.local/state/home-manager/gcroots/current-home/home-path/bin"
if not test -d "$home_bin"
    set home_bin "/etc/profiles/per-user/$USER/bin"
end
fish_add_path --path "$home_bin"

if status is-interactive
    set -g fish_greeting
    set -gx theme_nerd_fonts yes

    if command -q vivid
        set -gx LS_COLORS (vivid generate tokyonight-night)
    end

    alias del trash
    alias delete trash

    if command -q direnv
        direnv hook fish | source
    end
    if command -q starship
        starship init fish | source
    end
    if command -q zoxide
        zoxide init fish | source
    end
else if command -q direnv
    direnv export fish | source
end

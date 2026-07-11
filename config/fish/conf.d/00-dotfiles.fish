# Sourced automatically by fish (conf.d). Runs BEFORE config.fish.
status is-interactive; or exit

# Disable greeting
set -g fish_greeting

# Nerd Fonts (UDEV Gothic NF) for themes/prompts
set -gx theme_nerd_fonts yes

# LS_COLORS via vivid
# conf.d runs before home-manager's config.fish (hm-session-vars), so guard
# against launch paths where the Nix profile is not on PATH yet
if type -q vivid
    set -gx LS_COLORS (vivid generate tokyonight-night)
end

# macOS: Homebrew & SSH SK provider
if test (uname) = Darwin
    if test -x /opt/homebrew/bin/brew
        eval "$(/opt/homebrew/bin/brew shellenv fish)"
    end
    set -gx SSH_SK_PROVIDER /usr/lib/ssh-keychain.dylib
end

# Aliases
alias del trash
alias delete trash

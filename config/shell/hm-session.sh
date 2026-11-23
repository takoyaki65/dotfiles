# Source home-manager session variables
HM_SESSION_VARS="$HOME/.local/state/home-manager/gcroots/current-home/home-path/etc/profile.d/hm-session-vars.sh"
if [ ! -f "$HM_SESSION_VARS" ]; then
    HM_SESSION_VARS="/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
fi
if [ -f "$HM_SESSION_VARS" ]; then
    . "$HM_SESSION_VARS"
fi
unset HM_SESSION_VARS

# Add home-manager packages to PATH
HM_PATH_BIN="$HOME/.local/state/home-manager/gcroots/current-home/home-path/bin"
if [ ! -d "$HM_PATH_BIN" ]; then
    HM_PATH_BIN="/etc/profiles/per-user/$USER/bin"
fi
case ":$PATH:" in
*":$HM_PATH_BIN:"*) ;;
*) PATH="$HM_PATH_BIN:$PATH" ;;
esac
export PATH
unset HM_PATH_BIN

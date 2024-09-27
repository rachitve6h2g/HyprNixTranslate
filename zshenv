# Environment variables
. "/etc/profiles/per-user/chris/etc/profile.d/hm-session-vars.sh"

# Only source this once
if [[ -z "$__HM_ZSH_SESS_VARS_SOURCED" ]]; then
  export __HM_ZSH_SESS_VARS_SOURCED=1
  
fi

ZSH="/nix/store/va5w2n9s8s4700pwfjf8ykxy3sgcb9mk-oh-my-zsh-2024-09-01/share/oh-my-zsh";
ZSH_CACHE_DIR="/home/chris/.cache/oh-my-zsh";

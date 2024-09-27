

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

alias ..='cd ..'
alias backit='cp -r /etc/nixos/* /home/chris/.dotfiles/NixDots/'
alias ll='ls -l'
alias svi='sudo vim'
alias syscon='cd /etc/nixos/'
alias update='sudo nixos-rebuild switch'

if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/k0ag90vp8qszsd1y85b0vq8dwvkxzjz9-bash-completion-2.14.0/etc/profile.d/bash_completion.sh"
fi

export WLR_NO_HARDWARE_CURSORS="1";

# # Start the SSH agent if it's not already running
# if [ -z "$SSH_AUTH_SOCK" ]; then
#     eval "$(ssh-agent -s)" > /dev/null
# fi
#
# # Add SSH key only if it's not already added
# if ! ssh-add -l | grep -q "$(ssh-keygen -lf ~/.ssh/id_ed25519 | awk '{print $2}')"; then
#     ssh-add ~/.ssh/id_ed25519 > /dev/null
# fi

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

GPG_TTY="$(tty)"
export GPG_TTY
/nix/store/3l2rsi089jdwk17kmcpwwfbig8437lm9-gnupg-2.4.5/bin/gpg-connect-agent updatestartuptty /bye > /dev/null

function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi


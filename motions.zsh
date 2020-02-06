#!/usr/bin/env zsh
# {{{ Handle fpath/$0
# ref: zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html#zero-handling
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
fpath+=( "${0:h}/functions" )
autoload -Uz select-quoted select-bracketed split-shell-arguments surround \
	vi-forward-shell-word select-command
# }}}

# More text objects from zsh/functions/Zle
zle -N select-quoted
zle -N select-bracketed
for m in vicmd viopp; do
	for seq in {a,i}{\',\",\`}; do
		bindkey -M "$m" "$seq" select-quoted
	done
	for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
		bindkey -M $m $c select-bracketed
	done
done

# Load Vi-surround from zsh/functions/Zle
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

# Add forward/backward-shell-word
zle -N vi-forward-shell-word
zle -N vi-backward-shell-word     vi-forward-shell-word
zle -N vi-forward-shell-word-end  vi-forward-shell-word
zle -N vi-backward-shell-word-end vi-forward-shell-word

## Add the following to your zshrc to overwrite the normal
## (forward|backward)-blank-word bindings:
#for m in vicmd visual; do
#	bindkey -M "$m" 'W'  vi-forward-shell-word
#	bindkey -M "$m" 'B'  vi-backward-shell-word
#	bindkey -M "$m" 'E'  vi-forward-shell-word-end
#	bindkey -M "$m" 'gE' vi-backward-shell-word-end
#done
## You may also want to swap select-(in|a)-shell-word bindings
## with select-(in|a)-blank-word bindings
#bindkey -M viopp aW select-a-shell-word
#bindkey -M viopp iW select-in-shell-word
#bindkey -M viopp aa select-a-blank-word
#bindkey -M viopp ia select-in-blank-word

#!/usr/bin/env zsh
fpath+="${0:h}"

# More text objects from zsh/functions/Zle
autoload -Uz select-quoted select-bracketed
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
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

# Add forward/backward-shell-word
autoload -Uz vi-forward-shell-word
vi-backward-shell-word(){ vi-forward-shell-word b }
zle -N vi-forward-shell-word
zle -N vi-backward-shell-word
# Add the following to your zshrc to overwrite the normal
# forward-black-word and backward-blank-word bindings
#for m in vicmd visual; do
#	bindkey -M "$m" 'W' vi-forward-shell-word
#	bindkey -M "$m" 'B' vi-backward-shell-word
#done

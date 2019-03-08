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


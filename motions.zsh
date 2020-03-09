#!/usr/bin/env zsh
# {{{ Handle fpath/$0
# ref: zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html#zero-handling
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
fpath+=( "${0:h}/functions" )
autoload -Uz select-quoted select-bracketed split-shell-arguments surround \
	vi-forward-shell-word vi-forward-command select-a-command \
	vi-forced-motion
# }}}

local m seq

# Bind Home/End
bindkey -M vicmd '^[[H' vi-beginning-of-line
bindkey -M viins '^[[H' beginning-of-line
bindkey -M vicmd '^[[F' vi-end-of-line
bindkey -M viins '^[[F' end-of-line

# Forced motion
zle -N vi-forced-motion
bindkey -M viopp v vi-forced-motion

# More text objects from zsh/functions/Zle
zle -N select-quoted
zle -N select-bracketed
for m in vicmd viopp; do
	for seq in {a,i}{\',\",\`}; do
		bindkey -M "$m" "$seq" select-quoted
	done
	for seq in {a,i}${(s..)^:-'()[]{}<>bB'}; do
		bindkey -M "$m" "$seq" select-bracketed
	done
done

# Load Vi-surround from zsh/functions/Zle
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround ds delete-surround ys add-surround
bindkey -M visual S add-surround

# Add forward/backward-command
zle -N vi-forward-command
zle -N vi-backward-command     vi-forward-command
zle -N vi-forward-command-end  vi-forward-command
zle -N vi-backward-command-end vi-forward-command
for m in vicmd viopp visual; do
	bindkey -M "$m" ')' vi-forward-command '(' vi-backward-command \
		'g)' vi-forward-command-end 'g(' vi-backward-command-end
done

# Add select-(in|a)-command
zle -N select-a-command
zle -N select-in-command select-a-command
for m in vicmd viopp; do
	bindkey -M "$m" 'as' select-a-command 'aS' select-a-command \
		'is' select-in-command 'iS' select-in-command
done

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

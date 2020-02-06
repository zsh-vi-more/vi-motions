#!/usr/bin/env zsh
source ./motions.zsh

# do nothing when calling zle
zle() :
ret=0

# {{{ select-command
c='simple command '
lefts=(
	#'never include' 'include in "a"'
	'' ''
	'' 'if '
	"$c;" ''
	"$c;" ' '
	"$c;" ' if '
)
rights=(
	#'include in "a"' 'never include'
	'' ''
	'' ''
	'&&' ''
	'&& ' ''
	'&&' "$c"
	'&& ' "$c"
)

for ll lm ("${(@)lefts}") {
	for rm rr ("${(@)rights}") {
		((
		iCURSOR = $#ll + $#lm,
		aCURSOR = $#ll,
		cur     = 3 + iCURSOR,
		iMARK   = $#ll + $#lm + $#c,
		aMARK   = iMARK + $#rm
		))
		BUFFER="$ll$lm$c$rm$rr"

		CURSOR=$cur
		KEYS=ac select-command
		if (( aCURSOR != CURSOR || aMARK != MARK )); then
			print -l 'In "select-command" test:' \
				"BUFFER:$BUFFER:" \
				"[a]   :$aCURSOR:$CURSOR::$aMARK:$MARK" \
				"ACTUAL:${BUFFER[CURSOR+1,MARK]}" \
				"INTEND:${BUFFER[aCURSOR+1,aMARK]}"
			ret=1
		fi

		CURSOR=$cur
		KEYS=ic select-command
		if (( iCURSOR != CURSOR || iMARK != MARK )); then
			print -l 'In "select-command" test:' \
				"BUFFER:$BUFFER:" \
				"[i]   :$iCURSOR:$CURSOR::$iMARK:$MARK" \
				"ACTUAL:${BUFFER[CURSOR+1,MARK]}:" \
				"INTEND:${BUFFER[iCURSOR+1,iMARK]}:"
			ret=1
		fi
	}
}

# }}}
return $ret

#!/usr/bin/env bash
set -e

# ensure that all files listed in REPO exist, and any extras to check for

# basic files expected for every port
FILES=( Pkgfile .footprint .md5sum )

httpuprepo() {
	#local rex="$(printf '\nf:\1/%s' "$@")"
	local rex=''
	sed -nre '
		/^f:/ s|^f:([^:]+):(.+)$|f:\2|p
		/^d:/ s|^d:(.+)$|d:\1'"$rex"'|p
	' REPO \
	| sort -u \
	| (
		n=0
		while IFS=: read -r k v; do
			e=
			case "$k" in
				f|d) [ -$k "$v" ] || e="$v" ;;
				*)   e="$k${v:+:$v}"        ;;
			esac
			[ -z "$e" ] || {
				printf '%s\n' "$e"
				let ++n
			}
		done
		[ $n -eq 0 ] ; exit $?
	)
}

gitrepo() {
	git ls-tree --name-only --full-name HEAD \
	| sort -u \
	| (
		n=0
		while IFS= read -r i; do
			if [ -d "$i" ]; then
				for j in "${FILES[@]}"; do
					[ -f "${i}/${j}" ] || {
						printf '%s\n' "${i}/${j}"
						let ++n
					}
				done
			fi
		done
		[ $n -eq 0 ] ; exit $?
	)
}

rc=0
httpuprepo || let ++rc
gitrepo || let ++rc

exit $rc

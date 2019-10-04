#!/usr/bin/env bash
set -e

# list of ports in the current dir that need to be `pkgmk`d
needsmk() {
	find . -maxdepth 1 -mindepth 1 -type d \( \! -name '.*' \) \
	      -execdir sh -c '
	      	cd "$1" && [ -e .md5sum ] && [ -e .footprint ] || echo "${1#./}"
	      ' -- {} \;
}

depsort() {
	local pkgs=( $(needsmk) )
	[ ${#pkgs[@]} -gt 0 ] || return 0
	printf '%s\n' $(prt-get quickdep "${pkgs[@]}") \
	| grep -Fx -f <(printf '%s\n' "${pkgs[@]}")
}

# -l option to just list the ports in depsort order, without building anything
[ "$1" = "-l" ] && { depsort; exit 0; }

# this ought to get them to us in such an order that ports which
# depend on other ports are listed after their dependencies
depsort \
| while IFS= read -r i; do
	act='-u'
	pkginfo -l $i >/dev/null || act='-i'
	( cd $i && pkgmk -d && pkgmk $act ) || {
		printf '\noops: %s\n' $i >&2
		exit 1
	}
	echo
done

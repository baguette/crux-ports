#!/usr/bin/env bash
###
### finddeps.sh <objfile>
###
### find packages that a given executable or shared object
### (dynamic library) depends on;  i.e., packages that own
### other libraries that this object is linked against.
###
### NOTE - only works for x86/x86-64...
###
### ALSO NOTE - doesn't (currently) operate recursively onto
###             object files owned by dependency packages; it
###             merely lists the packages that own whatever
###             libraries the given file links against *directly*
###             (this also means that if a program uses something
###             like 'dlopen(3)' to load a library at runtime,
###             such dependencies will not be detected (in fact,
###             afaict, they cannot, in general)).
###
### TODO - add recursive lookup mode to search for dependencies
###        of further object files owned by dependencies, such
###        that the full set might be found in one go.
###

objarch() {
	objdump -f "$1" \
	| sed -nre '
		s/^\s*architecture:\s+i.86.([^, ]*)[, ].*$/\1/p
	'
}

# XXX - probably a better way to do this...
x64p() {
	objdump -f "$1" \
	| grep -q -Ee '^\s*architecture:\s+i.86:x86-64'
}

sonames() {
	objdump -p "$1" \
	| grep -Ee '\bNEEDED\b' \
	| awk '{print $2}' \
	| sort -u
}

ldcache() {
	# XXX - see above.
	# `op` be the `awk` operator for regex match (`~`)
	# if the so platform is 64-bit (x86-64);  otherwise,
	# `op` be the operator for regex unmatch (`!~`).
	local op='~'
	x64p "$1" || op='!~'

	ldconfig -p \
	| sed -nre '
		s/^\s+(\S+)\s+\(([^)]+)\)\s+=>\s+(.+)$/\1\t\2\t\3/p
	'| awk -F$'\t' -v OFS=$'\t' '
		{
			if ($2 ~ /x86-64/) {
				print $1, $3
			}
		}
	' \
	| sort -t $'\t' -k 1,1 -k 2,2 -u
}

sofiles() {
	join -j 1 -t $'\t' -o 2.2 <(sonames "$1") <(ldcache "$1") \
	|sort -u
}

pkgs() {
	sofiles "$1" \
	| while IFS= read -r i; do
	    pkginfo -o "$i" 2>/dev/null
	  done \
	| grep -Eve '^Package\b' \
	| awk '{print $1}' \
	| sort -u
}



### MAIN PROGRAM ###

[ -n "$1" ] || {
	echo "usage: ${0##*/} <objfile>"
	exit 1
} >&2

pkgs "$1"
exit $?

#!/usr/bin/env bash
#
# clean up any bullshit libtool archive files (`*.la` files)
# cuz they cause more trouble than anything, and they don't
# seem to every be needed for anything...
#
#
# clear out any `lib*.la` libtool junk files from `$LDPATH`.
# everything is well and good if all of those files are present
# and all formatted for the same exact version of libtool with
# zero deviations or errors.  libtool will utterly shit itself
# if anything goes wrong.  however libtool seems perfectly happy
# as long as there are ZERO `*.la` files in its search path.
# seems it doesn't actually need them anyway and it will gladly
# continue without them.
#
# and rather than, y'know, just pretending that they're all
# absent in the case of an error, it instead screams confusing
# gibberish at you that sounds like there's actually a problem
# with your system.  not my system, fam.  that's the
# *GNU Build System* you're thinking of, that's got the problems.
# so whatever.  I've made a directory to archive them just in
# case, the Skofnung Home for Wayward Libtool Files, where they
# can be kept if it turns out that, whoops!, I actually do need
# those, but everything seems to work fine so far.
#
# trouble is, GNU autotools likes to keep on installing them
# over and over again.  so I wrote this handy dandy little script
# to do them like we did Luca Brasi back in the forties.  ya
# remember that?
#

LIBTOOL_DUMP=/root/tmp/libtool-is-for-fools

declare -a LIBTOOL_CURBS
#
# /lib64 -> /lib  &&  /usr/lib64 -> /usr/lib
#
LIBTOOL_CURBS=(
	/lib           /lib32
	/usr/lib       /usr/lib32
	/usr/local/lib
	/usr/share     /usr/local/share
)


# would `-L` be a good idea here?
#
find "${LIBTOOL_CURBS[@]}" \
	\( -type f -o -type l \) \
	-a -name '*.la' \
	-a \( \
		-exec cp -f --preserve=all --no-dereference \
		         --parents -t "${LIBTOOL_DUMP}" {} \
		     \; \
		-exec rm -f {} \; \
		-o -fprintf /dev/stderr 'error cleaning libtool garbage: %p\n' \
	\)

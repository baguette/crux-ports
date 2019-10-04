#!/usr/bin/env bash
# httpup-repgen - One way sync from an http server to a local directory 
# 
# Copyright 2003-2005 (c) Johannes Winkelmann, # jw@tks6.net
#
# - More filtering code added for git support - 10 November 2018 (cmburget)
# - Filtering code adapted from Per Liden's pkgmk
# - optimized and made portable (sh-compliant) by Han Boetes
#


# The repo file is place on the server. httpup downloads it,
# makes the update and afterwards moves it to the REPOCURRENTFILE
# which keeps track of the files which have been checked out. The
# REPOCURRENTFILE contains only file names

REPOFILE=REPO
REPOCURRENTFILE=REPO.CURRENT

IGNORE_FILE=.httpup-repgen-ignore

VERSION=0.9.1

info() {
	local msg="$(printf ' %s' "$@")"
	printf 'info: %s\n' "${msg# }" >&2
}

if [[ "$DEBUG" =~ ^[yYtT].* || "$DEBUG" =~ [1-9] ]]; then
	debug() {
		local msg="$(printf "$@")" || return $?
		while IFS= read -r i; do
			printf 'debug: %s\n' "$i" >&2
		done <<<"$msg"
		return 0
	}
else
	debug() {
		return 0
	}
fi

if [ -r "$HOME/$IGNORE_FILE" ]; then
	filter() {
		# user-global ignore file
		grep -Ev -f "$HOME/$IGNORE_FILE"
	}
else
	filter() {
		cat
	}
fi

if [ -r "$PWD/$IGNORE_FILE" ]; then
	filter_local() {
		# directory-specific ignore file
		grep -Ev -f "$PWD/$IGNORE_FILE"
	}
else
	filter_local() {
		cat
	}
fi

if git status &>/dev/null; then
	git_ig_files() {
		# list of untracked files & ignored files, whereto ignore
		git status --short --untracked-files=all --ignored --no-column --no-ahead-behind \
		| grep -E -ve '^\s*[MARC]\s+' \
		| cut -c4-
	}
	git_rm_files() {
		# list of removed files, whereto include
		git log --name-status --pretty=format:'%b' origin..HEAD \
		| grep -Ee $'^D\t' \
		| cut -f2-
		return 0
	}
	filter_git() {
		# produce a list of files tracked by git, & which have been modified
		# ł changed in the index.
		grep -Fxv -f <(git_ig_files)

		## XXX actually, this breaks the Makefile, rather than fixing it  ¬_¬
		### inject files into the list that have been removed locally but are
		### still present on the tip of the remote.
		##git_rm_files
	}
else
	filter_git() {
		cat
	}
fi

filter_own() {
	# ignore the meta files used by this script, and by the httpup system
	grep -Exv -e "($REPOFILE|$REPOCURRENTFILE|$IGNORE_FILE)"
}

find . -type f -print  \
| sed -re 's@^\./@@'   \
| filter               \
| filter_local         \
| filter_git           \
| filter_own

exit $?

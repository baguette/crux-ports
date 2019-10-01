#!/usr/bin/env bash
find . -maxdepth 2 -type f -name Pkgfile -execdir sh -c '
	printf "%s\\t" "${PWD##*/}"
	sed -nre '\''s/^#\s*URL\S*\s+(.*)$/\1/p'\'' "$1" || echo "$1"
' -- {} \; \
| awk '
	BEGIN {print "<html><head><title>port links</title></head><body><table>"}
	{printf "\t<tr><td>%s</td><td><a href=\"%s\">%s</a></td></tr>\n", $1, $2, $2}
	END {print "</table></body></html>"}
'

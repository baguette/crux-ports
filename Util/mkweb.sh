#!/usr/bin/env bash
find . -maxdepth 2 -type f -name Pkgfile -execdir sh -c '
	printf "%s" "${PWD##*/}"
	sed -nre '\''
		/^version=/ {s/^version=(\S+)/\t\1/;G;s/\n//p}
		/^#\s*URL/  {s/^#\s*\S+\s+(.*)$/\t\1/;h}
	'\'' "$1" || echo "$1"
' -- {} \; \
| sort -k1,1 \
| awk '
	BEGIN {print "<html><head><title>port links</title></head><body><table>"}
	{
		printf "\t<tr>"
		printf "<td>%s</td>", $1
		printf "<td>%s</td>", $2
		printf "<td><a href=\"%s\">%s</a></td>", $3, $3
		printf "</tr>\n"
	}
	END {print "</table></body></html>"}
'

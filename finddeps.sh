#!/bin/sh

objdump -p "$1" \
| grep NEEDED \
| awk '{print $2}' \
| xargs -I{} pkginfo -o lib/{} \
| grep -v '^Package' \
| awk '{print $1}' \
| sort -u \
| xargs -I{} find /usr/ports -maxdepth 2 -type d -name {} \
| sed -re 's@^/usr/ports/@@' \
| sort

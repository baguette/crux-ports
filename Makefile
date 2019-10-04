
all: REPO check links

PORTFILES != ./Util/list-httpup-repfiles.sh
REPO: $(PORTFILES)
	httpup-repgen .

.PHONY: check
check: REPO
	./Util/check.sh

.PHONY: links
links: links.html
links.html:
	./Util/mkweb.sh > $@


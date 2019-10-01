
all: REPO check

PORTFILES != ~/bin/list-httpup-repfiles.sh
REPO: $(PORTFILES)
	httpup-repgen .

.PHONY: check
check: REPO
	./check.sh


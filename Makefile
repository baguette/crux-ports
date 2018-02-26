
all: REPO

PORTFILES != ~/bin/list-httpup-repfiles.sh
REPO: $(PORTFILES)
	httpup-repgen .


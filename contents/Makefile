.PHONY: install test pages

EMACSBIN ?= emacs
BATCH     = $(EMACSBIN) -Q --batch --no-site-lisp
GH_PAGES_DIR=.gh-pages
PUBLISH_PAGES_DIR=.publish
PUBLISH_ORIGINAL_DIR=.publish/original
EMACS_DEPS_DIR=.emacs-dependencies
DIST_DIR=dist
ASSETS_DIR=assets

install: setup-git mkdirs get-deps

setup-git:
	git submodule update

install-emacs:
	sudo apt update
	sudo apt-get install -y software-properties-common python-software-properties
	sudo apt-add-repository -y ppa:adrozdoff/emacs
	sudo apt update
	sudo apt-get install -y emacs25

mkdirs:
	if [ ! -d "$(EMACS_DEPS_DIR)" ]; then mkdir -p "$(EMACS_DEPS_DIR)"; fi
	if [ ! -d "$(GH_PAGES_DIR)" ]; then mkdir -p "$(GH_PAGES_DIR)"; fi
	if [ ! -d "$(PUBLISH_PAGES_DIR)" ]; then mkdir -p "$(PUBLISH_PAGES_DIR)"; fi
	if [ ! -d "$(PUBLISH_ORIGINAL_DIR)" ]; then mkdir -p "$(PUBLISH_ORIGINAL_DIR)"; fi
	if [ ! -d "$(DIST_DIR)" ]; then mkdir -p "$(DIST_DIR)"; fi

get-deps:
	sudo apt-get install -y texinfo
	git clone https://github.com/hniksic/emacs-htmlize.git "$(EMACS_DEPS_DIR)/emacs-htmlize"
	git clone https://github.com/mrlee23/org-multilingual.git "$(EMACS_DEPS_DIR)/org-multilingual"
	git clone -b release_9.1.6 https://code.orgmode.org/bzg/org-mode.git "$(EMACS_DEPS_DIR)/org-mode"
	cd "$(EMACS_DEPS_DIR)/org-mode" && make
	cd "$(EMACS_DEPS_DIR)/org-mode/lisp" && find . -name "*.el" | sed 's/.el$$//g' | sed 's/.\///g' | sed '/^requirements$$/d'| sed "s/\(.*\)/(require '\1)/g" > requirements.el

test:
	echo "No tests."
	echo "HI"

index: mkdirs
	if [ -f "index.org" ]; \
	then \
		emacs -Q --batch index.org -l ./elisp/linux-commands-macro.el -L elisp -f org-html-export-to-html; \
		mv -f index.html "$(GH_PAGES_DIR)/index.html"; \
		rm -f index.org; \
	fi;

pages: mkdirs pages-deps
	if [ -d .org-timestamps ]; then rm -rf .org-timestamps; fi
	if [ -f "CNAME" ]; then cp CNAME "$(GH_PAGES_DIR)/CNAME"; fi
	if [ -d "$(DIST_DIR)" ]; then mv -f "$(DIST_DIR)" "$(GH_PAGES_DIR)/$(DIST_DIR)"; fi
	if [ -d "$(PUBLISH_ORIGINAL_DIR)" ]; then rm -rf "$(PUBLISH_ORIGINAL_DIR)"; mkdir -p "$(PUBLISH_ORIGINAL_DIR)"; fi
	find ./ -type f -not -path "*/.*" -exec cp --parents -rf {} "$(PUBLISH_ORIGINAL_DIR)" \;
	@$(BATCH) --eval "(progn\
	$$load_paths\
	(message \"%s\" load-path)\
	(require 'linux-commands)\
	(pages-publish \"./\" \"$(GH_PAGES_DIR)/\" \"$(PUBLISH_PAGES_DIR)\")\
	)"
	for lang in `cat .supportLanguages`; \
	do \
		if [ -d "$(PUBLISH_PAGES_DIR)/$${lang}" ]; then echo "$$lang" > "$(PUBLISH_PAGES_DIR)/$${lang}/.language"; fi; \
		if [ -d "$(GH_PAGES_DIR)/$(DIST_DIR)/$${lang}/$(ASSETS_DIR)" ]; then rm -rf "$(GH_PAGES_DIR)/$(DIST_DIR)/$${lang}/$(ASSETS_DIR)"; fi; \
	done;
	find . -type d -path "*/$(DIST_DIR)/*/.git" -prune -exec rm -rf {} \;

pages-deps:
	cp -rf "$(ASSETS_DIR)" "$(DIST_DIR)/$(ASSETS_DIR)"
	git clone https://github.com/mrlee23/readtheorg.git $(DIST_DIR)/readtheorg
	rm -rf dist/readtheorg/.git

define load_paths
(add-to-list 'load-path "./")
(add-to-list 'load-path "./elisp")
(add-to-list 'load-path "$(EMACS_DEPS_DIR)/emacs-htmlize")
(add-to-list 'load-path "$(EMACS_DEPS_DIR)/org-multilingual")
(add-to-list 'load-path "$(EMACS_DEPS_DIR)/org-mode/lisp")
(add-to-list 'load-path "$(EMACS_DEPS_DIR)/org-mode/contrib/lisp")
(load-file "$(EMACS_DEPS_DIR)/org-mode/lisp/requirements.el")
(message "Org version: %s" org-version)
endef
define publish_pages

endef
define delete_pages_deps
(when (file-directory-p "$(GH_PAGES_DIR)/$(EMACS_DEPS_DIR)")
	(delete-directory "$(GH_PAGES_DIR)/$(EMACS_DEPS_DIR)" t))
(when (file-directory-p "$(EMACS_DEPS_DIR)")
	(delete-directory "$(EMACS_DEPS_DIR)" t))
endef

export load_paths
export publish_pages
export delete_pages_deps

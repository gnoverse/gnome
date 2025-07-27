NAMESPACE ?= gnome
CHAIN_ID ?= dev
REMOTE ?= 127.0.0.1:26657
KEY_NAME ?=
KEY_PASSWORD ?=

ifndef KEY_NAME
	KEY_NAME := $(shell bash -c 'read -p "Key Name: " name; echo $$name')
endif

ifndef KEY_PASSWORD
	KEY_PASSWORD := $(shell bash -c 'read -s -p "Key Password: " pwd; echo $$pwd')
endif

deploy: deploy_realms

deploy_realms: deploy_realm_dao

deploy_realm_dao:
	@echo "\nDeploying DAO realm..."
	@gnokey maketx addpkg $(KEY_NAME) \
		--pkgpath "gno.land/r/$(NAMESPACE)/dao" \
		--pkgdir "./gno.land/r/gnome/dao" \
		--gas-fee "50000ugnot"  \
		--gas-wanted "50000000" \
		--broadcast \
		--chainid "$(CHAIN_ID)" \
		--remote "$(REMOTE)" \
		--quiet \
		--insecure-password-stdin <<< "$(KEY_PASSWORD)"

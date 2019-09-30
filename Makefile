.PHONY: build system


# Variables
# ---------

SRC_DIR=src
BUILD_DIR=build
TEMPLATE_DIR=icidasset-template



# Default
# -------

all: dev



# Building
# --------

build: clean system css
	@echo "> Done ⚡"


clean:
	@echo "> Cleaning Build Directory"
	@rm -rf $(BUILD_DIR)


css:
	@echo "> Compiling Css"
	@./node_modules/.bin/tailwind \
		build "${TEMPLATE_DIR}/Css/Main.css" \
		--config "${TEMPLATE_DIR}/Css/Tailwind.js" \
		--output "${BUILD_DIR}/stylesheet.css"


system:
	@echo "> Compiling System"
	@stack build --fast && stack exec build



# Development
# -----------

dev: build
	@make -j watch server


server:
	@echo "> Booting up web server (http://localhost:8000)"
	@devd --port 8000 --all --crossdomain --quiet --notfound=404.html $(BUILD_DIR)


watch:
	@echo "> Watching"
	@make -j watch-css watch-system


watch-css:
	@watchexec -p -i "${BUILD_DIR}*" --exts "css" -- make css


watch-system:
	@watchexec -p -i "${BUILD_DIR}*" --exts "md,hs,yaml" -- make system



# Production
# ==========

build-production: build
	@echo "> Minifying Css"
	@./node_modules/.bin/purgecss \
		--config purgecss.config.js \
		--out $(BUILD_DIR)
	@./node_modules/.bin/csso \
		"${BUILD_DIR}/stylesheet.css" \
		--output "${BUILD_DIR}/stylesheet.css"


deploy: build-production
	@echo "> Deploying to IPFS using FISSION"
	ipfs-deploy -p fission -d cloudflare build/

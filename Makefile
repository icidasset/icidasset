.PHONY: build system


# Variables

NODE_BIN=./node_modules/.bin
SRC_DIR=./src
BUILD_DIR=./build


# Default task

all: dev


#
# Build tasks
#
build: clean system css
	@echo "> Done ⚡"


build-production: build


clean:
	@echo "> Cleaning Build Directory"
	@rm -rf $(BUILD_DIR)


css:
	@echo "> Compiling CSS"
	@$(NODE_BIN)/postcss \
		-u postcss-import \
		-u postcss-mixins \
		-u postcss-custom-units \
		-u postcss-remify --postcss-remify.base=16 \
		-u postcss-simple-vars \
		-u postcss-cssnext --no-postcss-cssnext.features.rem \
		-o $(BUILD_DIR)/application.css \
		./src/Css/index.css


system:
	@echo "> Compiling System"
	@stack build && stack exec build


#
# Dev tasks
#
dev: build
	@make -j watch_wo_build server


server:
	@echo "> Booting up web server (http://localhost:8000)"
	@stack build && stack exec server


watch: build
	@make watch_wo_build


watch_wo_build:
	@echo "> Watching"
	@make -j watch_css watch_system


watch_css:
	@watchexec -p -w src -w icidasset-template --filter *.css -- make css


watch_system:
	@watchexec -p -w src -w icidasset-template -w system --ignore *.css -- make system

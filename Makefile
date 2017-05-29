.PHONY: build system


# variables
BIN=./node_modules/.bin
BUILD_DIR=./build


# tasks
all: build


build: clean system css


build-production: build


clean:
	@echo "> Cleaning Build Directory"
	@rm -rf $(BUILD_DIR)


css:
	@echo "> Compiling CSS"
	@$(BIN)/postcss \
		-u postcss-import \
		-u postcss-mixins \
		-u postcss-custom-units \
		-u postcss-remify --postcss-remify.base=16 \
		-u postcss-simple-vars \
		-u postcss-cssnext --no-postcss-cssnext.features.rem \
		-o $(BUILD_DIR)/application.css \
		./src/Css/index.css


server:
	@echo "> Booting up web server"
	@stack build && stack exec server -- -p 8080 --no-access-log --no-error-log


system:
	@echo "> Compiling System"
	@stack build && stack exec build


systemWithProfiles:
	@echo "> Compiling System (with stack-traces / profiles)"
	@stack build --force-dirty --executable-profiling --library-profiling && stack exec build

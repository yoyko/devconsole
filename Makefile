ELM_MAIN = src/DevConsole.elm
ELM_SOURCES = $(wildcard src/*.elm)

all: build/index.html

elm-stuff/exact-dependencies.json: elm-package.json
	elm-install

build/index.html: $(ELM_SOURCES) elm-stuff/exact-dependencies.json
	elm make --yes $(ELM_MAIN)  --output=$@

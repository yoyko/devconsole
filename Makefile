ELM_MAIN = src/DevConsole.elm
ELM_SOURCES = $(wildcard src/*.elm)

all: build/index.html

build/index.html: $(ELM_SOURCES)
	elm make --yes $(ELM_MAIN)  --output=$@

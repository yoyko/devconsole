ELM_MAIN = src/DevConsole.elm
ELM_SOURCES = $(shell find src/ -type f -name '*.elm')
STATIC_FILES = index.html DevConsole.css

SRC_DIR = src
OUT_DIR = build
STATIC_OUT = $(foreach f, $(STATIC_FILES), build/$(f))
ELM_OUT = $(OUT_DIR)/$(basename $(notdir $(ELM_MAIN))).js

build: $(STATIC_OUT) $(ELM_OUT)
clean:
	rm -r $(OUT_DIR)
.PHONY: clean



$(OUT_DIR)/index.html: $(SRC_DIR)/index.html
	mkdir -p $(OUT_DIR)
	sed -e 's,src="/_compile[^"]*",src="$(notdir $(ELM_OUT))",' $< >$@

$(OUT_DIR)/%: $(SRC_DIR)/$*
	mkdir -p $(OUT_DIR)
	cp -v $(SRC_DIR)/$* $@

elm-stuff/exact-dependencies.json: elm-package.json
	elm-install

$(ELM_OUT): $(ELM_SOURCES) elm-stuff/exact-dependencies.json
	mkdir -p $(OUT_DIR)
	elm-make --yes $(ELM_MAIN)  --output=$@


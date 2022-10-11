PACKAGE = supermoon

SRC_DIR = src
LUA_DIR = lua
DOC_DIR = doc

SRC_FILES = $(wildcard $(SRC_DIR)/*.moon)
LUA_FILES = $(SRC_FILES:$(SRC_DIR)/%.moon=$(DIST_DIR))

all: mkdirs compile doc

compile: $(LUA_FILES)

mkdirs:
	mkdir -p $(SRC_DIR)
	mkdir -p $(LUA_DIR)
	mkdir -p $(DOC_DIR)

$(LUA_DIR)/%.lua: $(SRC_DIR)/%.moon
	moonc -o $@ $<

.PHONY: clean
clean:
	rm -rf $(LUA_DIR)
	rm -rf $(DOC_DIR)

.PHONY: doc
doc:
	ldoc .

.PHONY: install
install:
	cp -r $(LUA_DIR) $(INST_LUADIR)/$(PACKAGE)
	cp -r $(DOC_DIR) $(INST_PREFIX)

.PHONY: test
test:
	busted


RLX=compiler/build/linux_compiler.elf
RLX_FLAGS?=--linux --debug --dwarf
MAIN=src/Main.rlx
PROGRAM=Main
DBG?=

BUILD=./build

BINARY=$(BUILD)/$(PROGRAM).elf
DEPS=$(BUILD)/$(PROGRAM).d

$(BINARY): $(RLX)
$(BINARY): $(DEPS)
$(BINARY): $(shell cat $(DEPS) 2>/dev/null)
	$(DBG)$(RLX) -i $(MAIN) -o $@ ${RLX_FLAGS}

secret-internal-deps: $(DEPS)

$(DEPS): $(RLX)
	$(RLX) -i $(MAIN) -o $@ $(RLX_FLAGS) --makedep

LIGHT_CLEAN_FILES+= $(BINARY)
CLEAN_FILES+= $(BINARY) $(DEPS)

clean:
	-rm -f $(LIGHT_CLEAN_FILES)

clean-all: clean
	-rm -f $(CLEAN_FILES)

depend dep deps:
	-rm -f $(BUILD)/*.d
	$(MAKE) secret-internal-deps

build: $(BINARY)

rebuild: clean build

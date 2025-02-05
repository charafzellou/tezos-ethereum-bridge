# Directory paths
API_DIR = api
ETH_CONTRACTS_DIR = contracts/ethereum
TEZ_CONTRACTS_DIR = contracts/tezos

# Commands
NPM = npm
LIGO = ligo compile contract

.PHONY: all clean install build start dev test

# Help target
help:
	@echo "Available targets:"
	@echo "  all           - Install dependencies and build all components"
	@echo "  install       - Install all dependencies"
	@echo "  build        - Build all components"
	@echo "  clean        - Clean all build artifacts and dependencies"
	@echo "  dev-api      - Run API in development mode"
	@echo "  start-api    - Start the API service"
	@echo "  help         - Show this help message"

# Default target
all: install build

# Installation targets
install: install-api install-eth install-tez

install-api:
	cd $(API_DIR) && $(NPM) install

install-eth:
	cd $(ETH_CONTRACTS_DIR) && $(NPM) install

install-tez:
	cd $(TEZ_CONTRACTS_DIR) && $(NPM) install

# Build targets
build: build-api build-eth build-tez

build-api:
	cd $(API_DIR) && $(NPM) run build

build-eth:
	cd $(ETH_CONTRACTS_DIR) && $(NPM) run build

build-tez:
	cd $(TEZ_CONTRACTS_DIR) && $(LIGO) ./src/lp_contract.mligo -o ./build/lp_contract.tz

# Development targets
dev-api:
	cd $(API_DIR) && $(NPM) run dev

# Start targets
start-api:
	cd $(API_DIR) && $(NPM) start

# Clean targets
clean: clean-api clean-eth clean-tez

clean-api:
	rm -rf $(API_DIR)/dist
	rm -rf $(API_DIR)/node_modules

clean-eth:
	rm -rf $(ETH_CONTRACTS_DIR)/artifacts
	rm -rf $(ETH_CONTRACTS_DIR)/cache
	rm -rf $(ETH_CONTRACTS_DIR)/node_modules

clean-tez:
	rm -rf $(TEZ_CONTRACTS_DIR)/build
	rm -rf $(TEZ_CONTRACTS_DIR)/node_modules

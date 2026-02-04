SHELL := bash
.SHELLFLAGS = -e -o pipefail -c
.DEFAULT_GOAL := help
.NOTPARALLEL:
.SILENT: # use set -v to print commands executed
.ONESHELL:
# This Makefile is used as a script runner, rather than a build system
.PHONY: $(MAKECMDGOALS)
ifndef VERBOSE
MAKEFLAGS += --no-print-directory
endif

##@ Build

build: ## Build codebase
	go build ./...

test: ## Run tests
	go test ./...

##@ Dependencies

deps: ## Install dependencies for Go
	go mod download

tidy: ## Go deps (go mod tidy)
	go mod tidy

##@ Code Quality

GOLINT_ARGS ?= --verbose --config .golangci.yml

format: ## Format code
	go tool golangci-lint fmt $(GOLINT_ARGS)

lint: format ## Lint code
	go tool golangci-lint run --fix $(GOLINT_ARGS) ./...

##@ Helpers

help:  ## Display this help
	awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

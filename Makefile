SHELL := /usr/bin/env
.SHELLFLAGS = bash -e -o pipefail -c
.DEFAULT_GOAL := help
.NOTPARALLEL:
.SILENT: # use set -v to print commands executed
.ONESHELL:

ifndef VERBOSE
MAKEFLAGS += --no-print-directory
endif

##@ Build

.PHONY: build
build: ## Build codebase
	go build ./...

.PHONY: test
test: ## Run tests
	go test ./...

##@ Dependencies

.PHONY: deps
deps: ## Install dependencies for Go
	go mod download

.PHONY: tidy
tidy: ## Go deps (go mod tidy)
	go mod tidy

##@ Code Quality

GOLINT_ARGS ?= --verbose --config .golangci.yml

.PHONY: format
format: ## Format code
	go tool golangci-lint fmt $(GOLINT_ARGS)

.PHONY: lint
lint: ## Lint code
	go tool golangci-lint run --fix $(GOLINT_ARGS) ./...

##@ Helpers

.PHONY: help
help:  ## Display this help
	awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

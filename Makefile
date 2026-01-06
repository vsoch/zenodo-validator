# --- Configuration ---
IMAGE_NAME := zenodo-validator
ZENODO_FILE := .zenodo.json
PWD := $(shell pwd)

# Default target: Build the container
.PHONY: all
all: build

## 🏗️  build: Build the Docker container locally
.PHONY: build
build:
	@echo "🔨 Building the validator image..."
	docker build -t $(IMAGE_NAME) .
	@echo "✅ Build complete! Image tagged as: $(IMAGE_NAME)"

## 🛡️  validate: Run validation against the local .zenodo.json
.PHONY: validate
validate:
	@echo "🔍 Starting local validation of $(ZENODO_FILE)..."
	@if [ ! -f $(ZENODO_FILE) ]; then \
		echo "❌ Error: $(ZENODO_FILE) not found in this directory!"; \
		exit 1; \
	fi
	docker run --rm \
		-v $(PWD):/github/workspace \
		-e GITHUB_WORKSPACE=/github/workspace \
		-e INPUT_PATH=$(ZENODO_FILE) \
		-e INPUT_SCHEMA_PATH=/schema.json \
		-e INPUT_ERROR_FORMAT=text \
		$(IMAGE_NAME)

## 🧹  clean: Remove the local Docker image
.PHONY: clean
clean:
	@echo "🗑️  Removing Docker image..."
	docker rmi $(IMAGE_NAME) || echo "⚠️  Image not found, nothing to delete."

## ❓  help: Show this help message
.PHONY: help
help:
	@echo "🌟 Zenodo Validator Makefile 🌟"
	@echo "--------------------------------"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

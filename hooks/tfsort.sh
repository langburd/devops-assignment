#!/usr/bin/env bash
set -eo pipefail

# Check if tfsort is available
if ! command -v tfsort &> /dev/null; then
    echo "Warning: tfsort command not found. Skipping Terraform file sorting."
    echo "To install tfsort, visit: https://github.com/AlexNabokikh/tfsort"
    exit 0
fi

for file in "$@"; do
  if [[ -f "${file}" ]]; then
    if [[ -s "${file}" ]]; then
      echo "Sorting ${file}..."
      tfsort "${file}"
    fi
  fi
done

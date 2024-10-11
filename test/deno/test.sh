#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
checkExtension "denoland.vscode-deno"
check "node" node --version
check "typescript" tsc -v
check "deno version" deno -v

# Report result
reportResults

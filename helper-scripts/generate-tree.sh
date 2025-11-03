#!/bin/bash

# Generate project directory tree and save to file
echo "::group::The repository $GITHUB_REPOSITORY contains the following files"
tree > tree.txt
cat tree.txt
echo "::endgroup::"
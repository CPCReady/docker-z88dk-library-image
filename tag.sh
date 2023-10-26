#!/bin/bash

git tag v$1 -m "$2"
git push --tags
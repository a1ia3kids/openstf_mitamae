#!/bin/bash

set -ex

bin/setup

# Homebrew does not allow sudo.
case "$(uname)" in
  "Darwin")  bin/mitamae local $@ --node-yaml=nodes/openstf.yml lib/recipe.rb ;;
  *) sudo -E bin/mitamae local $@ --node-yaml=nodes/openstf.yml lib/recipe.rb ;;
esac

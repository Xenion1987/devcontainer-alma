#! /usr/bin/env bash

if type go &>/dev/null; then
    go install github.com/jesseduffield/lazygit@latest
else
    echo "Go language seems not to be installed."
    exit 255
fi

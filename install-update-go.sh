#! /usr/bin/env bash
function downloadGoPackage() {
    if ! curl -sL -o "/tmp/${GO_PACKAGE_FILE_NAME}" "https://dl.google.com/go/${GO_PACKAGE_FILE_NAME}"; then
        EXIT_CODE="${?}"
        echo "Could not download '${GO_PACKAGE_FILE_NAME}'"
        exit "${EXIT_CODE}"
    fi
}
function installGoPackage() {
    if ! tar -C /usr/local -xzf "/tmp/${GO_PACKAGE_FILE_NAME}"; then
        EXIT_CODE="${?}"
        echo "Could extract '${GO_PACKAGE_FILE_NAME}'"
        exit "${EXIT_CODE}"
    else
        #shellcheck disable=SC2016
        echo 'export PATH=$PATH:/usr/local/go/bin:~/go/bin' | tee -a /etc/profile
    fi
}
function cleanup() {
    rm -f "/tmp/${GO_PACKAGE_FILE_NAME}"
}

# Usage: bash install-update-go.sh [OS TYPE] [ARCHITECTURE] [GO VERSION]

# Example: linux
GO_OS=${1:-"$(uname -s)"}
# Example: arm64
GO_ARCH=${2:-"$(uname -m)"}
# Example: go1.19.1
GO_VERSION=${3:-"$(curl -sL 'https://golang.org/VERSION?m=text')"}

GO_PACKAGE_FILE_NAME="${GO_VERSION}.${GO_OS,,}-${GO_ARCH,,}.tar.gz"

downloadGoPackage
installGoPackage
cleanup

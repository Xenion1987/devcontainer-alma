#! /usr/bin/env bash

# If you want to use a specific version, set the version number here.
# Otherwise, set the variable to 'latest'
SHELLCHECK_VERSION="latest"
SHFMT_VERSION="latest"

function install_packages {
    dnf -y update
    dnf -y install \
        bash-completion \
        ca-certificates \
        curl \
        dnsutils \
        dos2unix \
        file \
        git \
        gnupg2 \
        htop \
        jo \
        jq \
        krb5-server \
        krb5-workstation \
        netcat \
        pam_krb5 \
        procps \
        pwgen \
        tldr \
        vim \
        wget \
        zip unzip

    # dnf -y module install nodejs:16
}
function update_npm() {
    if which npm; then
        npm install -g npm@latest
    fi
}
function install_bash_languageServer() {
    if which npm; then
        npm install bash-language-server
    fi
}
function get_latest_github_release_version() {
    curl -s "https://api.github.com/repos/${GH_ORG}/${GH_REPO}/releases/latest" | jq -r '.tag_name'
}
function install_shellcheck {
    GH_ORG="koalaman"
    GH_REPO="shellcheck"
    if [[ "${SHELLCHECK_VERSION}" = "latest" ]]; then
        SHELLCHECK_VERSION="$(get_latest_github_release_version)"
    fi
    DOWNLOAD_FILENAME="shellcheck-${SHELLCHECK_VERSION}.linux.x86_64.tar.xz"
    curl -sL \
        "https://github.com/${GH_ORG}/${GH_REPO}/releases/download/${SHELLCHECK_VERSION}/${DOWNLOAD_FILENAME}" \
        -o "/tmp/${DOWNLOAD_FILENAME}"
    tar -xf "/tmp/${DOWNLOAD_FILENAME}" -C "/tmp/"
    cp "/tmp/shellcheck-${SHELLCHECK_VERSION}/shellcheck" "/usr/local/bin/"
    chmod +x "/usr/local/bin/shellcheck"
}
function install_shfmt {
    GH_ORG="mvdan"
    GH_REPO="sh"
    if [[ "${SHFMT_VERSION}" = "latest" ]]; then
        SHFMT_VERSION="$(get_latest_github_release_version)"
    fi
    DOWNLOAD_FILENAME="shfmt_${SHFMT_VERSION}_linux_amd64"
    curl -sL \
        "https://github.com/${GH_ORG}/${GH_REPO}/releases/download/${SHFMT_VERSION}/${DOWNLOAD_FILENAME}" \
        -o "/usr/local/bin/shfmt"
    chmod +x "/usr/local/bin/shfmt"
}
install_packages
install_shfmt
install_shellcheck
#spacer
#update_npm
#spacer
#install_bash_languageServer

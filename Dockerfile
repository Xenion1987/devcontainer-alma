FROM almalinux:latest

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG INSTALL_ZSH=true
ARG INSTALL_OH_MYS=true
ARG UPGRADE_PACKAGES=true

RUN dnf -y install\
    passwd \
    sudo \
    epel-release

RUN useradd -m -s /bin/zsh ${USERNAME} \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R ${USERNAME} /commandhistory \
    && echo "${SNIPPET}" >> "/home/${USERNAME}/.bashrc"

COPY scripts/*.sh /tmp/script-library/

RUN bash /tmp/script-library/common-redhat.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "${INSTALL_OH_MYS}" \
    && bash /tmp/script-library/custom-redhat.sh \
    && bash /tmp/script-library/install-update-go.sh linux arm64 \
    && yum clean all \
    && rm -rf /tmp/script-library/

USER ${USERNAME}

RUN  /usr/local/go/bin/go install github.com/jesseduffield/lazygit@latest

RUN git clone https://github.com/romkatv/powerlevel10k.git /home/${USERNAME}/.oh-my-zsh/custom/themes/powerlevel10k

COPY profile/* /home/${USERNAME}/

WORKDIR /home/${USERNAME}/

ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

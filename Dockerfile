FROM ghcr.io/cpcready/docker-z88dk-library-image:latest
ARG USERNAME=amstrad
ARG USERPASS=amstrad

# VARIABLES DE ENTORNO
ENV CPCREADY=/home/${USERNAME}/CPCReady
ENV CPCREADY_CFG=/home/${USERNAME}/CPCReady/cfg
ENV PATH=$PATH:/home/${USERNAME}/CPCReady/tools/bin:/home/${USERNAME}/.local/bin

USER $USERNAME
WORKDIR /home/${USERNAME}

# CLONE INSTALATOR
RUN git clone https://github.com/CPCReady/installer.git ~/CPCReady
RUN chmod -R 777 /home/${USERNAME}/CPCReady/tools/bin

COPY VERSION /home/${USERNAME}/VERSION
COPY software/head.sh /home/${USERNAME}/.head.sh
RUN echo 'source ~/.head.sh' >>~/.zshrc

RUN pip install -r /home/${USERNAME}/CPCReady/requirements.txt
RUN ln -s /workspaces/sdk/CPCReady /home/amstrad/.local/lib/python3.10/site-packages/CPCReady

USER root
RUN chown $USERNAME:$USERNAME /home/${USERNAME}/.head.sh
RUN chown $USERNAME:$USERNAME /home/${USERNAME}/VERSION

WORKDIR /home/$USERNAME
EXPOSE 22
USER $USERNAME
ENV TERM xterm

ENV SHELL /bin/zsh

CMD ["/usr/sbin/sshd", "-D"]

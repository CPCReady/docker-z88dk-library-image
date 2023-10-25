FROM ubuntu:22.04
ARG USERNAME=amstrad
ARG USERPASS=amstrad
ENV TZ=Europe/Minsk
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update && apt-get install -y openssh-server sudo pasmo build-essential bison flex libxml2-dev && \
    subversion zlib1g-dev m4 ragel re2c dos2unix texinfo texi2html gdb curl perl cpanminus ccache libboost-all-dev && \
    libmodern-perl-perl libyaml-perl liblocal-lib-perl libcapture-tiny-perl libpath-tiny-perl libtext-table-perl && \
    libdata-hexdump-perl libregexp-common-perl libclone-perl libfile-slurp-perl pkg-config flex vim bison libboost-dev && \
    libfreeimage-dev wine mono-complete curl unzip zip git openjdk-8-jdk groovy whois zsh-syntax-highlighting locales python3-pip && \
    zsh fonts-powerline nano
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
RUN useradd -ms /bin/bash ${USERNAME}
RUN apt purge -y whois && apt -y autoremove && apt -y autoclean && apt -y clean
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
ADD software/usr/local/share/fonts /usr/local/share/fonts
ADD software/usr/local/bin /usr/local/bin

# VARIABLES DE ENTORNO
ENV CPCREADY=/home/${USERNAME}/CPCReady
ENV PATH=$PATH:/home/${USERNAME}/CPCReady
ENV PATH=$PATH:/home/${USERNAME}/CPCReady
ENV PATH=$PATH:/home/${USERNAME}/z88dk/bin
ENV ZCCCFG=/home/${USERNAME}/z88dk/lib/config


USER $USERNAME
# DESACTIVAMOS DIRECTORIOS SEGUROS GIT
RUN git config --global --add safe.directory '*'
WORKDIR /home/${USERNAME}

# CONFIGURAMOS POWER LINK
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-syntax-highlighting
COPY software/.p10k.zsh /home/${USERNAME}/.p10k.zsh
COPY software/.zshrc /home/${USERNAME}/.zshrc

# COPIAMOS Y COMPILAMOS Z88DK
RUN wget http://nightly.z88dk.org/z88dk-latest.tgz
RUN tar -xzf z88dk-latest.tgz
RUN cpanm --local-lib=~/perl5 App::Prove CPU::Z80::Assembler Data::Dump Data::HexDump File::Path List::Uniq Modern::Perl Object::Tiny::RW Regexp::Common Test::Harness Text::Diff Text::Table YAML::Tiny
RUN eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
RUN rm -rf z88dk-latest.tgz
RUN cd z88dk && \
    export BUILD_SDCC=1 && \
    export BUILD_SDCC_HTTP=1 && \
    chmod 777 build.sh && \
    ./build.sh

USER root
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL " >> /etc/sudoers
RUN chown $USERNAME:$USERNAME /home/${USERNAME}/.p10k.zsh
RUN chown $USERNAME:$USERNAME /home/${USERNAME}/.zshrc

WORKDIR /home/$USERNAME
ENV JAVA_HOME /usr
EXPOSE 22
USER $USERNAME
ENV TERM xterm

ENV SHELL /bin/zsh

CMD ["/usr/sbin/sshd", "-D"]
FROM debian:bookworm-slim

RUN apt-get update --fix-missing && apt-get install -y \
    curl locales sudo xz-utils

RUN apt-get clean && apt-get purge && apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/pseudomuto -s /bin/bash pseudomuto
RUN usermod -a -G sudo pseudomuto
RUN echo " pseudomuto      ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV LANG en_US.UTF-8
RUN dpkg-reconfigure locales && locale-gen

WORKDIR /home/pseudomuto
USER pseudomuto
ENV USER pseudomuto
ENV NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM "1"

COPY install /tmp/install-nix
RUN USER=pseudomuto /tmp/install-nix

# pretend like we cloned to ~/dotfiles
COPY . ./dotfiles
RUN sudo chown -R pseudomuto:pseudomuto .

ENTRYPOINT ["dotfiles/entrypoint"]
CMD ["zsh"]

FROM ubuntu:focal

RUN useradd -ms /bin/bash testuser && adduser testuser sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN apt-get update -y --quiet && \
    apt-get install -y --no-install-recommends automake git ruby-dev ruby-bundler && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN echo "bundle install --without development --path vendor/bundle" >> /home/testuser/.bashrc && \
    echo "exe/dotfiles link" >> /home/testuser/.bashrc

COPY . /dotfiles
RUN chown -R testuser /dotfiles

USER testuser
WORKDIR /dotfiles

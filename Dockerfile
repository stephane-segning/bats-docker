# Define versions for different distributions
ARG CENTOS_VERSION=8
ARG OPENSUSE_VERSION=15.3
ARG UBUNTU_VERSION=20.04
ARG DEBIAN_VERSION=buster
ARG ALPINE_VERSION=3.14
ARG FEDORA_VERSION=34

# Start with CentOS
FROM centos:${CENTOS_VERSION} as centos

RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum install -y git
RUN yum clean all

RUN git clone https://github.com/bats-core/bats-core.git
RUN cd bats-core && ./install.sh /usr/local

RUN bats --version

# Next, use openSUSE
FROM opensuse/leap:${OPENSUSE_VERSION} as opensuse
RUN zypper install -y bats && zypper clean --all
RUN bats --version

# Next, use Ubuntu
FROM ubuntu:${UBUNTU_VERSION} as ubuntu
RUN apt-get update && apt-get install -y bats
RUN bats --version

# Next, use Debian
FROM debian:${DEBIAN_VERSION} as debian
RUN apt-get update && apt-get install -y bats
RUN bats --version

# Next, use Alpine
FROM alpine:${ALPINE_VERSION} as alpine
RUN apk add --no-cache bash bats
RUN bats --version

# Next, use Fedora
FROM fedora:${FEDORA_VERSION} as fedora
RUN dnf install -y bats
RUN bats --version

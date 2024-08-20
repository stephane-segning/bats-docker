# Define versions for different distributions
ARG CENTOS_VERSION=8
ARG OPENSUSE_VERSION=15.3
ARG UBUNTU_VERSION=20.04
ARG DEBIAN_VERSION=buster
ARG ALPINE_VERSION=3.14
ARG FEDORA_VERSION=34
ARG ARCH_VERSION=latest

# Start with CentOS
FROM centos:${CENTOS_VERSION} as centos
RUN yum install -y epel-release \
    && yum install -y bats \
    && yum clean all

# Next, use openSUSE
FROM opensuse/leap:${OPENSUSE_VERSION} as opensuse
RUN zypper install -y bats && zypper clean --all

# Next, use Ubuntu
FROM ubuntu:${UBUNTU_VERSION} as ubuntu
RUN apt-get update && apt-get install -y bats

# Next, use Debian
FROM debian:${DEBIAN_VERSION} as debian
RUN apt-get update && apt-get install -y bats

# Next, use Alpine
FROM alpine:${ALPINE_VERSION} as alpine
RUN apk add --no-cache bash bats

# Next, use Fedora
FROM fedora:${FEDORA_VERSION} as fedora
RUN dnf install -y bats

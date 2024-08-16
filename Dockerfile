# Define versions for different distributions
ARG CENTOS_VERSION=7
ARG OPENSUSE_VERSION=15.3
ARG UBUNTU_VERSION=20.04
ARG DEBIAN_VERSION=buster
ARG ALPINE_VERSION=3.14
ARG FEDORA_VERSION=34
ARG ARCH_VERSION=latest

# Define the Wazuh agent version and required arguments
ARG WAZUH_AGENT_VERSION=4.4.0
ARG WAZUH_MANAGER=10.0.0.2
ARG WAZUH_AGENT_NAME=test123

# Start with CentOS
FROM centos:${CENTOS_VERSION} as centos
ARG WAZUH_AGENT_VERSION
ARG WAZUH_MANAGER
ARG WAZUH_AGENT_NAME
RUN rpm --import https://packages.wazuh.com/key/GPG-KEY-WAZUH
RUN yum install -y epel-release && \
    yum install -y wazuh-agent-${WAZUH_AGENT_VERSION} && \
    sed -i "s/MANAGER_IP/${WAZUH_MANAGER}/g" /var/ossec/etc/ossec.conf && \
    sed -i "s/AGENT_NAME/${WAZUH_AGENT_NAME}/g" /var/ossec/etc/ossec.conf && \
    /var/ossec/bin/wazuh-control start

# Next, use openSUSE
FROM opensuse/leap:${OPENSUSE_VERSION} as opensuse
ARG WAZUH_AGENT_VERSION
ARG WAZUH_MANAGER
ARG WAZUH_AGENT_NAME
RUN zypper install -y wazuh-agent=${WAZUH_AGENT_VERSION} && \
    sed -i "s/MANAGER_IP/${WAZUH_MANAGER}/g" /var/ossec/etc/ossec.conf && \
    sed -i "s/AGENT_NAME/${WAZUH_AGENT_NAME}/g" /var/ossec/etc/ossec.conf && \
    /var/ossec/bin/wazuh-control start

# Next, use Ubuntu
FROM ubuntu:${UBUNTU_VERSION} as ubuntu
ARG WAZUH_AGENT_VERSION
ARG WAZUH_MANAGER
ARG WAZUH_AGENT_NAME
RUN apt-get update && apt-get install -y wget apt-transport-https lsb-release gnupg && \
    wget -qO - https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add - && \
    echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee /etc/apt/sources.list.d/wazuh.list && \
    apt-get update && apt-get install -y wazuh-agent=${WAZUH_AGENT_VERSION}-1 && \
    sed -i "s/MANAGER_IP/${WAZUH_MANAGER}/g" /var/ossec/etc/ossec.conf && \
    sed -i "s/AGENT_NAME/${WAZUH_AGENT_NAME}/g" /var/ossec/etc/ossec.conf && \
    /var/ossec/bin/wazuh-control start

# Next, use Debian
FROM debian:${DEBIAN_VERSION} as debian
ARG WAZUH_AGENT_VERSION
ARG WAZUH_MANAGER
ARG WAZUH_AGENT_NAME
RUN apt-get update && apt-get install -y wget apt-transport-https lsb-release gnupg && \
    wget -qO - https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add - && \
    echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | tee /etc/apt/sources.list.d/wazuh.list && \
    apt-get update && apt-get install -y wazuh-agent=${WAZUH_AGENT_VERSION}-1 && \
    sed -i "s/MANAGER_IP/${WAZUH_MANAGER}/g" /var/ossec/etc/ossec.conf && \
    sed -i "s/AGENT_NAME/${WAZUH_AGENT_NAME}/g" /var/ossec/etc/ossec.conf && \
    /var/ossec/bin/wazuh-control start

# Next, use Alpine
FROM alpine:${ALPINE_VERSION} as alpine
ARG WAZUH_AGENT_VERSION
ARG WAZUH_MANAGER
ARG WAZUH_AGENT_NAME
RUN apk add --no-cache bash wget && \
    wget -qO /etc/apk/keys/wazuh-key https://packages.wazuh.com/key/wazuh-key.gpg && \
    echo "https://packages.wazuh.com/4.x/alpine/" | tee /etc/apk/repositories && \
    apk update && apk add wazuh-agent=${WAZUH_AGENT_VERSION} && \
    sed -i "s/MANAGER_IP/${WAZUH_MANAGER}/g" /var/ossec/etc/ossec.conf && \
    sed -i "s/AGENT_NAME/${WAZUH_AGENT_NAME}/g" /var/ossec/etc/ossec.conf && \
    /var/ossec/bin/wazuh-control start

# Next, use Fedora
FROM fedora:${FEDORA_VERSION} as fedora
ARG WAZUH_AGENT_VERSION
ARG WAZUH_MANAGER
ARG WAZUH_AGENT_NAME
RUN dnf install -y wazuh-agent-${WAZUH_AGENT_VERSION} && \
    sed -i "s/MANAGER_IP/${WAZUH_MANAGER}/g" /var/ossec/etc/ossec.conf && \
    sed -i "s/AGENT_NAME/${WAZUH_AGENT_NAME}/g" /var/ossec/etc/ossec.conf && \
    /var/ossec/bin/wazuh-control start

# Finally, use Arch Linux
FROM archlinux:${ARCH_VERSION} as arch
ARG WAZUH_AGENT_VERSION
ARG WAZUH_MANAGER
ARG WAZUH_AGENT_NAME
RUN pacman -Syu --noconfirm wget && \
    wget -qO /etc/pacman.d/wazuh-key https://packages.wazuh.com/key/GPG-KEY-WAZUH && \
    echo "[wazuh]\nServer = https://packages.wazuh.com/4.x/arch/" | tee -a /etc/pacman.conf && \
    pacman -Sy --noconfirm wazuh-agent=${WAZUH_AGENT_VERSION} && \
    sed -i "s/MANAGER_IP/${WAZUH_MANAGER}/g" /var/ossec/etc/ossec.conf && \
    sed -i "s/AGENT_NAME/${WAZUH_AGENT_NAME}/g" /var/ossec/etc/ossec.conf && \
    /var/ossec/bin/wazuh-control start

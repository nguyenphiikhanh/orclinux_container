FROM oraclelinux:7.9

ARG SSH_USERNAME
ARG SSH_PASSWORD

# Install SSH & create user
RUN yum install -y openssh-server passwd sudo && \
    useradd -ms /bin/bash ${SSH_USERNAME} && \
    echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd && \
    echo "${SSH_USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# SSH settings
RUN mkdir -p /var/run/sshd && \
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

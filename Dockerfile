# login oracle registry before pull image: 
    # docker login container-registry.oracle.com

FROM container-registry.oracle.com/database/express:21.3.0-xe

ARG ORA_SSH_USER
ARG ORA_SSH_PASSWORD

USER root

RUN yum install -y openssh-server passwd sudo && \
    useradd -ms /bin/bash ${ORA_SSH_USER} && \
    echo "${ORA_SSH_USER}:${ORA_SSH_PASSWORD}" | chpasswd && \
    echo "${ORA_SSH_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /var/run/sshd && \
    ssh-keygen -A

RUN sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

COPY ./start/start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
ENTRYPOINT ["/start.sh"]
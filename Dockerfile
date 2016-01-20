FROM alpine:3.3
MAINTAINER Jérémy SEBAN <jeremy@seban.eu>

# Installing used software : 
RUN apk add --update openssh git && rm -rf /var/cache/apk/*

# Copying binaries
COPY ./bin/entrypoint /bin/entrypoint
COPY ./bin/lightgit /bin/lightgit
RUN chmod +x /bin/entrypoint
RUN chmod +x /bin/lightgit

# Copy SSHD configuration
COPY ./conf/sshd_config /etc/ssh/sshd_config
COPY ./conf/motd /etc/motd

# Configuring user
RUN mkdir -p /var/git/
RUN echo "git:x:1000:1000:git:/var/git:/usr/bin/git-shell" >> /etc/passwd
RUN echo "git:x:1000:" >> /etc/group

# Docker/Container related options
VOLUME ["/repos"]
EXPOSE 22
ENTRYPOINT ["/bin/entrypoint"]
CMD ["/usr/sbin/sshd", "-D"]
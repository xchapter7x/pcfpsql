FROM sameersbn/postgresql:9.4-4
MAINTAINER John Calabrese <xchapter7x@gmail.com>

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
COPY start.sh /sbin/start.sh
RUN chmod 755 /sbin/start.sh

#expose user/pass for each service we would need to test
ENV SSH_USER root
ENV SSH_PASS screencast
#(set by wercker) ENV DB_USER 
#(set by wercker) ENV DB_PASS 
EXPOSE 22
CMD ["/sbin/start.sh"]

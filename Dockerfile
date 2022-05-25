FROM centos


RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*


#RUN yum clearn all && yum update -y

RUN yum install -y httpd

ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]

ADD pacman/ /var/www/html/

EXPOSE 80
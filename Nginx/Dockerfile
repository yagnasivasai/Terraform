FROM almalinux

RUN yum update -y
RUN yum install httpd -y
RUN /usr/sbin/httpd

COPY ./nginx/* /var/www/html

EXPOSE 80

ENTRYPOINT httpd -D FOREGROUND

# FROM centos
# RUN yum -y install epel-release
# RUN yum -y update
# RUN yum -y install nginx
# COPY ./nginx/* /usr/share/nginx/html
# EXPOSE 80
# CMD ["nginx", "-g daemon off;"]
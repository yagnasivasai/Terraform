FROM centos
RUN yum -y install epel-release
RUN yum update -y && yum upgrade -y && yum install nginx -y
RUN echo "Hello nginx" >> /etc/nginx/html/index.html
EXPOSE 80
ENTRYPOINT [ "nginx" ]
CMD [ "-g daemon off" ]
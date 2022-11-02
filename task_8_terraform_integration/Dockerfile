FROM centos
RUN yum -y install epel-release
RUN yum -y update
RUN yum -y install nginx
COPY ./nginx/* /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g daemon off;"]
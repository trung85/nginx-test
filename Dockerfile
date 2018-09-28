FROM nginx:latest

#ADD ./server.conf /etc/nginx/conf.d/default.conf
RUN apt-get update
RUN apt-get install -y curl
ADD index.html /usr/share/nginx/html/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
CMD ["/usr/sbin/nginx"]

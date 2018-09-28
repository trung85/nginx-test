FROM nginx:latest

#ADD ./server.conf /etc/nginx/conf.d/default.conf
ADD index.html /usr/share/nginx/html/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
CMD ["/usr/sbin/nginx"]

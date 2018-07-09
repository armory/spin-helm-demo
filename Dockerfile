FROM nginx:alpine

ADD src/ /data/www/
ADD src/site.conf /etc/nginx/conf.d/
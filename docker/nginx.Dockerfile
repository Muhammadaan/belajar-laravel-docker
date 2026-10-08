FROM nginx:alpine
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY public /var/www/public
RUN ln -sfn /var/www/storage/app/public /var/www/public/storage
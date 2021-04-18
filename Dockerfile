FROM	debian:buster

LABEL	maintainer="youncho@student.42seoul.kr"

COPY	srcs/* tmp/

RUN		apt-get update && apt-get install -y \
		nginx \
		curl \
		openssl \
		vim \
		mariadb-server \
		php7.3-fpm \
		php7.3-mysql \
		php7.3-cli \
		php7.3-mbstring \
		wget

RUN		openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Cadet/CN=localhost" -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt
RUN		mv /tmp/default /etc/nginx/sites-available/default

RUN		wget https://wordpress.org/latest.tar.gz && tar -xvf latest.tar.gz -C /var/www/html/ && rm latest.tar.gz
RUN		mv /tmp/wp-config.php /var/www/html/wordpress/

RUN		service mysql start && \
		echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password && \
		echo "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user='root';" | mysql -u root --skip-password && \
		echo "GRANT ALL PRIVILEGES ON wordpress.* to 'root'@'localhost';" | mysql -u root --skip-password && \
		echo "FLUSH PRIVILEGES" | mysql -u root --skip-password

RUN		wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz && \
		tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz && \
		mv phpMyAdmin-5.0.2-all-languages /var/www/html/phpmyadmin && \
		mv /tmp/config.inc.php /var/www/html/phpmyadmin/

EXPOSE	80 443

CMD		bash /tmp/run.sh

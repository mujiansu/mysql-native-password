FROM oraclelinux:7-slim
ENV PACKAGE_URL https://repo.mysql.com/yum/mysql-8.0-community/docker/x86_64/mysql-community-server-minimal-8.0.11-1.el7.x86_64.rpm

# Install server
RUN rpmkeys --import http://repo.mysql.com/RPM-GPG-KEY-mysql \
  && yum install -y $PACKAGE_URL \
  && yum install -y libpwquality \
  && rm -rf /var/cache/yum/*
RUN mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306 33060
RUN sed -i '/^\[mysqld\]$/a\default-authentication-plugin=mysql_native_password' /etc/my.cnf
CMD ["mysqld"]

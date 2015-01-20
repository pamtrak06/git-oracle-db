FROM pamtrak06/ubuntu14.04-apache2

# Install php5
RUN apt-get update && apt-get install -y php5 php5-mysql ssh git

# set up oci library for php
RUN cd /tmp; sudo wget http://oss.oracle.com/el4/RPM-GPG-KEY-oracle
RUN sudo apt-key add /tmp/PM-GPG-KEY-oracle
RUN echo "deb http://oss.oracle.com/debian unstable main non-free" >> sources.list
RUN sudo apt-get update

# Install Oracle InstantClient
RUN su -; dd if=/dev/zero of=tmpswap bs=1M count=1000
RUN chmod 600 tmpswap; mkswap tmpswap; swapon tmpswap

# Oracle instant client prerequisite
RUN apt-get install -y libaio1
ADD oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm /tmp
RUN apt-get install -y alien
RUN alien -di /tmp/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
RUN alien -di /tmp/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm<
RUN export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client/lib:${LD_LIBRARY_PATH}

# Install oci prerequisite for php5
RUN apt-get install -y php-pear php5-dev build-essential oracle-xe-client

# Compile and install OCI8
RUN sudo pecl install oci8

# Configure apache
RUN echo "extension=oci8.so" >> /etc/php5/apache2/conf.d/oracle.ini
RUN echo "extension=oci8.so" >> /etc/php5/cli/php.ini

# Restart apache
RUN sudo /etc/init.d/apache2 restart

ENV PATH $PATH:/usr/lib/oracle/xe/app/oracle/product/10.2.0/client/bin

ADD tnsnames.ora /etc

# Install git
RUN install -y git

# Expose ports
EXPOSE 22 80 443


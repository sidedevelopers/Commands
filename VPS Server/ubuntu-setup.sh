Ubuntu 22.04 64-bit

# <- ############# Basic Configuration Start ############# ->

=> apt update
# fetches the latest information about available packages from the repositories specified in your software sources.
# This command does not upgrade or install any packages on your system.
# It simply refreshes the local package index, providing your system with the latest information about available packages.

=> apt upgrade
# used to upgrade the installed packages on your system to their latest versions

=> reboot
# After completing the updates and installing any additional software,
# it's a good idea to reboot your system

# <- ############# Apache Server Configuration Start ############# ->

=> systemctl status apache2
# First check status apache2 is installed or not

=> apt install apache2
=> systemctl start apache2
=> systemctl enable apache2
# this command ensures that Apache is set to start automatically every time your system boots up
# This command creates symbolic links to the Apache service unit files in the appropriate locations so that the service starts automatically during the system boot process.

=> systemctl restart apache2

=> apache2ctl configtest
# before restart apache it can help for errors before

=> apache2 -v

# <- ############# PHP Configuration Start ############# ->

=> apt install php libapache2-mod-php php-cli php-mbstring php-gd php-curl php-xml php-imagick php-json php-zip php-bcmath php-intl

php: The core PHP package.
libapache2-mod-php: The Apache module for PHP.
php-cli: The PHP command-line interpreter.
php-mbstring: Multibyte string support for PHP.
php-gd: GD Graphics Library support for PHP (used for image processing).
php-curl: cURL support for PHP (used for making HTTP requests).
php-xml: XML support for PHP.
php-imagick: ImageMagick support for PHP (used for image manipulation).
php-json: JSON support for PHP.
php-zip: Zip archive support for PHP.
php-bcmath: support for arbitrary precision mathematics in PHP.

=> systemctl restart apache2

# <- ############# Mysql Configuration Start ############# ->

=> apt install mysql-server
=> systemctl start mysql
=> systemctl enable mysql

=> systemctl status mysql

# Set Mysql Password
=> mysql -u root -p
# Enter Password: Press Enter
# By Default Password not set

mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Time202120@@mysql';
mysql> FLUSH PRIVILEGES;
mysql> exit;

# <- ############# Phpmyadmin Configuration Start ############# ->

=> apt install phpmyadmin

[*] apache2
[ ] lightspeed
Choose apache2 press "SPACE" and press "ENTER" to continue

# Next, you'll be asked if you want to configure the database for phpMyAdmin with 
# dbconfig-common. Choose "Yes."

# Set up a password for the phpMyAdmin application when prompted.

=> phpenmod mbstring
=> phpenmod zip
# After the installation is complete, you need to enable the PHP extensions required by phpMyAdmin

# First check zip and mbstring installed or not then enable above. 
=> php -m | grep zip
Output: zip
=> php -m | grep mbstring
Output: mbstring
# you will see it in the output. If there is no output, the zip module is not enabled.

=> systemctl restart apache2

Now live => http://ipaddress/phpmyadmin
# change this default url

=> vim /etc/phpmyadmin/apache.conf

Alias /phpmyadmin /usr/share/phpmyadmin
# change to
Alias /pythonbase /usr/share/phpmyadmin

=> systemctl restart apache2

Now => http://ipaddress/pythonbase

# check Phpmyadmin database import database size if (2M) then

=> vim /etc/php/8.1/apache2/php.ini (use cd in every step)
# upload_max_filesize=64M
# post_max_size=70M
# Please note that post_max_size needs to be larger than upload_max_filesize.

# <- ############# DNS Configuration Start ############# ->

# Godaddy A Records 
Type - A
Name - @
Data/Value - ip address
TTL - 1/2 hour (600 seconds)

# Godaddy CNAME Records
Type - CNAME
Name - www
Data/Value - domainname.com
TTL - 1 hour

# <- ############# Apache Server Configuration Start ############# ->

/etc/apache2/
|-- apache2.conf
|       `--  ports.conf
|-- mods-enabled
|       |-- *.load
|       `-- *.conf
|-- conf-enabled
|       `-- *.conf
|-- sites-enabled
|       `-- *.conf
          
=> apache2.conf is the main configuration file. It puts the pieces together by including all remaining 
configuration files when starting up the web server.

=> ports.conf is always included from the main configuration file. It is used to determine the listening
ports for incoming connections, and this file can be customized anytime.

=> Configuration files in the mods-enabled/, conf-enabled/ and sites-enabled/ directories contain particular
configuration snippets which manage modules, global configuration fragments, or virtual host configurations,
respectively.

=> They are activated by symlinking available configuration files from their respective *-available/ 
counterparts. These should be managed by using our helpers a2enmod, a2dismod, a2ensite, a2dissite, and 
a2enconf, a2disconf . See their respective man pages for detailed information.

=> The binary is called apache2 and is managed using systemd, so to start/stop the service use 
systemctl start apache2 and systemctl stop apache2, and use systemctl status apache2 and
journalctl -u apache2 to check status. system and apache2ctl can also be used for service management if 
desired. Calling /usr/bin/apache2 directly will not work with the default configuration.


=> cd /var/www/
=> mkdir domainname_logs
# First create logs folder near domain folder

=> cd /etc/apache2/sites-available
# create file domain.com.conf

# <----------- VirtualHost ----------->

<VirtualHost *:80>
ServerName domain.com
ServerAlias www.domain.com
ServerAdmin aman.tca1805002@tmu.ac.in
DocumentRoot /var/www/domain.com

ErrorLog /var/www/domainname_logs/error.log
CustomLog /var/www/domainname_logs/access.log combined

<Directory /var/www/domain.com>
Options -Indexes +FollowSymLinks
AllowOverride All
</Directory>

</VirtualHost>

# <----------- VirtualHost ----------->

ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
# By default error log path

=> a2ensite domain.com.conf
=> systemctl reload apache2

# Note:- by default 000-default.conf and default-ssl.conf files available
# do not touch that files and not need to disbale (a2disite)

=> chown -R www-data:www-data /var/www/domain.com

# <- ############# Rewrite Module Configuration For Wordpress Start ############# ->

# Note:- However, keep in mind that this assumes the Apache server is properly configured to 
# recognize .htaccess files. Make sure the mod_rewrite module is enabled.

=> a2enmod rewrite
# This used  for enable rewrite mod for .htaccess file
# if REST API Error occured and sub pages not working

=> systemctl reload apache2

=> apache2ctl -M | grep rewrite
Output -  rewrite_module (shared)
# if no output then rewite module not enabled
# check reqwrite module is enabled or not

# <- ############# SSL Configuration Start ############# ->

=> apt install certbot python3-certbot-apache

=> certbot --apache
# Registered a email
# Press Enter when it says for choose domains (blank enter means choose all domains)

=> Permanent Redirect to www

RewriteEngine on
RewriteCond %{SERVER_NAME} =www.theuktimes.co.uk [OR]
RewriteCond %{SERVER_NAME} =theuktimes.co.uk
RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]

# Replace With

RewriteEngine on
RewriteCond %{HTTP_HOST} !^www\.
RewriteRule ^ https://www.%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Now Set SSL Automatically renew

=> cd /etc/letsencrypt/renewal-hooks/deploy

=> vim reload-apache.sh 
# (add below content)

#!/bin/bash
systemctl reload apache2

=> chmod +x reload-apache.sh
# make it executable

=> cd /etc/letsencrypt/renewal

=> vim your_domain.com.conf

# Add the following line to the [renewalparams] section: (add in last)
deploy_hook = /etc/letsencrypt/renewal-hooks/deploy/reload-apache.sh

# Now, Certbot will reload Apache after each successful certificate renewal.

=> certbot renew --dry-run
# This command performs a dry run of the renewal process, which means it won't actually renew the 
# certificate but will check if the renewal process works as expected.

# <- ############# Mail Server Configuration Start ############# ->

=> hostname -f
Output:- srv464903.hstgr.cloud (but we used mail.domainname.com for FQDN)
# This command will display the FQDN of your server.

# Godaddy A Records (Same as multiple domains)
Type - A
Name - mail
Data/Value - ip address
TTL - 1/2 hour (600 seconds)

=> vim /etc/hosts
# add line (Same as multiple domains)
# ipaddress mail.domainname.com

=> apt install postfix
# press "TAB" for choose "OK"
# select "Internet Site"
# Enter Fully Qualified Domain Name - mail.domainname.com 

=> vim /etc/postfix/main.cf
# Check if myhostname is empty then add my hostname by (hostname -f)

=> systemctl restart postfix

=> apt install mailutils
# it helps for mail function run

=> echo "This is a test email" | mail -s "Test Subject" aman.tca1805002@tmu.ac.in
# After this mail successfully sent in spam folder

# Godaddy TXT Records (Same as multiple domains)
Type - TXT
Name - @
Data/Value - v=spf1 a mx include:mail.theuktimes.co.uk ~all
TTL - 1/2 hour (600 seconds)

# v=spf1: Denotes the SPF version.
# a: Allows the use of the domain's A (IPv4 address) record in the SPF check.
# mx: Allows the use of the domain's MX (mail exchange) records in the SPF check.
# include:mail.theuktimes.co.uk: Includes the SPF records from the specified domain (mail.theuktimes.co.uk)
# in the SPF check.
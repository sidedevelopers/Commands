Ubuntu 22.04 64-bit

# <----------- Basic Configuration Start ----------->

=> apt update
# fetches the latest information about available packages from the repositories specified in your software sources.
# This command does not upgrade or install any packages on your system.
# It simply refreshes the local package index, providing your system with the latest information about available packages.

=> apt upgrade
# used to upgrade the installed packages on your system to their latest versions

=> reboot
# After completing the updates and installing any additional software,
# it's a good idea to reboot your system

# <----------- Apache Server Configuration Start ----------->

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

# <----------- PHP Configuration Start ----------->

=> apt install php libapache2-mod-php php-cli php-mbstring php-gd php-curl php-xml php-imagick php-json php-zip php-bcmath

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

# <----------- Mysql Configuration Start ----------->

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

# <----------- Phpmyadmin Configuration Start ----------->

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

# <----------- Phpmyadmin Configuration Start ----------->
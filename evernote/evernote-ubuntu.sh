Fetch update software list by running sudo apt-get update command
- Update Ubuntu software by running sudo apt-get upgrade command
- Reboot the Ubuntu box if required by running sudo reboot

check Apache2 Status (check already installed)
1. service apache2 status
2. service apache2 restart
3. apache2 -v             //check apache version
4. apachectl -M   //display apache2 modules
5. man a2dismod  //it helps for checking how this a2dismod works
6. a2dismod php7.4   //it disables php 7.4
7. a2enmod php8.0   //it enable php8.0
8. apt install apache2
9. apache2ctl configtest  //before restart apache it can help for errors before

Add User
1. adduser pythonusr
2. usermod -aG sudo pythonusr    //For give root access to this user

Enable Firewall
1. sudo ufw status
2. apt-get install ufw
3. ufw allow openSSH    //allow using only ssh
4. ufw enable
5. ufw allow in "Apache Full"     //it gives apache full access to be public
6. Output after ufw status openSSH, Apache Full, openSSH(v6), Apache Full(v6) Allow Anywhere
7. ufw allow 25 && ufw allow 465 && ufw allow 587     //for mail port

Install PHP
1. apt install php libapache2-mod-php  php-mysql (php-mysql for auto configure with php and mysql)
2. sudo apt install software-properties-common  //it helps for install PPA all softwares
3. https://launchpad.net/~ondrej/+archive/ubuntu/apache2  see the latest version of apache 2 and run three commands
4. sudo add-apt-repository ppa:ondrej/apache2
5. apt update
6. apt upgrade //By this all softwares are latest version installed
7. https://launchpad.net/~ondrej/+archive/ubuntu/php  see the latest version of php and run three commands
8. add-apt-repository ppa:ondrej/php
9. apt-update
10. apt upgrade
11. apt install php-bcmath (BCMath extension)
12. https://www.javatpoint.com/downgrade-php-7-4-to-7-3-ubuntu

Install Mysql
1. apt install mysql-server
2. apt install php-mysql (Ignore this if you already installed this configuration on php installation time)
3. sudo chown mysql:mysql -R /var/lib/mysql (used when if ownership issue)
4. dpkg -l | grep mysql (impotant command to check which modules are installed)*


Install phpMyAdmin
1. sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl
2. It asked for server name select apache Hit "SPACE", "TAB", and then "ENTER" to select Apache (Please make sure it have * represent for select apache server) (Check Before this step Important)
3. Enter root password on installing time
4. check ip/phpmyadmin
5. sudo dpkg-reconfigure phpmyadmin (if by mistake not configure apache server phpmyadmin then run this reconfigured (Risk))
6. mysql  //open mysql
7. ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'MyStrongPassword1234$';
8. SELECT user,authentication_string,plugin,host FROM mysql.user;    (check authentication caching_sha2_password)
9. ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by 'mynewpassword'; (Mostly Cases use this) (most used method by various website suggest)
10. Next time for logging mysql use command         sudo mysql -u root -p
11. (Optional) Create a user for mysql login       CREATE USER 'harry'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'MyStrongPassword1234$';
12. (Optional) GRANT ALL PRIVILEGES ON *.* TO 'harry'@'localhost' WITH GRANT OPTION;       (Give all root permissions)
13. vim /etc/phpmyadmin/apache.conf
14. Alias /pythondatabse /usr/share/phpmyadmin
15. MySQL error 2006: mysql server has gone away (solution restart mysql)

Incorrect Format Parameter - Phpmyadmin Error (When import database and max import size 2MiB)
1. /etc/php/7.4/apache2/php.ini    (use cd in every step)
2. upload_max_filesize=64M      post_max_size=70M
3. Please note that post_max_size needs to be larger than upload_max_filesize.

Create Virtual Hosts
1. cd /etc/apache2/sites-available
2. Create virtual host with domainname.com.conf
3. chown ubuntu /etc/apache2/sites-available (where ubuntu is a user)-For write permission filezilla

<VirtualHost *:80>
ServerName theworldstimes.com
ServerAlias www.theworldstimes.com
ServerAdmin contact@theworldstimes.com
DocumentRoot /var/www/theworldstimes.com

ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined

<Directory /var/www/theworldstimes.com>
Options -Indexes +FollowSymLinks
AllowOverride All
</Directory>

</VirtualHost>
3. a2ensite domainname.com.conf
4. service apache2 restart
5. after this apache2ctl configtest (output syntax ok) For check any error in apache configuration
6. a2dissite 000-default.conf (first check domain is working or not and this file exist or not)
7. apachectl -S (Debug virtual domain if not working correctly)

Change Ownership of Files (When Plugin need ftp details)
1. ls -la   //check ownership user
2. cd /var/www
3. chmod -R www-data:www-data domain.com/ (use -R for all sub folders inside this folder and with this folder)
4. chown www-data:www-data <FILENAME> (For Only one new file) (without -R)
5. if file not upload by ubuntu user so use this command - chown -R ubuntu /var/www/html/domainnamefolder (AWS)

Rewrite Permisssion (When .htaccess file not working and permalinks not set)
1. cd /etc/apache2
2. vim apache2.conf
3. Find <Directory /var/www/> And make sure the AllowOverride directive is set to All
4. restart apache
5. sudo a2enmod rewrite (sudo is compulsory both root or non-root) (Try when permalink not working)
6. restart apache

Install SSL
1. sudo apt install certbot python3-certbot-apache
2. sudo ufw allow 'Apache Full'   (check first firewall installed or not and have full permission of apache)
3. sudo certbot --apache  (install for www and press 2 for redirection auto)
4. sudo systemctl status certbot.timer      //check auto renew
5. sudo certbot renew --dry-run
6. certbot revoke --cert-name example.com (for disable a certificate)
7. than go /etc/apache2/sites-available/example.com-ssl file
8. a2dissite example.com-ssl for disable ssl file (without remove this file it gives an error)

Install htop (For display memory cpu storage used)
1. apt-get install htop
2. sudo htop //run command

Check Ubuntu Details
1. lsb_release -a

Hostname
1. hostnamectl  //for see hostname and ubuntu details
2. hostname  //see only host name
3. hostnamectl set-hostname 'securemail.domain.com'       //for change hostname

Mails setup
1. apt install mailutils   //this package install mailx and mail function
2. echo "Message Body" | mail -s "Message Subject" receiver@example.com  //test mail
3. ufw allow 25 && ufw allow 465 && ufw allow 587     //for mail port
4. sudo DEBIAN_PRIORITY=low apt install postfix    //check sendmail installed or not. if installed remove sendmail first then install postfix
- General Type of Mail Configuration - Internet Site
- system Mail Name - domainname.com (not any subdomain or mail.domainname.com)
- Root and postmaster mail receipient - amanagarwal92594@gmail.com  (admin mail id)
- Other destinations to accept mail for - domainname.com, mail.domainname.com, localhost.$mydomain, www.$mydomain
- Force Synchronous Update for mail queue - No
- Local Networks - 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128  (by default set)
- use procmail for local delivery? (yes by default)
- Mailbox size limit (bytes): - 0 (by default)
- Internet protocols to use: ipv4 (if all then you need to add ptr record and aaaa record in dns)
5. sudo dpkg-reconfigure postfix   (Reconfigure postfix)
6. systemctl reload postfix
7. ufw allow Postfix   
8. vim /etc/aliases    //check root: mygmail.com
9. newaliases   (if changes in /etc/aliases then run command)

Note:-
libapache2-mod-php => This can communicate with apache2 and php auto configure
php-mysql => This can auto configured with php and mysql server

```
● mysql.service - MySQL Community Server
    Loaded: loaded (/lib/systemd/system/mysql.service; enabled; vendor preset:>
    Active: failed (Result: exit-code) since Thu 2022-04-14 10:51:40 UTC; 18h >
    Process: 410998 ExecStartPre=/usr/share/mysql/mysql-systemd-start pre (code>
    Process: 411006 ExecStart=/usr/sbin/mysqld (code=exited, status=1/FAILURE)
  Main PID: 411006 (code=exited, status=1/FAILURE)
    Status: "Server startup in progress"

Solution:-
Run command-
apt-get update
apt-get upgrade
It auto updates all mysql permissions and versions
```






Commands According to Video
https://www.youtube.com/watch?v=mCMw5ZMx_981. apt-get install apache2
2. apt-get install php libapache2-mod-php
3. apt-get install mysql-server
4. apt-get install phpmyadmin php-mbstring php-gettext (php-gettext not working)

if phpmyadmin 404 not found
1. sudo ln -s /etc/phpmyadmin /apache.conf /etc/apache2/conf-available/phpmyadmin.conf
2. sudo a2enconf phpmyadmin.conf




Mysql broken repair (dpkg: error processing package mysql-server (--configure))
https://askubuntu.com/questions/789686/dpkg-error-processing-package-mysql-server-configure

This error could also happens if the port (3306) is being used by another app. In my case, I had a docker container running mysql which was using the 3306 port, hence my local mysql installation fialed to configure.
```
$ sudo netstat -nltp | grep LISTEN | grep 3306
$ sudo netstat -nltp | grep LISTEN | grep 3306
tcp6      0      0 :::3306                :::*                    LISTEN      1017033/docker-prox

sudo apt purge --auto-remove mysql*
sudo rm -r /etc/mysql
sudo rm -r /var/lib/mysql*

sudo apt install mysql-client-8.0 mysql-server-8.0 --fix-broken -y
```



RRset www.agsmsecurity.com. IN A: Conflicts with pre-existing RRset


//on fresh install mysql-server
```
root@agsmsecurity:~# dpkg -l | grep mysql
ii  libmysqlclient21:amd64        8.0.30-0ubuntu0.20.04.2            amd64        MySQL database client library
ii  mysql-client-8.0              8.0.30-0ubuntu0.20.04.2            amd64        MySQL database client binaries
ii  mysql-client-core-8.0        8.0.30-0ubuntu0.20.04.2            amd64        MySQL database core client binaries
ii  mysql-common                  5.8+1.0.5ubuntu2                    all          MySQL database common files, e.g. /etc/mysql/my.cnf
ii  mysql-server                  8.0.30-0ubuntu0.20.04.2            all          MySQL database server (metapackage depending on the latest version)
ii  mysql-server-8.0              8.0.30-0ubuntu0.20.04.2            amd64        MySQL database server binaries and system database setup
ii  mysql-server-core-8.0        8.0.30-0ubuntu0.20.04.2            amd64        MySQL database server binaries
```


AWS Commands For Ubuntu
1. For check OS in ubuntu => cat /etc/os-release
2. For check RAM => free -m
3. For check how many CPU available => lscpu
4. For check storage => df -h
5. For check private ip address => ip a
6. sudo su OR sudo -i
7. nginx -t (For check nginx installed or not)
8. install nginx (apt-get install nginx)
9. service nginx status (check status)


https://aws.amazon.com/ec2/instance-types/
5 Type of instances
1. General Purpose - Equal cpu memory all...   t2.m
2. Compute Optimized - Gaming, fast computing
3. Memory Optimized - where memory calculations are used
4. Accelerated Optimized - for machine learning websites
5. Storage Optimized - where storage are most used like udemy





Final Steps For Install Ubuntu in VPS
apt-get install apache2 (Y)
apt-get install php libapache2-mod-php (Y)
apt-get install phpmyadmin php-mbstring (Y) (prompt- apache2, yes, mysql password)
apt-get install php-zip php-gd php-json php-curl
apt-get install php-bcmath (Y)
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by 'mynewpassword';


internal server error 500
use command - a2enmod rewrite







Memory
top (run command and check memory usage)(press 'q' for exit)
free (run command for check memory usage without GB/MB/KB)
free -h (for human readable format in GB/MB/KB)
# https://devanswe.rs/how-to-auto-restart-a-crashed-mysql-service-with-cron/
# Create a Script to Auto Restart MySQL

1. cd /home/
2. sudo mkdir scripts
3. cd scripts
4. vim mysqlmon.sh
5. Paste the following code

#!/bin/bash

# Check if MySQL is running
sudo service mysql status > /dev/null 2>&1

# Restart the MySQL service if it's not running.
if [ $? != 0 ]; then
    echo -e "MySQL Service was down. Restarting now...\n"
    sudo service mysql restart
else
    echo -e "MySQL Service is running already. Nothing to do here.\n"
fi

6. sudo chmod +x mysqlmon.sh

# Test the Script to Auto Restart MySQL
7. sudo ./mysqlmon.sh
# (Output Display in this step)

8. sudo service mysql stop (stop the mysql for checking)
9. sudo ./mysqlmon.sh (Run the script Manually)


# Add the MySQL Auto Restart Script to Crontab
10. sudo crontab -e
11. Add following code (the script run once a minute)
* * * * * /home/scripts/mysqlmon.sh > /dev/null 2>&1

Final step for test stop mysql and after 1 minute its auto restart
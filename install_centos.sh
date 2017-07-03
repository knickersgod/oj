#!/bin/bash
#	chenge your /home/judge/etc/judge.conf 
#	adminuser and passwd for your user
#CENTOS/REDHAT/FEDORA WEBBASE=/var/www/html APACHEUSER=apache 

WEBBASE=/var/www/html
APACHEUSER=apache
DBUSER=root
DBPASS=root

sudo yum -y update
sudo yum -y install php httpd php-mysql  php-xml php-gd gcc-c++ mysql-server mysql-devel php-mbstring glibc-static flex git fresh
sudo service mysqld start
sudo mysqladmin -u root password root

sudo git clone https://github.com/zhblue/hustoj.git

#create user and homedir
sudo  /usr/sbin/useradd -m -u 1536 judge



#compile and install the core
cd ../
mv ./oj/php /etc/php.ini
mv ./oj/judged ./oj/hustoj/trunk/core/judged/makefile
mv ./oj/judge_client ./oj/hustoj/trunk/core/judge_client/makefile
sudo ./oj/hustoj/trunk/core/make.sh
#install web and db
sudo cp -R ./oj/hustoj/trunk/web $WEBBASE/JudgeOnline
sudo chmod -R 771 $WEBBASE/JudgeOnline
sudo chown -R $APACHEUSER $WEBBASE/JudgeOnline
sudo mysql -h localhost -u$DBUSER -p$DBPASS < db.sql

#create work dir set default conf

sudo    mkdir /home/judge
sudo    mkdir /home/judge/etc
sudo    mkdir /home/judge/data
sudo    mkdir /home/judge/log
sudo    mkdir /home/judge/run0
sudo    mkdir /home/judge/run1
sudo    mkdir /home/judge/run2
sudo    mkdir /home/judge/run3
cd ./oj/hustoj/trunk/install/
sudo cp java0.policy  judge.conf /home/judge/etc
sudo chown -R judge /home/judge
sudo chgrp -R $APACHEUSER /home/judge/data
sudo chgrp -R root /home/judge/etc /home/judge/run?
sudo chmod 775 /home/judge /home/judge/data /home/judge/etc /home/judge/run?

#boot up judged
sudo cp judged /etc/init.d/judged
sudo chmod +x  /etc/init.d/judged
sudo ln -s /etc/init.d/judged /etc/rc3.d/S93judged
sudo ln -s /etc/init.d/judged /etc/rc2.d/S93judged
sudo echo '/usr/bin/judged' > /etc/init.d/judged
sudo /etc/init.d/judged start
sudo /etc/init.d/httpd restart


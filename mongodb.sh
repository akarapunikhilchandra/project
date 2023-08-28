#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/opt/
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

cp /home/centos/project/ /etc/yum.repos.d/mongo.repo ?>> $LOGFILE

VALIDATE $? "copy successfull"

yum install mongodb-org -y ?>> $LOGFILE

VALIDATE $? "installing mongodb"

systemctl enable mongod ?>> $LOGFILE

VALIDATE $? "enabling mongodb"

systemctl start mongod ?>> $LOGFILE

VALIDATE $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf ?>> $LOGFILE

VALIDATE $? "changed 127.0.0.1 to 0.0.0.0"

systemctl restart mongod ?>> $LOGFILE

VALIDATE $? "restarting mongodb"
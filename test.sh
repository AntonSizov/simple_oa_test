#!/bin/bash

# settings
SEND_MT="./kelly/rel/files/send_mt_msgs"
ACC_LOG="/var/log/kannel/access.log"
TEXT="test_sms"

# null kannel access logs
echo '' > $ACC_LOG

# send test sms
echo -n Send test sms...
$SEND_MT -q -c 1 -d 31 -b $TEXT > /dev/null
echo OK

# wait for kannel regiter sent sms in log files
sleep 1

# search for sent sms id pattern
ID=`grep 'Sent SMS' $ACC_LOG | grep $TEXT | tail -1 | awk '{print $9}'`
echo Sent sms id: $ID

# escape pattern
ESCAPED_PATTERN=`printf "%q" $ID`

# wait for delivery
echo Wait for delivery receipt...
sleep 10

# search for delivered report
DELIVERY=`grep $ESCAPED_PATTERN $ACC_LOG | grep DELIVRD`

if [[ "$DELIVERY" == "" ]];then
	echo Deliver not found
else
	echo Delivery found
fi
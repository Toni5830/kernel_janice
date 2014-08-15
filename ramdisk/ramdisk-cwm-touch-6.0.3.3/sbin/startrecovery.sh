#!/sbin/sh

if [ -f /started_cwm ]
then
	exit 1
fi

/sbin/recovery &

sleep 5

id=`ps | grep /sbin/recovery | cut -b 6-16 `

kill $id

/sbin/recovery &

echo 1 > /started_cwm

exit 1

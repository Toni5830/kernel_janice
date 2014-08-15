#!/sbin/sh

# Workaround to boot up recovery!

# Wait for loading recovery
sleep 10

# kill recovery
id=`ps | grep /sbin/recovery | cut -b6-12 `
kill $id


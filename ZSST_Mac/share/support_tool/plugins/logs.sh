#!/bin/bash
ZSST_PLUGIN_NAME="Zend Server Logs Collector"
exec >> $ZEND_ERROR_LOG 2>&1


ZSST_MAIN_LOGS=$ZEND_DATA_TMPDIR/zend_logs
ZSST_GUI_LOGS=$ZEND_DATA_TMPDIR/lighttpd_logs

# Main logs start
mkdir $ZSST_MAIN_LOGS

if [ $FULLLOGS ]; then

	cp -RL $ZCE_PREFIX/var/log/* $ZSST_MAIN_LOGS/

else

	fcount=0
	for zslog in $ZCE_PREFIX/var/log/*[a-z].log; do
		if [ -s $zslog ]; then
			tail -n1000 $zslog > $ZSST_MAIN_LOGS/$(basename ${zslog})
			fcount=$(expr $fcount + 1)
		fi
	done

	ls -hAlF $ZCE_PREFIX/var/log/ > $ZSST_MAIN_LOGS/listing.txt
	llines=$(cat $ZSST_MAIN_LOGS/listing.txt | tail -n+2 | wc -l)
	mv $ZSST_MAIN_LOGS/listing.txt "${ZSST_MAIN_LOGS}/${fcount}_of_${llines}.files"

fi
# Main logs end



# GUI Logs
cp -RH $ZCE_PREFIX/gui/lighttpd/logs $ZSST_GUI_LOGS








#!/bin/sh

cat << EOF
#!/bin/sh
# dkim-milter daemon start/stop script.

# Usually this is put in /etc/init.d (at least on machines SYSV R4 based
# systems) and linked to /etc/rc3.d/S99dkim-milter and /etc/rc0.d/K01dkim-milter.
### BEGIN INIT INFO
# Provides: dkim-milter
# Required-Start: \$local_fs \$network \$remote_fs
# Required-Stop: \$local_fs \$network \$remote_fs
# Default-Start:  2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: start and stop dkim-milter
# Description: dkim-milter.
### END INIT INFO
dkimmilter=${dkimbuilddir}bin/dkim-filter
conf=${dkimdatadir}conf/dkim.conf
pid=${rundir}dkim.pid
sock=${rundir}dkim.sock

iffailed()
{
	if [ "\$?" != "\$1" ]
	then
		echo " \$2"
		exit 1
	fi
}

case "\$1" in
	start)
		echo -n "Starting dkim-milter "
		ls \$pid 2>/dev/null 1>&2
		if [ \$? = "0" ]
		then
			ps -p \`cat \$pid\` -o pid h >/dev/null
			iffailed 1 " already running"
		fi
		\$dkimmilter -x \$conf
		iffailed 0 " failed"
		echo " done"
	;;

	stop)
		echo -n "Stoping dkim-milter "
		ls \$pid 2>/dev/null 1>&2
		iffailed 0 " pid file does not exist"
		ps -p \`cat \$pid\` -o pid h >/dev/null
		iffailed 0 " is not running"
		kill -s TERM \`cat \$pid\`
		iffailed 0 " failed"
		rm \$pid \$sock
		echo " done"
	;;
	reload)
		echo -n "Stoping dkim-milter "
		ls \$pid 2>/dev/null 1>&2
		iffailed 0 " pid file does not exist"
		ps -p \`cat \$pid\` -o pid h >/dev/null
		iffailed 0 " is not running"
		kill -s USR1 \`cat \$pid\`
		iffailed 0 " failed"
		echo " done"
	;;

	*)
		echo "Usage: \$0 {start|stop}"
		exit 1
	;;

esac
EOF
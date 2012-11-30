class PS
	
	include RunCommand
	
	command :ps, :fe => ""
	
end

# UID        PID  PPID  C STIME TTY          TIME CMD
# root         1     0  0 Aug14 ?        00:00:12 init
# root         2     1  0 Aug14 ?        00:00:00 [kthreadd/306329]
# root         3     2  0 Aug14 ?        00:00:00 [khelper/306329]
# root         4     2  0 Aug14 ?        00:00:00 [rpciod/306329/0]
# root         5     2  0 Aug14 ?        00:00:00 [rpciod/306329/1]
# root         6     2  0 Aug14 ?        00:00:00 [rpciod/306329/2]
# root         7     2  0 Aug14 ?        00:00:00 [rpciod/306329/3]
# root         8     2  0 Aug14 ?        00:00:00 [rpciod/306329/4]
# root         9     2  0 Aug14 ?        00:00:00 [rpciod/306329/5]
# root        10     2  0 Aug14 ?        00:00:00 [rpciod/306329/6]
# root        11     2  0 Aug14 ?        00:00:00 [rpciod/306329/7]
# root        12     2  0 Aug14 ?        00:00:00 [rpciod/306329/8]
# root        13     2  0 Aug14 ?        00:00:00 [rpciod/306329/9]
# root        14     2  0 Aug14 ?        00:00:00 [rpciod/306329/1]
# root        15     2  0 Aug14 ?        00:00:00 [rpciod/306329/1]
# root        16     2  0 Aug14 ?        00:00:00 [rpciod/306329/1]
# root        17     2  0 Aug14 ?        00:00:00 [rpciod/306329/1]
# root        18     2  0 Aug14 ?        00:00:00 [rpciod/306329/1]
# root        19     2  0 Aug14 ?        00:00:00 [rpciod/306329/1]
# root        20     2  0 Aug14 ?        00:00:00 [rpciod/306329/1]
# root        21     2  0 Aug14 ?        00:00:00 [rpciod/306329/1]
# root        22     2  0 Aug14 ?        00:00:00 [rpciod/306329/1]
# root        23     2  0 Aug14 ?        00:00:00 [rpciod/306329/1]
# root        24     2  0 Aug14 ?        00:00:00 [rpciod/306329/2]
# root        25     2  0 Aug14 ?        00:00:00 [rpciod/306329/2]
# root        26     2  0 Aug14 ?        00:00:00 [rpciod/306329/2]
# root        27     2  0 Aug14 ?        00:00:00 [rpciod/306329/2]
# root        28     2  0 Aug14 ?        00:00:00 [nfsiod/306329]
# root       167     1  0 Aug14 ?        00:00:03 /usr/sbin/sshd
# root       173     1  0 Aug14 ?        00:00:35 cron
# www-data  5856 24274  0 Nov22 ?        00:01:27 /usr/bin/php5-cgi
# mysql     5986     1  0 Sep28 ?        00:36:33 /usr/sbin/mysqld
# opendkim  6479     1  0 Nov26 ?        00:41:09 /usr/sbin/opendkim -x /etc/opendkim.conf -u opendkim -P /var/run/opendkim/opendkim.pid -p inet:8891@localhost
# www-data  6808 24274  0 Nov22 ?        00:01:27 /usr/bin/php5-cgi
# www-data  8167 24274  0 Nov22 ?        00:01:28 /usr/bin/php5-cgi
# www-data  8928 24274  0 Nov23 ?        00:01:27 /usr/bin/php5-cgi
# www-data  9878 24274  0 Nov23 ?        00:01:26 /usr/bin/php5-cgi
# www-data 10165 24274  0 Nov23 ?        00:01:26 /usr/bin/php5-cgi
# bind     14068     1  0 Sep27 ?        00:00:01 /usr/sbin/named -u bind
# root     14452     1  0 Sep27 ?        00:00:00 /usr/sbin/xinetd -pidfile /var/run/xinetd.pid -stayalive -inetd_compat -inetd_ipv6
# newrelic 14563     1  0 Sep27 ?        00:00:00 /usr/sbin/nrsysmond -c /etc/newrelic/nrsysmond.cfg -p /var/run/nrsysmond.pid
# newrelic 14564 14563  0 Sep27 ?        00:34:49 /usr/sbin/nrsysmond -c /etc/newrelic/nrsysmond.cfg -p /var/run/nrsysmond.pid
# root     19086     1  0 Nov09 ?        00:00:00 nginx: master process /usr/local/nginx/sbin/nginx
# www-data 19087 19086  0 Nov09 ?        00:03:13 nginx: worker process      
# www-data 19088 19086  0 Nov09 ?        00:00:08 nginx: cache manager process
# root     20599   167  0 12:41 ?        00:00:00 sshd: john [priv]
# john     20643 20599  0 12:41 ?        00:00:00 sshd: john@pts/0 
# john     20644 20643  0 12:41 pts/0    00:00:00 -bash
# opendkim 21110  6479  0 Nov26 ?        00:00:02 /usr/sbin/opendkim -x /etc/opendkim.conf -u opendkim -P /var/run/opendkim/opendkim.pid -p inet:8891@localhost
# root     21294     1  0 Nov26 ?        00:09:01 python /usr/sbin/denyhosts --daemon --purge --config=/etc/denyhosts.conf --config=/etc/denyhosts.conf
# postfix  21640 23243  0 13:44 ?        00:00:00 pickup -l -t fifo -u -c
# root     21825   173  0 14:02 ?        00:00:00 CRON
# john     21826 21825  0 14:02 ?        00:00:00 /bin/sh -c /usr/local/bin/scout 13be5710-58d9-4978-bfed-39563cb12d5e
# john     21827 21826  2 14:02 ?        00:00:00 /usr/local/bin/ruby /usr/local/bin/scout 13be5710-58d9-4978-bfed-39563cb12d5e
# john     21829 20644  0 14:02 pts/0    00:00:00 ps -fe
# syslog   22263     1  0 Nov26 ?        00:00:05 rsyslogd -c4
# root     23243     1  0 Nov26 ?        00:00:04 /usr/lib/postfix/master
# postfix  23245 23243  0 Nov26 ?        00:00:02 qmgr -l -t fifo -u
# postfix  23250 23243  0 Nov26 ?        00:00:01 tlsmgr -l -t unix -u -c
# www-data 24274     1  0 Sep27 ?        00:00:00 /usr/bin/php5-cgi
# john     29285     1  0 Aug17 ?        10:09:54 redis-server /home/john/Products/Avenue/config/redis.conf
# john     32529     1  0 Aug17 ?        06:12:07 bluepilld: Cozy
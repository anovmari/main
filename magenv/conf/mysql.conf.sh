#!/bin/bash

cat <<EOF # The following options will be passed to all MySQL clients
[client]
port		= 3306
socket		= ${mysqldir}var/mysql.sock

# Here follows entries for some specific programs

# The MySQL server
[mysqld]
datadir	= ${mysqldir}var/data/
port		= 3306
socket		= ${mysqldir}var/mysql.sock

pid-file	= ${mysqldir}var/mysql.pid
general_log
general_log_file = ${mysqldir}var/log/general.log
log-error = ${mysqldir}var/log/error.log
log-isam = ${mysqldir}var/log/myisam.log
log-bin=${mysqldir}var/log/log-bin.log
log-bin-index = ${mysqldir}var/log/bin-index.log
log-slow-admin-statements
log-slow-slave-statements
log-tc=${mysqldir}var/log/log-tc.log
log-warnings
log-output=FILE
long_query_time = 1
relay-log = ${mysqldir}var/log/relay.log
relay-log-index = ${mysqldir}var/log/relay-index.log
relay-log-info-file = ${mysqldir}var/log/relay-log-info.log
slow-query-log
slow_query_log_file = ${mysqldir}var/log/slow.log
log-queries-not-using-indexes
log-slave-updates
innodb=ON
innodb_data_home_dir = ${mysqldir}var/innodb/
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = ${mysqldir}var/log/innodb/
innodb_buffer_pool_size = 16M
innodb_additional_mem_pool_size = 2M
innodb_log_file_size = 5M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 50
tmpdir = ${mysqldir}tmp/


skip-external-locking
key_buffer_size = 16M
max_allowed_packet = 1M
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M

# Don't listen on a TCP/IP port at all. This can be a security enhancement,
# if all processes that need to connect to mysqld run on the same host.
# All interaction with mysqld must be made via Unix sockets or named pipes.
# Note that using this option without enabling named pipes on Windows
# (via the "enable-named-pipe" option) will render mysqld useless!
# 
skip-networking

# Replication Master Server (default)
# binary logging is required for replication
log-bin=${mysqldir}var/log/mysql-bin

# binary logging format - mixed recommended
binlog_format=mixed

# required unique id between 1 and 2^32 - 1
# defaults to 1 if master-host is not set
# but will not function as a master if omitted
server-id	= 1

# Replication Slave (comment out master section to use this)
#
# To configure this host as a replication slave, you can choose between
# two methods :
#
# 1) Use the CHANGE MASTER TO command (fully described in our manual) -
#    the syntax is:
#
#    CHANGE MASTER TO MASTER_HOST=<host>, MASTER_PORT=<port>,
#    MASTER_USER=<user>, MASTER_PASSWORD=<password> ;
#
#    where you replace <host>, <user>, <password> by quoted strings and
#    <port> by the master's port number (3306 by default).
#
#    Example:
#
#    CHANGE MASTER TO MASTER_HOST='125.564.12.1', MASTER_PORT=3306,
#    MASTER_USER='joe', MASTER_PASSWORD='secret';
#
# OR
#
# 2) Set the variables below. However, in case you choose this method, then
#    start replication for the first time (even unsuccessfully, for example
#    if you mistyped the password in master-password and the slave fails to
#    connect), the slave will create a master.info file, and any later
#    change in this file to the variables' values below will be ignored and
#    overridden by the content of the master.info file, unless you shutdown
#    the slave server, delete master.info and restart the slaver server.
#    For that reason, you may want to leave the lines below untouched
#    (commented) and instead use CHANGE MASTER TO (see above)
#
# required unique id between 2 and 2^32 - 1
# (and different from the master)
# defaults to 2 if master-host is set
# but will not function as a slave if omitted
#server-id       = 2
#
# The replication master for this slave - required
#master-host     =   <hostname>
#
# The username the slave will use for authentication when connecting
# to the master - required
#master-user     =   <username>
#
# The password the slave will authenticate with when connecting to
# the master - required
#master-password =   <password>
#
# The port the master is listening on.
# optional - defaults to 3306
#master-port     =  <port>
#
# binary logging - not required for slaves, but recommended
#log-bin=mysql-bin

# Point the following paths to different dedicated disks
#log-update 	= /path-to-dedicated-directory/hostname

# Uncomment the following if you are using InnoDB tables
# You can set .._buffer_pool_size up to 50 - 80 %
# of RAM but beware of setting memory usage too high
# Set .._log_file_size to 25 % of buffer pool size

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash
# Remove the next comment character if you are not familiar with SQL
#safe-updates

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EOF

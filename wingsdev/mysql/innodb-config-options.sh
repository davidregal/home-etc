# Starting MySQL 5.5, InnoDB becomes the default storage engine replacing MyISAM. There are many performance improvements in this release. In particular, crash recovery, the automatic process that makes all data consistent when the database is restarted, is fast and reliable. (Now much much faster than long-time InnoDB users are used to.) The bigger the database, the more dramatic the speedup.
#
# Tweaking and optimizing your MySQL database server is quite subjective, with a lot of conditions and variables need to consider. Following settings might help you improve and delivering the great InnoDB database by putting the specific value in my.cnf of your server:

# Credit: http://blog.secaserver.com/2011/08/mysql-recommended-my-cnf-settings-innodb-engine/

# Description
# Options
# * InnoDB
#
# InnoDB is enabled by default with a 10MB datafile in /var/lib/mysql/.
# Read the manual for more InnoDB related options. There are many!
#

# Starting MySQL 5.5, InnoDB becomes the default storage engine replacing MyISAM. There are many performance improvements in this release. In particular, crash recovery, the automatic process that makes all data consistent when the database is restarted, is fast and reliable. (Now much much faster than long-time InnoDB users are used to.) The bigger the database, the more dramatic the speedup.
#
# Tweaking and optimizing your MySQL database server is quite subjective, with a lot of conditions and variables need to consider. Following settings might help you improve and delivering the great InnoDB database by putting the specific value in my.cnf of your server:

# Credit: http://blog.secaserver.com/2011/08/mysql-recommended-my-cnf-settings-innodb-engine/

# Description
# Options

# Default is 128M. 70-80% of memory for dedicated 64bit MySQL server. Example: 12G on 16GB box. The larger you set this value, the less disk I/O is needed to access data in tables.
# Set buffer pool size to 50-80% of your computer's memory
# Production:
#innodb_buffer_pool_size=12G
# Development:
innodb_buffer_pool_size=256M

# Update and delete operations are buffered in addition to insert
innodb_change_buffering=all

# Additional memory for InnoDB miscellaneous needs..
innodb_additional_mem_pool_size=20M

# Increase performance in optimize, backup, restore, compress and truncating a table
innodb_file_per_table

# Set the log file size to about 25% of the buffer pool size.
# If innodb_log_file_size is changed, then need to move /var/lib/mysql/ib_logfile* before starting mysql.
# Production:
#innodb_log_file_size=2048M
# Development:
innodb_log_file_size = 64M

# Default is 8M. 16M is good for most cases unless you’re piping large blobs to InnoDB in this case increase it a bit. Larger the number less disk IO usage (suitable for large transaction DB)
# Production:
#innodb_log_buffer_size=16M
# Development:
# None. Default.

# Set to 1 if database transaction is more important than performance. Set to 2 if performance is more important than transaction.
innodb_flush_log_at_trx_commit=1

# Default is 0. Usually 2 x no of core
# Production:
#innodb_thread_concurrency=8
# Development:
innodb_thread_concurrency=2

# This to avoid double buffering and reduce swap pressure, in most cases this setting improves performance
innodb_flush_method=O_DIRECT

# If using MySQL 5.5 only. Default is 4. Better 4 x no of core
# Production:
#innodb_read_io_threads=16
# Development:
# Use default.

# If using MySQL 5.5 only. Default is 4. Better 4 x no of core
# Production:
#innodb_write_io_threads=16
# Development:
# Use default.

# Default is 200. If SATA = 100. If SAS = 200. If RAID 5, 10 = 500
# Production:
#innodb_io_capacity=?
# Development:
# Use default.

# Default is 50 seconds. Increase the value for reliability or decrease for performance
innodb_lock_wait_timeout=120

# If innodb_data_home_dir or innodb_data_file_path are changed, then need to move ibdata* and /var/lib/mysql/ib_logfile* ib_logfile* before starting mysql.
innodb_data_home_dir = /var/lib/mysql/ibdata
# A tablespace containing a fixed-size 50MB data file named ibdata1 and a 50MB auto-extending file named ibdata2 in the data directory. Sizes are specified using K, M, or G suffix letters to indicate units of KB, MB, or GB. Data files must be able to hold your data and indexes total size.
# Production:
#innodb_data_file_path=ibdata1:50M;ibdata2:50M:autoextend
# Development:
innodb_data_file_path=ibdata1:50M;ibdata2:50M:autoextend

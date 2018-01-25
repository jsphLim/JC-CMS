#!/bin/sh
DUMP=/usr/bin/mysqldump			# mysqldump
OUT_DIR=/home/mysql_data 		# 备份目录
DB_NAME=admin 				# 备份数据库
DB_USER=root 				# 数据库账号
DATE=`date +%Y%m%d%H%M` 		# 系统时间
OUT_SQL="mysqldata_bak_$DATE.sql.gz"	# 备份文件
DAYS=7					# 有效时间

########################################
cd $OUT_DIR									# 进入目录
$DUMP -u$DB_USER --databases $DB_NAME | gzip -9 > $OUT_SQL			# 备份命令
find $OUT_DIR -name "mysqldata_bak*" -type f -mtime +$DAYS -exec rm -f {} \;	# 清理命令

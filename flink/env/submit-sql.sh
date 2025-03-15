#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 检查参数
if [ "$#" -ne 1 ]; then
    echo "使用方法: $0 <SQL文件路径>"
    echo "例如: $0 ../sql/01_create_table_orders.sql"
    exit 1
fi

SQL_FILE=$1

# 检查SQL文件是否存在
if [ ! -f "$SQL_FILE" ]; then
    echo "错误: SQL文件 '$SQL_FILE' 不存在"
    exit 1
fi

echo "正在提交SQL任务..."
docker-compose exec jobmanager ./bin/sql-client.sh -f ${SQL_FILE}

echo "SQL任务已提交" 
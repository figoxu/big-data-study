#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 当前目录就是flink/env，不需要再切换
# 停止并删除容器
echo "正在停止Flink环境..."
docker-compose down

echo "Flink环境已停止" 
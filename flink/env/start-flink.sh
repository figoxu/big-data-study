#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 当前目录就是flink/env，不需要再切换
# 检查docker-compose.yml文件是否存在
if [ ! -f "docker-compose.yml" ]; then
    echo "错误: docker-compose.yml 文件不存在"
    exit 1
fi

# 启动flink环境
echo "正在启动Flink环境..."
docker-compose up -d

# 等待服务启动
echo "等待服务启动..."
sleep 10

# 显示容器状态
docker-compose ps

echo "Flink UI 可以通过以下地址访问: http://localhost:8081"
echo "使用以下命令可以查看日志:"
echo "docker-compose logs -f jobmanager"
echo "docker-compose logs -f taskmanager" 
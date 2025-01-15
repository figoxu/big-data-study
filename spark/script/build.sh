#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# 获取项目根目录（假设在script目录的上一级）
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

function main() {
    # 切换到项目根目录
    cd "$PROJECT_ROOT"

    echo "开始构建项目..."
    # 编译打包
    mvn clean package

    echo "提交任务到Spark集群..."
    # 提交到Spark集群运行
    spark-submit \
        --class com.example.WordCount \
        --master spark://localhost:7077 \
        --deploy-mode client \
        --conf spark.driver.host=host.docker.internal \
        --conf spark.driver.bindAddress=0.0.0.0 \
        --driver-memory 1g \
        --executor-memory 1g \
        "target/spark-figoxu-1.0-SNAPSHOT.jar"

    # 返回到原始目录
    cd - > /dev/null
}

  main
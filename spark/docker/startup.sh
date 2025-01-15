#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function main(){
    # 切换到docker-compose.yml所在目录
    cd "${SCRIPT_DIR}"
    docker-compose up -d
}

# 执行主函数
main


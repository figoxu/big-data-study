# Flink SQL Insert Into 详解

这篇文档主要讲解了在 Flink SQL 中如何使用 `INSERT INTO` 语句将数据插入到表中，以便下游应用程序可以读取这些数据。

## Docker 环境操作指南

### 1. 启动 Flink 集群
```bash
# 在 docker-compose.yml 所在目录执行
docker-compose up -d
```

### 2. 进入 SQL Client
```bash
# 进入 JobManager 容器的 SQL Client
docker exec -it $(docker ps -qf "name=jobmanager") ./bin/sql-client.sh
```

### 3. 验证环境
- 访问 Flink Web UI: http://localhost:8081
- 确认 JobManager 和 TaskManager 状态正常

### 4. 目录挂载说明
- SQL 文件位置：`../sql:/opt/sql`
- 可以在容器内访问 `/opt/sql` 目录下的 SQL 文件

### 5. 常用 Docker 命令
```bash
# 查看容器状态
docker-compose ps

# 查看容器日志
docker-compose logs -f jobmanager
docker-compose logs -f taskmanager

# 停止集群
docker-compose down

# 重启服务
docker-compose restart
```

## 主要内容

### 1. 数据源表介绍
- 示例中使用了一个名为 `server_logs` 的源表
- 该表由 `faker` 连接器支持，可以基于 Java Faker 表达式持续生成模拟数据

### 2. 核心概念说明
- Flink SQL 操作的是存储在外部系统中的表
- 查询结果可以写入到另一个表中，供下游应用程序使用
- 下游应用可以通过 Flink SQL 或直接连接外部存储系统（如 ElasticSearch）来读取数据

### 3. 具体示例
- 展示了如何从 `server_logs` 表中筛选出客户端错误日志
- 将筛选后的结果写入到名为 `client_errors` 的表中
- 示例中使用了 `blackhole` 类型的目标表（这种类型的表会丢弃写入的所有数据，主要用于演示目的）

### 4. 实现细节
- 通过 SQL 创建了模拟的服务器日志表（server_logs），包含多个字段如 IP、用户代理、时间戳等
- 创建了接收客户端错误的表（client_errors）
- 使用 `INSERT INTO` 语句将状态码为 4xx 的错误日志过滤出来并插入到 client_errors 表中

### 5. 运行说明
- 当 INSERT INTO 查询从无界表（如 server_logs）读取数据时，这是一个长期运行的应用程序
- 可以在 Flink 的 SQL Client 中运行这样的语句
- 执行时会向配置的集群提交一个 Flink 作业

## 操作步骤

### 步骤1：创建源表（server_logs）
```sql
CREATE TABLE server_logs ( 
    client_ip STRING,
    client_identity STRING, 
    userid STRING, 
    user_agent STRING,
    log_time TIMESTAMP(3),
    request_line STRING, 
    status_code STRING, 
    size INT
) WITH (
  'connector' = 'faker', 
  'fields.client_ip.expression' = '#{Internet.publicIpV4Address}',
  'fields.client_identity.expression' =  '-',
  'fields.userid.expression' =  '-',
  'fields.user_agent.expression' = '#{Internet.userAgentAny}',
  'fields.log_time.expression' =  '#{date.past ''15'',''5'',''SECONDS''}',
  'fields.request_line.expression' = '#{regexify ''(GET|POST|PUT|PATCH){1}''} #{regexify ''(/search\.html|/login\.html|/prod\.html|cart\.html|/order\.html){1}''} #{regexify ''(HTTP/1\.1|HTTP/2|/HTTP/1\.0){1}''}',
  'fields.status_code.expression' = '#{regexify ''(200|201|204|400|401|403|301){1}''}',
  'fields.size.expression' = '#{number.numberBetween ''100'',''10000000''}'
);
```

### 步骤2：创建目标表（client_errors）
```sql
CREATE TABLE client_errors (
  log_time TIMESTAMP(3),
  request_line STRING,
  status_code STRING,
  size INT
)
WITH (
  'connector' = 'blackhole'
);
```

### 步骤3：执行数据插入
```sql
INSERT INTO client_errors
SELECT 
  log_time,
  request_line,
  status_code,
  size
FROM server_logs
WHERE 
  status_code SIMILAR TO '4[0-9][0-9]';
```

### 操作说明
1. **环境准备**：
   - 确保已经安装并启动了 Flink 环境
   - 打开 Flink SQL Client（使用命令 `./bin/sql-client.sh`）

2. **执行顺序**：
   - 按顺序执行上述三个 SQL 语句
   - 每个语句执行完后会收到成功提示
   - INSERT INTO 语句会触发一个持续运行的 Flink 作业

3. **验证方法**：
   - 在 Flink Dashboard 中可以看到正在运行的作业
   - 可以通过 Flink 的监控界面查看作业状态和性能指标

4. **注意事项**：
   - 这是一个持续运行的流处理作业
   - 使用了 `faker` 连接器持续生成测试数据
   - `blackhole` 连接器会丢弃所有数据，仅用于演示
   - 在实际应用中，应该将 `blackhole` 替换为实际的存储系统（如 Kafka、ElasticSearch 等）

## 总结
这个文档实际上是一个实用的教程，展示了如何在 Flink SQL 中实现数据的过滤和转发，这是流处理中的一个常见场景。 



# 依赖

## Flink Faker

https://flink-packages.org/packages/flink-faker
https://github.com/knaufk/flink-faker/
直接下载jar
https://github.com/knaufk/flink-faker/releases

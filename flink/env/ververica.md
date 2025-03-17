# Ververica Platform Docker Compose 配置建议

基于现有的 Flink docker-compose.yml 配置，以下是添加 Ververica Platform 的建议配置。您可以将这些服务添加到现有的 docker-compose.yml 中：

```yaml
services:
  # 现有的 jobmanager 和 taskmanager 配置保持不变
  
  # Ververica Platform 相关服务
  ververica-platform:
    image: ververica/ververica-platform:latest
    ports:
      - "8080:8080"  # Ververica Platform UI
    environment:
      - VVP_KUBERNETES_NAMESPACE=default
      - VVP_S3_ENDPOINT=http://minio:9000
      - VVP_S3_ACCESS_KEY=admin
      - VVP_S3_SECRET_KEY=password
    depends_on:
      - minio

  # MinIO 用于对象存储
  minio:
    image: minio/minio
    ports:
      - "9000:9000"
      - "9001:9001"
    environment:
      - MINIO_ACCESS_KEY=admin
      - MINIO_SECRET_KEY=password
    command: server /data --console-address ":9001"
    volumes:
      - minio_data:/data

volumes:
  minio_data:
```

## 重要说明

1. 这个配置是简化版本，仅用于开发和测试环境。生产环境建议使用 Kubernetes 部署。

2. Ververica Platform 需要以下基础设施：
   - 对象存储（这里使用 MinIO）
   - Kubernetes 集群（生产环境）

3. 安全考虑：
   - 示例中的密码和密钥仅用于演示
   - 生产环境请使用安全的密码和密钥
   - 建议配置 SSL/TLS

4. 资源配置：
   - 根据实际需求调整内存和CPU限制
   - 生产环境建议使用资源配额

5. 建议使用方式：
   - 开发测试：可以使用此 docker-compose 配置
   - 生产环境：建议参考 `setup.sh` 脚本使用 Helm 在 Kubernetes 上部署

## 使用说明

1. 启动服务：
```bash
docker-compose up -d
```

2. 访问服务：
- Ververica Platform UI: http://localhost:8080
- MinIO Console: http://localhost:9001

3. 默认凭据：
- MinIO:
  - Access Key: admin
  - Secret Key: password

## 注意事项

1. 这个配置需要与现有的 Flink 配置协同工作
2. 确保端口不会与其他服务冲突
3. 建议在使用前先备份现有的 docker-compose.yml
4. 生产环境强烈建议使用 Kubernetes 部署 
# OpenClaw Deploy - 部署脚本

🥬 **酸菜的部署工作目录**

---

## 📁 目录结构

```
deploy/
├── README.md              # 本文件
├── docker/                # Docker 配置
│   ├── backend/          # 后端 Dockerfile
│   ├── frontend/         # 前端 Dockerfile
│   └── docker-compose.yml
├── kubernetes/           # K8s 配置（可选）
│   ├── deployment.yaml
│   └── service.yaml
├── scripts/              # 部署脚本
│   ├── deploy.sh        # Linux 部署脚本
│   └── deploy.ps1       # Windows 部署脚本
└── environments/         # 环境配置
    ├── dev/             # 开发环境
    ├── staging/         # 预发布环境
    └── prod/            # 生产环境
```

---

## 🚀 快速部署

### Docker Compose 部署

```bash
# 1. 进入目录
cd F:\openclaw\code\deploy

# 2. 启动所有服务
docker-compose up -d

# 3. 查看日志
docker-compose logs -f

# 4. 停止服务
docker-compose down
```

### 一键部署脚本（Windows）

```powershell
# deploy.ps1
.\scripts\deploy.ps1 -Environment production
```

### 一键部署脚本（Linux）

```bash
./scripts/deploy.sh production
```

---

## 🔧 常用命令

### Docker 相关
```bash
# 构建所有镜像
docker-compose build

# 重启服务
docker-compose restart

# 查看服务状态
docker-compose ps

# 清理资源
docker-compose down -v
```

### 监控相关
```bash
# 查看后端日志
docker-compose logs backend

# 查看前端日志
docker-compose logs frontend

# 查看数据库日志
docker-compose logs mysql
```

---

## 📊 监控配置

### Prometheus
- URL: http://localhost:9090
- 指标采集：每 15 秒
- 数据保留：30 天

### Grafana
- URL: http://localhost:3001
- 默认账号：admin / admin
- 仪表板：系统资源、应用性能、业务指标

---

## 🛡️ 安全建议

- ✅ 生产环境使用 HTTPS
- ✅ 数据库密码使用强随机值
- ✅ 定期更新依赖和镜像
- ✅ 配置防火墙规则
- ✅ 启用日志审计

---

## 📖 详细文档

- [DevOps最佳实践](../../workspace-guantang/agent-configs/suancai/README.md)
- [监控配置指南](../../workspace-guantang/agent-configs/suancai/README.md#监控与告警配置)

---

*维护者：酸菜Agent*

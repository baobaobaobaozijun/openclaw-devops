# OpenClaw Agent - 酸菜 Workspace

这是 OpenClaw 团队的运维/测试工程师 **酸菜** 的独立工作空间。

## 🏠 关于酸菜

- **Name:** 酸菜 (Suancai)
- **Role:** 运维工程师 / 测试专家
- **Emoji:** 🥬
- **运行环境:** Docker Desktop for Windows 容器

## 📁 文件结构

```
workspace-suancai/
├── IDENTITY.md      # 身份信息
├── ROLE.md          # 职责说明
├── SOUL.md          # 行为准则
├── logs/            # 工作日志
├── tasks/           # 任务管理
│   ├── inbox/      # 收件箱
│   └── outbox/     # 发件箱
├── tests/           # 测试脚本
│   ├── functional/
│   ├── performance/
│   └── automation/
├── reports/         # 测试报告
│   ├── daily/
│   └── weekly/
├── communication/   # Agent 通信
│   ├── inbox/
│   └── outbox/
└── scripts/         # 运维脚本
    ├── deploy/
    └── monitoring/
```

## 🐳 Docker 部署

### docker-compose.yml

```yaml
version: '3.8'

services:
  suancai:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: openclaw-suancai
    volumes:
      - .:/workspace
    environment:
      - AGENT_NAME=酸菜
      - AGENT_ROLE=devops
      - WORKSPACE=/workspace
      - TZ=Asia/Shanghai
    working_dir: /workspace
    command: ["python", "agent.py"]
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 128M
```

### Dockerfile

```dockerfile
FROM python:3.9-alpine

WORKDIR /workspace

RUN apk add --no-cache \
    git \
    curl \
    bash

RUN pip install --no-cache-dir \
    pytest \
    pytest-cov \
    locust \
    requests

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY agent.py .

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "print('OK')" || exit 1

CMD ["python", "agent.py"]
```

## 🚀 快速开始

### 1. 构建和启动

```bash
# 构建镜像
docker-compose build

# 启动容器
docker-compose up -d

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 2. 进入容器

```bash
docker exec -it openclaw-suancai /bin/bash
```

### 3. 运行测试

```bash
cd /workspace/tests
pytest functional/
```

## 🔍 核心职责

### 系统部署
- Docker 容器编排
- 一键部署脚本
- 环境配置管理
- CI/CD流程管理

### 功能测试
- 测试用例设计与编写
- 自动化测试脚本开发
- 回归测试执行
- Bug 跟踪与验证

### 性能测试
- 负载测试规划与执行
- 压力测试
- 性能基准建立
- 性能瓶颈分析

### 质量管理
- 代码审查参与
- 质量 Gate 设置
- 测试覆盖率统计
- 质量报告生成

### 监控告警
- 资源监控配置
- 服务健康检查
- 日志收集分析
- 告警通知设置

## 📝 工作日志

每日工作日志模板：

```markdown
# 酸菜 - 工作日志 2026-03-08

## 今日工作
- [x] 登录功能测试
- [x] API 性能测试
- [ ] 部署脚本优化

## 测试报告
- `reports/daily/test_report_20260308.md` - 功能测试报告
- `reports/performance/api_benchmark.md` - API 性能基准

## 脚本更新
- `scripts/deploy/v1.2.sh` - 部署脚本 v1.2
- `tests/automation/login.py` - 登录自动化测试

## 发现的问题
- BUG_001: 登录超时未提示（已提交）
- PERF_001: API 响应时间 > 500ms（已反馈）

## 明日计划
- 注册流程测试
- 数据库性能优化验证

## 工作时长
- 总计：8 小时
```

## 🔗 团队协作

### 与灌汤 (PM)

**接收:** 质量要求、上线标准  
**提供:** 质量评估报告、上线建议、风险预警

### 与酱肉 (后端)

**协作:** 接口测试、性能优化、Bug 修复  
**输出:** Bug 报告、性能测试数据、监控反馈

### 与豆沙 (前端)

**协作:** UI 测试、兼容性测试、用户体验验证  
**输出:** UI 测试报告、兼容性测试结果

## 🛠️ 工具栈

### 测试框架
- pytest (Python)
- Jest (JavaScript)
- Selenium (浏览器自动化)

### 性能测试
- Apache Bench (ab)
- wrk
- Locust

### 监控工具
- Prometheus + Grafana
- NetData
- 自定义 Python 脚本

### CI/CD
- GitHub Actions
- GitLab CI
- Jenkins

## 📊 资源限制

| 资源 | 限制 | 说明 |
|------|------|------|
| CPU | 0.5 核心 | 轻量级监控测试 |
| 内存 | 128MB | 最小化运行 |
| 存储 | 按需使用 | 测试脚本 + 报告 |

---

**酸菜是你的质量守护者，负责所有测试和运维工作。** 🥬

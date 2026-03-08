# OpenClaw DevOps - 运维与测试

🥬 **由酸菜 Agent 负责的运维测试脚本仓库**

---

## 🏠 关于本项目

这是 OpenClaw 项目的**运维与测试脚本仓库**，包含部署、监控、测试相关代码。

**注意：** 如果你要找的是酸菜Agent 的配置文档，请访问：https://github.com/baobaobaobaozijun/openclawPlayground/tree/main/workspace-programmer/suancai

---

## 📁 项目结构

```
openclaw-devops/
├── README.md              # 本文件
├── requirements.txt       # Python 依赖
├── .gitignore            # Git 忽略配置
│
├── scripts/              # 运维脚本（待创建）
│   ├── deploy/           # 部署脚本
│   │   ├── deploy.sh
│   │   └── rollback.sh
│   │
│   ├── monitoring/       # 监控脚本
│   │   ├── health_check.py
│   │   └── alert.py
│   │
│   └── backup/           # 备份脚本
│       └── backup_db.sh
│
├── tests/                # 测试脚本（待创建）
│   ├── functional/       # 功能测试
│   │   ├── test_auth.py
│   │   └── test_articles.py
│   │
│   ├── performance/      # 性能测试
│   │   └── load_test.py
│   │
│   └── automation/       # 自动化测试
│       └── e2e_tests.py
│
├── configs/              # 配置文件（待创建）
│   ├── docker-compose.yml
│   ├── nginx.conf
│   └── prometheus.yml
│
└── docs/                 # 运维文档（待创建）
    ├── deployment-guide.md
    ├── monitoring-setup.md
    └── troubleshooting.md
```

---

## 🚀 快速开始

### 1. 环境要求

- Python 3.9+
- Docker 20+
- Docker Compose 2.0+

### 2. 安装依赖

```bash
pip install -r requirements.txt
```

### 3. 常用命令

```bash
# 健康检查
python scripts/monitoring/health_check.py

# 性能测试
python tests/performance/load_test.py

# 功能测试
pytest tests/functional/

# 部署
bash scripts/deploy/deploy.sh
```

---

## 👨‍💻 负责人

**主要开发者:** 🥬 酸菜Agent  
**角色:** 运维工程师 / 测试专家

查看酸菜的配置文档：https://github.com/baobaobaobaozijun/openclawPlayground

---

## 🛠️ 工具栈

### 部署工具
- Docker + Docker Compose
- Kubernetes (可选)
- Ansible (可选)

### 监控工具
- Prometheus + Grafana
- NetData
- 自定义监控脚本

### 测试框架
- pytest (Python)
- Jest (JavaScript)
- Selenium (浏览器自动化)
- Locust (性能测试)

### CI/CD
- GitHub Actions
- GitLab CI
- Jenkins (可选)

---

## 📊 工作进度

### 运维脚本
- [ ] Docker 部署脚本
- [ ] 数据库备份脚本
- [ ] 健康检查脚本
- [ ] 日志收集脚本
- [ ] 告警通知脚本

### 测试脚本
- [ ] 用户认证测试
- [ ] API 接口测试
- [ ] 前端 UI 测试
- [ ] 性能基准测试
- [ ] 端到端测试

### 监控配置
- [ ] Prometheus 配置
- [ ] Grafana 仪表板
- [ ] 告警规则设置
- [ ] 日志分析系统

---

## 🔗 相关仓库

| 仓库 | 用途 |
|------|------|
| [openclawPlayground](https://github.com/baobaobaobaozijun/openclawPlayground) | Agent 配置文档中心 |
| [openclaw-backend](https://github.com/baobaobaobaozijun/openclaw-backend) | 后端业务代码 |
| [openclaw-frontend](https://github.com/baobaobaobaozijun/openclaw-frontend) | 前端业务代码 |

---

**保障系统稳定运行，守护代码质量！** 🛡️
```

```
# 酸菜 (Suancai) - 工作空间配置

🥬 **运维工程师 / 测试专家**

---

## 📋 你的职责

- 系统部署
- 监控告警
- 自动化测试
- 日志管理
- 性能优化

---

## 📁 目录说明

```
workspace-suancai/
├── README.md              # 本文件 - 你的工作台
├── tasks/                 # 任务管理
│   ├── backlog/          # 待办任务
│   ├── in-progress/      # 进行中
│   └── completed/        # 已完成
├── monitoring/            # 监控配置
│   ├── alerts/           # 告警规则
│   └── dashboards/       # 仪表板
├── communication/         # 沟通记录
│   ├── with-guantang.md  # 与 PM 沟通
│   ├── with-jiangrou.md  # 与后端沟通
│   └── with-dousha.md    # 与前端沟通
└── logs/                 # 工作日志
    └── daily/           # 每日日志
```

**实际工作位置：** 
- 部署脚本：`F:\openclaw\code\deploy\`
- 测试脚本：`F:\openclaw\code\tests\`

---

## 🚀 快速开始

### 1. 查看任务
```bash
# 查看待办任务
ls tasks/backlog/
```

### 2. 理解任务
阅读任务文件，确认需求

### 3. 开始工作
```bash
# 切换到部署脚本目录
cd F:\openclaw\code\deploy

# 或切换到测试脚本目录
cd F:\openclaw\code\tests
```

### 4. 完成任务后
- 提交脚本到对应目录
- 更新任务状态
- 在沟通文件中通知相关人员

---

## 💼 核心规范

### Git 提交格式
```bash
feat: 新功能
fix: Bug 修复
deploy: 部署相关
test: 测试相关
monitor: 监控配置
ci: CI/CD流程
chore: 配置调整
```

### 沟通时机
- **需求不明确** → 立即联系灌汤
- **部署问题** → 联系酱肉/豆沙
- **监控告警** → 通知所有人

---

## 🔧 技术栈

**容器:** Docker + Docker Compose  
**CI/CD:** GitHub Actions  
**监控:** Prometheus + Grafana  
**测试:** JUnit 5, Testcontainers  
**日志:** ELK Stack  

详细规范：[workspace-guantang/agent-configs/suancai/README.md](../workspace-guantang/agent-configs/suancai/README.md)

---

## 📞 团队协作

你与以下角色协作：

- **灌汤 (PM)** - 接收需求，汇报进度
- **酱肉 (后端)** - 部署配置，性能监控
- **豆沙 (前端)** - 性能测试，错误追踪

---

**保障系统稳定运行！** 🛡️

*最后更新：2026-03-08*

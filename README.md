# 油田信访管理系统

## 项目简介

面向油田企业的数字化信访维稳管理平台，核心能力为多渠道受理、全流程闭环、多层级协同、智能化研判。

## 技术栈

| 层级 | 技术 |
|------|------|
| 后端框架 | Spring Boot 3.3.0 |
| 前端框架 | Vue 3 + Vite 5 |
| 数据库 | MySQL 8.0 |
| ORM | Spring Data JPA / Hibernate |
| 图表 | Chart.js + vue-chartjs |

## 快速启动

### 环境要求

- JDK 21+
- Maven 3.9+
- Node.js 18+
- MySQL 8.0+

### 1. 初始化数据库

```bash
mysql -u root -p < 油田信访系统_数据库设计.sql
```

### 2. 配置数据库连接

编辑 `backend/src/main/resources/application.yml`，修改数据库用户名密码：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/oilfield_petition
    username: root
    password: 你的密码
```

### 3. 启动后端

```bash
cd backend
mvn spring-boot:run
```

后端运行在 `http://localhost:8080`

### 4. 启动前端

```bash
cd frontend
npm install
npm run dev
```

前端运行在 `http://localhost:3000`

## 默认账号

### 管理员账号

| 项目 | 值 |
|------|-----|
| 用户名 | `admin` |
| 密码 | `admin123` |
| 姓名 | 系统管理员 |
| 角色 | 管理员（user_type=1） |
| 工号 | ADMIN001 |

### 普通用户账号

| 项目 | 值 |
|------|-----|
| 用户名 | `user001` |
| 密码 | `123456` |
| 姓名 | 张测试 |
| 角色 | 普通用户（user_type=0） |
| 工号 | EMP001 |

## 项目结构

```
oilfield-petition-system/
├── backend/                          # Spring Boot 后端
│   └── src/main/java/com/oilfield/petition/
│       ├── Application.java          # 启动类
│       ├── controller/               # 控制器
│       │   ├── HomeController.java   # 首页 API
│       │   └── VisitController.java  # 页面访问统计 API
│       ├── entity/                   # 43 个 JPA 实体类
│       └── repository/               # 数据访问层
├── frontend/                         # Vue 3 前端
│   └── src/
│       ├── App.vue                   # 主组件（路由控制）
│       ├── main.js                   # 入口
│       ├── assets/main.css           # 全局样式
│       └── components/
│           ├── Login.vue             # 用户登录页
│           ├── Register.vue          # 用户注册页
│           ├── AdminLogin.vue        # 管理员登录页
│           └── AdminDashboard.vue    # 管理员后台大屏
├── 油田信访系统_数据库设计.sql        # 完整数据库建表脚本
└── README.md
```

## 常用 API

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/home` | 系统信息 |
| POST | `/api/visit?page=页面名` | 记录页面访问 |
| GET | `/api/visit/stats?range=week` | 获取访问统计 |

## 数据库

- 数据库名: `oilfield_petition`
- 字符集: utf8mb4
- 总表数: 43 张（含新增 `stats_page_visit`）
- 用户类型字段: `sys_user.user_type` (0=普通用户, 1=管理员)

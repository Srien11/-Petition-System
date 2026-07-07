<template>
  <div class="admin-dashboard">
    <!-- 侧边栏 -->
    <aside class="sidebar">
      <div class="sidebar-brand">
        <div class="sidebar-icon">
          <svg viewBox="0 0 60 60" width="32" height="32">
            <ellipse cx="24" cy="20" rx="6" ry="10" fill="#d4410f" transform="rotate(-15 24 20)"/>
            <line x1="36" y1="44" x2="36" y2="18" stroke="#d4410f" stroke-width="2.5" stroke-linecap="round"/>
            <line x1="30" y1="44" x2="42" y2="44" stroke="#d4410f" stroke-width="2.5" stroke-linecap="round"/>
            <line x1="28" y1="22" x2="44" y2="22" stroke="#d4410f" stroke-width="2.5" stroke-linecap="round"/>
          </svg>
        </div>
        <span class="sidebar-title">油田信访管理</span>
      </div>

      <nav class="sidebar-nav">
        <a v-for="item in navItems" :key="item.key" href="#"
          :class="{ active: currentNav === item.key }"
          @click.prevent="currentNav = item.key">
          <span class="nav-icon">{{ item.icon }}</span>
          <span>{{ item.label }}</span>
        </a>
      </nav>

      <div class="sidebar-footer">
        <span class="admin-name">{{ adminName }}</span>
        <a href="#" class="logout-btn" @click.prevent="$emit('logout')">退出登录</a>
      </div>
    </aside>

    <!-- 主内容 -->
    <main class="dashboard-main">
      <!-- 顶部信息栏 -->
      <header class="topbar">
        <div class="topbar-left">
          <h2>{{ currentTitle }}</h2>
        </div>
        <div class="topbar-right">
          <span class="topbar-time">{{ currentTime }}</span>
          <span class="topbar-badge">管理员</span>
        </div>
      </header>

      <!-- 统计卡片组 -->
      <section class="stat-cards">
        <div v-for="card in statCards" :key="card.label" class="stat-card" :class="card.color">
          <div class="stat-card-icon">{{ card.icon }}</div>
          <div class="stat-card-info">
            <p class="stat-card-label">{{ card.label }}</p>
            <p class="stat-card-value">{{ card.value }}</p>
          </div>
        </div>
      </section>

      <!-- 折线图区域 -->
      <section class="chart-section">
        <div class="chart-header">
          <h3>页面访问量趋势</h3>
          <div class="chart-controls">
            <button v-for="r in ranges" :key="r.key" :class="{ active: activeRange === r.key }"
              @click="activeRange = r.key; updateChart()">{{ r.label }}</button>
          </div>
        </div>
        <div class="chart-container">
          <canvas ref="visitChart"></canvas>
        </div>
      </section>

      <!-- 下方双栏：最近访问 + 系统信息 -->
      <section class="bottom-grid">
        <div class="bottom-card">
          <h3>最近访问记录</h3>
          <table class="visit-table">
            <thead><tr><th>页面</th><th>用户</th><th>时间</th></tr></thead>
            <tbody>
              <tr v-for="v in recentVisits" :key="v.id">
                <td>{{ v.page }}</td><td>{{ v.user }}</td><td>{{ v.time }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="bottom-card">
          <h3>系统信息</h3>
          <div class="sys-info-list">
            <div v-for="info in sysInfo" :key="info.key" class="sys-info-row">
              <span class="sys-info-key">{{ info.key }}</span>
              <span class="sys-info-val">{{ info.value }}</span>
            </div>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<script>
import { Chart, LineController, LineElement, PointElement, LinearScale, CategoryScale, Filler, Tooltip, Legend } from 'chart.js'

Chart.register(LineController, LineElement, PointElement, LinearScale, CategoryScale, Filler, Tooltip, Legend)

export default {
  name: 'AdminDashboard',
  data() {
    return {
      adminName: '管理员',
      currentNav: 'dashboard',
      currentTime: '',
      activeRange: 'week',
      ranges: [
        { key: 'week', label: '近7天' },
        { key: 'month', label: '近30天' },
        { key: 'year', label: '近12月' }
      ],
      navItems: [
        { key: 'dashboard', icon: '📊', label: '数据概览' },
        { key: 'users', icon: '👥', label: '用户管理' },
        { key: 'petitions', icon: '📋', label: '信访管理' },
        { key: 'statistics', icon: '📈', label: '统计分析' },
        { key: 'settings', icon: '⚙️', label: '系统设置' }
      ],
      statCards: [
        { icon: '👁️', label: '今日访问量', value: 0, color: 'blue' },
        { icon: '👥', label: '活跃用户', value: 0, color: 'green' },
        { icon: '📋', label: '待办信访件', value: 0, color: 'orange' },
        { icon: '✅', label: '已办结', value: 0, color: 'red' }
      ],
      recentVisits: [],
      sysInfo: [
        { key: '系统版本', value: 'v2.1.0' },
        { key: '数据库', value: 'MySQL 8.0' },
        { key: '后端框架', value: 'Spring Boot 3.3.0' },
        { key: '前端框架', value: 'Vue 3 + Vite' }
      ],
      chartInstance: null
    }
  },
  computed: {
    currentTitle() {
      return this.navItems.find(i => i.key === this.currentNav)?.label || '数据概览'
    }
  },
  mounted() {
    this.updateTime()
    this.timer = setInterval(() => this.updateTime(), 1000)
    this.loadDashboardData()
    this.$nextTick(() => this.initChart())
  },
  beforeUnmount() {
    clearInterval(this.timer)
    if (this.chartInstance) this.chartInstance.destroy()
  },
  methods: {
    updateTime() {
      const d = new Date()
      this.currentTime = `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')} ${String(d.getHours()).padStart(2,'0')}:${String(d.getMinutes()).padStart(2,'0')}:${String(d.getSeconds()).padStart(2,'0')}`
    },
    loadDashboardData() {
      this.statCards[0].value = Math.floor(Math.random() * 500) + 200
      this.statCards[1].value = Math.floor(Math.random() * 100) + 50
      this.statCards[2].value = Math.floor(Math.random() * 30) + 5
      this.statCards[3].value = Math.floor(Math.random() * 400) + 100

      const pages = ['首页', '登录页', '信访登记', '进度查询', '信访详情', '管理员后台']
      const users = ['张**', '李**', '王**', '赵**', '刘**']
      this.recentVisits = Array.from({length: 8}, (_, i) => ({
        id: i,
        page: pages[Math.floor(Math.random() * pages.length)],
        user: users[Math.floor(Math.random() * users.length)],
        time: new Date(Date.now() - Math.random() * 86400000).toLocaleTimeString('zh-CN')
      })).sort((a, b) => b.time.localeCompare(a.time))
    },
    initChart() {
      this.chartInstance = new Chart(this.$refs.visitChart, {
        type: 'line',
        data: this.getChartData(),
        options: {
          responsive: true,
          maintainAspectRatio: false,
          interaction: { intersect: false, mode: 'index' },
          plugins: {
            legend: { display: true, position: 'top', labels: { usePointStyle: true, padding: 20, font: { size: 12 } } },
            tooltip: { backgroundColor: 'rgba(44,62,80,0.92)', padding: 12, cornerRadius: 6 }
          },
          scales: {
            x: { grid: { display: false }, ticks: { color: '#9098a9', font: { size: 11 } } },
            y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.06)' }, ticks: { color: '#9098a9', font: { size: 11 } } }
          }
        }
      })
    },
    updateChart() {
      if (this.chartInstance) {
        this.chartInstance.data = this.getChartData()
        this.chartInstance.update()
      }
    },
    getChartData() {
      const config = {
        week:  { labels: ['6天前','5天前','4天前','3天前','前天','昨天','今天'], count: 7 },
        month: { labels: Array.from({length:30}, (_,i) => `${i+1}日`), count: 30 },
        year:  { labels: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'], count: 12 }
      }
      const c = config[this.activeRange]
      const base1 = Array.from({length: c.count}, () => Math.floor(Math.random() * 200) + 100)
      const base2 = Array.from({length: c.count}, () => Math.floor(Math.random() * 150) + 50)

      return {
        labels: c.labels,
        datasets: [
          {
            label: '页面访问量',
            data: base1,
            borderColor: '#d4410f',
            backgroundColor: 'rgba(212,65,15,0.08)',
            fill: true,
            tension: 0.4,
            pointBackgroundColor: '#d4410f',
            pointBorderColor: '#fff',
            pointBorderWidth: 2,
            pointRadius: 4,
            pointHoverRadius: 6,
            borderWidth: 2.5
          },
          {
            label: '独立访客',
            data: base2,
            borderColor: '#4a9eff',
            backgroundColor: 'rgba(74,158,255,0.05)',
            fill: true,
            tension: 0.4,
            pointBackgroundColor: '#4a9eff',
            pointBorderColor: '#fff',
            pointBorderWidth: 2,
            pointRadius: 4,
            pointHoverRadius: 6,
            borderWidth: 2.5
          }
        ]
      }
    }
  }
}
</script>

<style scoped>
/* =============================================
   Design — Admin Dashboard
   ============================================= */
.admin-dashboard {
  display: flex;
  min-height: 100vh;
  font-family: var(--font-body);
  background: var(--canvas);
  animation: fadeIn 0.3s ease;
}

/* ==================== Sidebar ==================== */
.sidebar {
  width: 240px;
  flex-shrink: 0;
  background: var(--surface-dark);
  display: flex;
  flex-direction: column;
  border-right: 1px solid rgba(255,255,255,0.04);
  transition: width var(--transition-base);
}

.sidebar-brand {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 20px 20px;
  border-bottom: 1px solid rgba(255,255,255,0.05);
}

.sidebar-title {
  font-size: 15px;
  font-weight: 600;
  color: var(--on-dark);
  letter-spacing: 0.5px;
  white-space: nowrap;
}

.sidebar-nav {
  flex: 1;
  padding: 12px 8px;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.sidebar-nav a {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 14px;
  color: #8892a0;
  text-decoration: none;
  font-size: 14px;
  border-radius: var(--radius-md);
  transition:
    background var(--transition-fast),
    color var(--transition-fast);
  cursor: pointer;
  border-left: 3px solid transparent;
}

.sidebar-nav a:hover {
  background: rgba(255,255,255,0.04);
  color: var(--on-dark);
}

.sidebar-nav a.active {
  background: rgba(204,120,92,0.12);
  color: var(--primary);
  font-weight: 500;
  border-left-color: var(--primary);
}

.nav-icon {
  font-size: 16px;
  flex-shrink: 0;
}

.sidebar-footer {
  padding: 16px 20px;
  border-top: 1px solid rgba(255,255,255,0.05);
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
}

.admin-name {
  color: var(--on-dark-soft);
  white-space: nowrap;
}

.logout-btn {
  color: var(--error);
  text-decoration: none;
  font-size: 12px;
  cursor: pointer;
  transition: opacity var(--transition-fast);
}

.logout-btn:hover {
  text-decoration: underline;
  opacity: 0.85;
}

/* ==================== Main ==================== */
.dashboard-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
}

/* ==================== Top Bar ==================== */
.topbar {
  background: #ffffff;
  padding: 16px 28px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid var(--hairline);
}

.topbar-left h2 {
  font-family: var(--font-display);
  font-size: 18px;
  font-weight: 600;
  color: var(--ink);
  letter-spacing: -0.3px;
}

.topbar-right {
  display: flex;
  align-items: center;
  gap: 14px;
  font-size: 13px;
  color: var(--muted);
}

.topbar-badge {
  background: var(--primary-soft);
  color: var(--primary);
  padding: 4px 12px;
  border-radius: var(--radius-sm);
  font-weight: 500;
  font-size: 12px;
}

/* ==================== Stat Cards ==================== */
.stat-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  padding: 24px 28px;
}

.stat-card {
  background: #ffffff;
  border-radius: var(--radius-lg);
  padding: 22px 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  border: 1px solid var(--hairline);
  transition:
    transform var(--transition-base),
    box-shadow var(--transition-base);
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-md);
}

.stat-card:active {
  transform: translateY(0) scale(0.99);
}

.stat-card-icon {
  font-size: 26px;
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--radius-md);
  flex-shrink: 0;
  transition: transform var(--transition-fast);
}

.stat-card:hover .stat-card-icon {
  transform: scale(1.1);
}

.stat-card.blue .stat-card-icon { background: rgba(204,120,92,0.1); }
.stat-card.green .stat-card-icon { background: var(--teal-bg); }
.stat-card.orange .stat-card-icon { background: var(--warning-bg); }
.stat-card.red .stat-card-icon { background: var(--error-bg); }

.stat-card-label {
  font-size: 13px;
  color: var(--muted);
  margin-bottom: 4px;
}

.stat-card-value {
  font-size: 26px;
  font-weight: 700;
  color: var(--ink);
  line-height: 1.1;
}

/* ==================== Chart ==================== */
.chart-section {
  background: #ffffff;
  margin: 0 28px 24px;
  border-radius: var(--radius-lg);
  padding: 24px;
  border: 1px solid var(--hairline);
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.chart-header h3 {
  font-size: 15px;
  font-weight: 600;
  color: var(--ink);
}

.chart-controls button {
  padding: 6px 14px;
  border: 1px solid var(--hairline);
  background: #fff;
  color: var(--muted);
  border-radius: var(--radius-sm);
  font-size: 12px;
  cursor: pointer;
  margin-left: 8px;
  transition: all var(--transition-fast);
  font-family: var(--font-body);
}

.chart-controls button.active {
  background: var(--primary);
  color: var(--on-primary);
  border-color: var(--primary);
}

.chart-controls button:hover:not(.active) {
  border-color: var(--primary);
  color: var(--primary);
}

.chart-container {
  height: 340px;
  position: relative;
}

/* ==================== Bottom Grid ==================== */
.bottom-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  padding: 0 28px 24px;
}

.bottom-card {
  background: #ffffff;
  border-radius: var(--radius-lg);
  padding: 20px 24px;
  border: 1px solid var(--hairline);
}

.bottom-card h3 {
  font-size: 15px;
  font-weight: 600;
  color: var(--ink);
  margin-bottom: 16px;
}

/* ==================== Table ==================== */
.visit-table {
  width: 100%;
  font-size: 13px;
  border-collapse: collapse;
}

.visit-table th {
  text-align: left;
  color: var(--muted);
  font-weight: 500;
  padding-bottom: 10px;
  border-bottom: 1px solid var(--hairline-soft);
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.3px;
}

.visit-table td {
  padding: 10px 0;
  color: var(--body);
  border-bottom: 1px solid #f5f4f2;
  transition: color var(--transition-fast);
}

.visit-table tr {
  transition: background var(--transition-fast);
}

.visit-table tbody tr:hover td {
  color: var(--ink);
}

.visit-table tbody tr:hover {
  background: rgba(0,0,0,0.015);
}

/* ==================== System Info ==================== */
.sys-info-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.sys-info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 6px 0;
  border-bottom: 1px solid #f5f4f2;
  transition: padding var(--transition-fast);
}

.sys-info-row:last-child { border-bottom: none; }

.sys-info-row:hover {
  padding-left: 4px;
}

.sys-info-key {
  font-size: 13px;
  color: var(--muted);
}

.sys-info-val {
  font-size: 13px;
  color: var(--ink);
  font-weight: 500;
}

/* ==================== Animations ==================== */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

/* ==================== Responsive ==================== */
@media (max-width: 1200px) {
  .stat-cards { grid-template-columns: repeat(2, 1fr); }
  .bottom-grid { grid-template-columns: 1fr; }
}

@media (max-width: 768px) {
  .sidebar { width: 60px; }
  .sidebar-title,
  .sidebar-nav a span:not(.nav-icon),
  .admin-name { display: none; }
  .sidebar-brand { justify-content: center; padding: 16px; }
  .sidebar-nav a { justify-content: center; padding: 10px; }
  .sidebar-footer { justify-content: center; }
  .stat-cards { grid-template-columns: 1fr; }
  .content-area { padding: 16px; }
}
</style>

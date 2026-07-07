<template>
  <!-- 管理员登录页 -->
  <AdminLogin v-if="currentView === 'admin-login'" @login-success="onAdminLoginSuccess" @go-user-login="onGoUserLogin" />
  <!-- 管理员后台 -->
  <AdminDashboard v-else-if="isAdmin" @logout="onAdminLogout" />
  <!-- 用户登录页 -->
  <Login v-else-if="!authenticated && currentView === 'login'" @login-success="onLoginSuccess" @go-register="onGoRegister" @go-admin="onGoAdmin" />
  <!-- 注册页 -->
  <Register v-else-if="!authenticated && currentView === 'register'" @go-login="onGoLogin" />

  <!-- 信访登记页 -->
  <PetitionRegister v-else-if="authenticated && currentView === 'petition-register'" @go-home="onGoHome" />

  <!-- 主页面 -->
  <div v-else id="app" class="app-container">
    <header class="header">
      <div class="header-content">
        <div class="logo">
          <svg viewBox="0 0 60 60" width="42" height="42">
            <ellipse cx="24" cy="20" rx="6" ry="10" fill="#d4410f" transform="rotate(-15 24 20)"/>
            <ellipse cx="22" cy="16" rx="3" ry="5" fill="#e65a2b" opacity="0.6" transform="rotate(-15 22 16)"/>
            <line x1="36" y1="44" x2="36" y2="18" stroke="#d4410f" stroke-width="2.5" stroke-linecap="round"/>
            <line x1="30" y1="44" x2="42" y2="44" stroke="#d4410f" stroke-width="2.5" stroke-linecap="round"/>
            <line x1="28" y1="22" x2="44" y2="22" stroke="#d4410f" stroke-width="2.5" stroke-linecap="round"/>
            <circle cx="28" cy="22" r="4" fill="none" stroke="#d4410f" stroke-width="2"/>
            <circle cx="36" cy="26" r="5" fill="none" stroke="#d4410f" stroke-width="1.8"/>
            <line x1="33" y1="30" x2="41" y2="24" stroke="#d4410f" stroke-width="1.5"/>
          </svg>
        </div>
        <div class="header-text">
          <h1 class="system-title">油田信访管理系统</h1>
          <p class="system-subtitle">倾听基层声音 服务油田职工</p>
        </div>
      </div>
    </header>

    <main class="main">
      <div class="hero">
        <div class="hero-badge">
          <span>v{{ systemInfo.version }}</span>
        </div>
        <h2 class="hero-title">欢迎使用油田信访系统</h2>
        <p class="hero-desc">高效、规范、透明，为油田职工提供便捷的信访服务渠道</p>

        <div class="feature-grid">
          <div class="feature-card" v-for="(item, index) in features" :key="item.title"
               :class="{ 'feature-card-clickable': index === 0 }"
               @click="onFeatureClick(index)">
            <div class="feature-icon">{{ item.icon }}</div>
            <h3 class="feature-title">{{ item.title }}</h3>
            <p class="feature-desc">{{ item.desc }}</p>
          </div>
        </div>

        <div class="status-bar" v-if="backendConnected">
          <span class="status-dot"></span>
          后端服务已连接
        </div>
        <div class="status-bar offline" v-else>
          <span class="status-dot"></span>
          后端服务未连接
        </div>
      </div>
    </main>

    <footer class="footer">
      <p>&copy; {{ currentYear }} 油田信访办公室 版本 {{ systemInfo.version }}</p>
    </footer>
  </div>
</template>

<script>
import axios from 'axios'
import Login from './components/Login.vue'
import Register from './components/Register.vue'
import AdminLogin from './components/AdminLogin.vue'
import AdminDashboard from './components/AdminDashboard.vue'
import PetitionRegister from './components/PetitionRegister.vue'

export default {
  name: 'App',
  components: { Login, Register, AdminLogin, AdminDashboard, PetitionRegister },
  data() {
    return {
      currentView: 'login',
      authenticated: false,
      isAdmin: false,
      userInfo: null,
      systemInfo: {
        title: '油田信访系统',
        version: '1.0.0',
        description: '欢迎使用油田信访系统'
      },
      backendConnected: false,
      currentYear: new Date().getFullYear(),
      features: [
        { icon: '📝', title: '信访登记', desc: '在线提交信访诉求，便捷高效' },
        { icon: '📊', title: '进度查询', desc: '实时跟踪信访处理进度' },
        { icon: '🔔', title: '结果反馈', desc: '及时获取处理结果通知' },
        { icon: '📋', title: '信息公开', desc: '信访政策法规透明公开' }
      ]
    }
  },
  mounted() {
    this.checkBackend()
  },
  methods: {
    onLoginSuccess(data) {
      this.userInfo = data
      this.authenticated = true
      this.checkBackend()
    },
    onGoRegister() {
      this.currentView = 'register'
    },
    onGoLogin() {
      this.currentView = 'login'
    },
    onGoAdmin() {
      this.currentView = 'admin-login'
    },
    onGoHome() {
      this.currentView = 'home'
    },
    onGoUserLogin() {
      this.currentView = 'login'
    },
    onAdminLoginSuccess(data) {
      this.userInfo = data
      this.isAdmin = true
      this.authenticated = true
    },
    onAdminLogout() {
      this.isAdmin = false
      this.authenticated = false
      this.currentView = 'admin-login'
    },
    onFeatureClick(index) {
      if (index === 0) {
        this.currentView = 'petition-register'
      } else {
        alert('该功能正在开发中，敬请期待')
      }
    },
    async checkBackend() {
      try {
        const res = await axios.get('/api/home')
        this.systemInfo = res.data
        this.backendConnected = true
      } catch {
        this.backendConnected = false
      }
    }
  }
}
</script>

<style scoped>
/* =============================================
   Design — App.vue (Home)
   ============================================= */

.feature-card .feature-icon {
  display: inline-block;
  transition: transform var(--transition-base);
}

.feature-card:hover .feature-icon {
  transform: scale(1.1);
}

.logo {
  transition: transform var(--transition-fast);
}

.logo:hover {
  transform: rotate(-5deg) scale(1.05);
}

.app-container {
  animation: pageIn 0.35s ease;
}

@keyframes pageIn {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}

.status-bar {
  transition:
    transform var(--transition-base),
    box-shadow var(--transition-base);
}

.status-bar:hover {
  transform: translateY(-1px);
  box-shadow: var(--shadow-sm);
}
</style>

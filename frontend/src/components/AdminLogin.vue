<template>
  <div class="admin-login-page">
    <div class="login-card">
      <transition name="slide-down">
        <div v-if="errorMsg" class="error-bar">
          <svg viewBox="0 0 20 20" width="16" height="16" fill="#e74c3c"><path d="M10 1a9 9 0 1 0 0 18 9 9 0 0 0 0-18zm0 13.5a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5zm.75-9.75v6a.75.75 0 0 1-1.5 0v-6a.75.75 0 0 1 1.5 0z"/></svg>
          <span>{{ errorMsg }}</span>
        </div>
      </transition>

      <div class="brand">
        <div class="admin-badge">管理员</div>
        <h1 class="brand-title">油田信访管理系统</h1>
        <p class="brand-subtitle">后台管理入口</p>
        <div class="brand-divider"></div>
      </div>

      <form @submit.prevent="handleLogin" novalidate>
        <div class="form-group">
          <label class="form-label">管理员账号</label>
          <div class="input-wrapper" :class="{ 'input-error': usernameError, 'input-focused': usernameFocused }">
            <svg class="input-icon" viewBox="0 0 20 20" width="20" height="20" fill="#b0b8c5"><path d="M10 10a4 4 0 1 0 0-8 4 4 0 0 0 0 8zm-7 8a7 7 0 0 1 14 0H3z"/></svg>
            <input v-model="username" type="text" class="form-input" placeholder="请输入管理员账号"
              @focus="usernameFocused = true; usernameError = ''" @blur="validateUsername" autocomplete="username"/>
          </div>
          <transition name="fade"><p v-if="usernameError" class="field-hint error">{{ usernameError }}</p></transition>
        </div>

        <div class="form-group">
          <label class="form-label">登录密码</label>
          <div class="input-wrapper" :class="{ 'input-error': passwordError, 'input-focused': passwordFocused }">
            <svg class="input-icon" viewBox="0 0 20 20" width="20" height="20" fill="#b0b8c5">
              <rect x="3" y="8" width="14" height="10" rx="2" stroke="#b0b8c5" fill="none" stroke-width="1.5"/>
              <path d="M6 8V5a4 4 0 0 1 8 0v3" stroke="#b0b8c5" fill="none" stroke-width="1.5"/>
            </svg>
            <input v-model="password" :type="showPwd ? 'text' : 'password'" class="form-input" placeholder="请输入密码"
              @focus="passwordFocused = true; passwordError = ''" @blur="validatePassword" autocomplete="current-password"/>
            <button type="button" class="toggle-pwd" @click="showPwd = !showPwd">
              <svg v-if="!showPwd" viewBox="0 0 20 20" width="20" height="20" fill="#9098a9"><path d="M10 4C4 4 1 10 1 10s3 6 9 6 9-6 9-6-3-6-9-6zm0 10a4 4 0 1 1 0-8 4 4 0 0 1 0 8z"/><circle cx="10" cy="10" r="2"/></svg>
              <svg v-else viewBox="0 0 20 20" width="20" height="20" fill="#9098a9"><path d="M10 4C4 4 1 10 1 10s3 6 9 6 9-6 9-6-3-6-9-6zm0 10a4 4 0 1 1 0-8 4 4 0 0 1 0 8z"/><line x1="2" y1="2" x2="18" y2="18" stroke="#9098a9" stroke-width="2" stroke-linecap="round"/></svg>
            </button>
          </div>
          <transition name="fade"><p v-if="passwordError" class="field-hint error">{{ passwordError }}</p></transition>
        </div>

        <button type="submit" class="login-btn" :class="{ 'btn-loading': loading }" :disabled="loading">
          <span v-if="!loading" class="btn-text">管理员登录</span>
          <span v-else class="btn-loading-text"><span class="spinner"></span>验证中…</span>
        </button>
      </form>

      <p class="switch-link">
        <a href="#" @click.prevent="$emit('go-user-login')">返回用户登录</a>
      </p>
    </div>

    <p class="footer-text">&copy; 2025 油田信访办公室 后台管理系统</p>

    <transition name="toast-slide">
      <div v-if="successToast" class="success-toast">{{ successToast }}</div>
    </transition>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'AdminLogin',
  data() {
    return {
      username: '', password: '', showPwd: false, loading: false,
      usernameFocused: false, passwordFocused: false,
      usernameError: '', passwordError: '', errorMsg: '', successToast: '',
      lastSubmitTime: 0
    }
  },
  methods: {
    validateUsername() {
      this.usernameFocused = false
      this.usernameError = this.username.trim() ? '' : '请输入管理员账号'
    },
    validatePassword() {
      this.passwordFocused = false
      this.passwordError = this.password ? '' : '请输入密码'
    },
    showError(msg) {
      this.errorMsg = msg
      setTimeout(() => { this.errorMsg = '' }, 3000)
    },
    async handleLogin() {
      this.validateUsername()
      this.validatePassword()
      if (this.usernameError || this.passwordError) return

      const now = Date.now()
      if (now - this.lastSubmitTime < 2000) return
      this.lastSubmitTime = now
      this.loading = true
      this.errorMsg = ''

      setTimeout(() => {
        this.loading = false
        if (this.username.trim() === 'admin' && this.password === 'admin123') {
          this.successToast = '管理员登录成功，正在跳转…'
          setTimeout(() => {
            this.successToast = ''
            this.$emit('login-success', { username: 'admin', userType: 1 })
          }, 1500)
        } else {
          this.showError('管理员账号或密码错误')
        }
      }, 800)
    }
  }
}
</script>

<style scoped>
/* =============================================
   Design — Admin Login (Dark)
   ============================================= */
.admin-login-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: var(--surface-dark);
  font-family: var(--font-body);
  padding: 24px;
  animation: fadeIn 0.4s ease;
}

.login-card {
  background: var(--surface-dark-elevated);
  width: 420px;
  max-width: 100%;
  border-radius: var(--radius-xl);
  padding: 40px 36px;
  box-shadow: var(--shadow-xl);
  border: 1px solid rgba(255,255,255,0.06);
  animation: slideUp 0.4s ease;
}

/* ==================== Error Bar ==================== */
.error-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  background: rgba(198,69,69,0.1);
  border: 1px solid rgba(198,69,69,0.25);
  color: #e86868;
  border-radius: var(--radius-sm);
  padding: 12px 14px;
  margin-bottom: 16px;
  font-size: 13px;
  animation: shake 0.4s ease, slideDown 0.3s ease;
}

/* ==================== Brand ==================== */
.brand { text-align: center; }

.admin-badge {
  display: inline-block;
  background: var(--primary);
  color: var(--on-primary);
  border-radius: var(--radius-sm);
  padding: 4px 14px;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 1.5px;
  margin-bottom: 16px;
}

.brand-title {
  font-family: var(--font-display);
  font-size: 24px;
  font-weight: 600;
  color: var(--on-dark);
  letter-spacing: -0.3px;
}

.brand-subtitle {
  font-size: 13px;
  color: var(--on-dark-soft);
  margin: 8px 0 0;
  letter-spacing: 0.3px;
}

.brand-divider {
  height: 1px;
  background: rgba(255,255,255,0.06);
  margin: 24px 0;
}

/* ==================== Form ==================== */
.form-group { margin-bottom: 20px; }

.form-label {
  font-size: 13px;
  font-weight: 500;
  color: #b8c0d0;
  display: block;
  margin-bottom: 6px;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
  height: 46px;
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: var(--radius-md);
  transition:
    border-color var(--transition-base),
    box-shadow var(--transition-base);
}

.input-wrapper:hover {
  border-color: rgba(255,255,255,0.12);
}

.input-wrapper.input-focused {
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(204,120,92,0.15);
}

.input-wrapper.input-error {
  border-color: var(--error);
}

.input-icon {
  position: absolute;
  left: 14px;
  opacity: 0.4;
}

.form-input {
  width: 100%;
  height: 100%;
  border: none;
  background: transparent;
  padding-left: 42px;
  padding-right: 14px;
  font-size: 14px;
  color: var(--on-dark);
  outline: none;
  border-radius: var(--radius-md);
  font-family: var(--font-body);
}

.form-input::placeholder { color: var(--on-dark-soft); }

.toggle-pwd {
  position: absolute;
  right: 5px;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border: none;
  background: transparent;
  cursor: pointer;
  border-radius: var(--radius-sm);
  opacity: 0.4;
  transition: opacity var(--transition-fast);
}

.toggle-pwd:hover { opacity: 0.7; }

.field-hint { margin: 6px 0 0; font-size: 12px; }
.field-hint.error { color: var(--error); }

/* ==================== Login Button ==================== */
.login-btn {
  width: 100%;
  height: 46px;
  border: none;
  border-radius: var(--radius-md);
  background: var(--primary);
  color: var(--on-primary);
  font-size: 15px;
  font-weight: 500;
  letter-spacing: 2px;
  cursor: pointer;
  font-family: var(--font-body);
  transition:
    background var(--transition-base),
    transform var(--transition-fast),
    box-shadow var(--transition-base),
    opacity var(--transition-base);
  display: flex;
  align-items: center;
  justify-content: center;
}

.login-btn:hover {
  background: var(--primary-active);
  box-shadow: 0 4px 14px rgba(204,120,92,0.35);
}

.login-btn:active {
  transform: scale(0.97);
}

.login-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

.btn-loading-text {
  display: flex;
  align-items: center;
  gap: 8px;
}

.spinner {
  width: 18px; height: 18px;
  border: 2px solid rgba(255,255,255,0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

@keyframes spin { to { transform: rotate(360deg); } }

/* ==================== Switch Link ==================== */
.switch-link {
  text-align: center;
  margin-top: 20px;
  font-size: 13px;
}

.switch-link a {
  color: var(--on-dark-soft);
  text-decoration: none;
  transition: color var(--transition-fast);
}

.switch-link a:hover {
  color: var(--primary);
}

/* ==================== Footer ==================== */
.footer-text {
  position: fixed;
  bottom: 24px;
  text-align: center;
  width: 100%;
  font-size: 12px;
  color: var(--on-dark-soft);
}

/* ==================== Toast ==================== */
.success-toast {
  position: fixed;
  top: 24px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(93,184,114,0.92);
  color: #fff;
  padding: 10px 24px;
  border-radius: var(--radius-md);
  font-size: 14px;
  z-index: 9999;
  box-shadow: var(--shadow-lg);
  animation: toastIn 0.3s ease-out;
}

/* ==================== Animations ==================== */
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
@keyframes slideUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
@keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
@keyframes shake { 0%,100% { transform: translateX(0); } 20%,60%,80% { transform: translateX(-4px); } 40% { transform: translateX(4px); } }
@keyframes toastIn { from { opacity: 0; transform: translateX(-50%) translateY(-16px); } to { opacity: 1; transform: translateX(-50%) translateY(0); } }

.fade-enter-active { animation: fadeIn 0.25s ease-out; }
.fade-leave-active { animation: fadeIn 0.25s ease-in reverse; }
.slide-down-enter-active { animation: slideDown 0.3s ease-out; }
.slide-down-leave-active { animation: slideDown 0.3s ease-in reverse; }
.toast-slide-enter-active { animation: toastIn 0.3s ease-out; }
.toast-slide-leave-active { animation: toastIn 0.3s ease-in reverse; }

/* ==================== Responsive ==================== */
@media (max-width: 480px) {
  .login-card { width: 100%; padding: 28px 20px; }
  .brand-title { font-size: 20px; }
}
</style>

<template>
  <div class="login-page">
    <div class="login-card">
      <!-- 全局错误提示 -->
      <transition name="slide-down">
        <div v-if="errorMsg" class="error-bar">
          <svg class="error-icon" viewBox="0 0 20 20" width="16" height="16" fill="#e74c3c">
            <path d="M10 1a9 9 0 1 0 0 18 9 9 0 0 0 0-18zm0 13.5a.75.75 0 1 1 0-1.5.75.75 0 0 1 0 1.5zm.75-9.75v6a.75.75 0 0 1-1.5 0v-6a.75.75 0 0 1 1.5 0z"/>
          </svg>
          <span>{{ errorMsg }}</span>
        </div>
      </transition>

      <!-- 品牌标识 -->
      <div class="brand">
        <div class="brand-icon">
          <svg viewBox="0 0 60 60" width="60" height="60">
            <!-- 油滴 -->
            <ellipse cx="24" cy="20" rx="6" ry="10" fill="#d4410f" transform="rotate(-15 24 20)"/>
            <ellipse cx="22" cy="16" rx="3" ry="5" fill="#e65a2b" opacity="0.6" transform="rotate(-15 22 16)"/>
            <!-- 抽油机支架 -->
            <line x1="36" y1="44" x2="36" y2="18" stroke="#d4410f" stroke-width="2.5" stroke-linecap="round"/>
            <line x1="30" y1="44" x2="42" y2="44" stroke="#d4410f" stroke-width="2.5" stroke-linecap="round"/>
            <!-- 游梁 -->
            <line x1="28" y1="22" x2="44" y2="22" stroke="#d4410f" stroke-width="2.5" stroke-linecap="round"/>
            <!-- 驴头 -->
            <circle cx="28" cy="22" r="4" fill="none" stroke="#d4410f" stroke-width="2"/>
            <!-- 曲柄 -->
            <circle cx="36" cy="26" r="5" fill="none" stroke="#d4410f" stroke-width="1.8"/>
            <!-- 连杆 -->
            <line x1="33" y1="30" x2="41" y2="24" stroke="#d4410f" stroke-width="1.5"/>
          </svg>
        </div>
        <h1 class="brand-title">油田信访管理系统</h1>
        <p class="brand-subtitle">倾听基层声音 服务油田职工</p>
        <div class="brand-divider"></div>
      </div>

      <!-- 登录表单 -->
      <form @submit.prevent="handleLogin" novalidate>
        <!-- 用户名 -->
        <div class="form-group">
          <label class="form-label">工号/用户名</label>
          <div class="input-wrapper" :class="{ 'input-error': usernameError, 'input-focused': usernameFocused }">
            <svg class="input-icon" viewBox="0 0 20 20" width="20" height="20" fill="#b0b8c5">
              <path d="M10 10a4 4 0 1 0 0-8 4 4 0 0 0 0 8zm-7 8a7 7 0 0 1 14 0H3z"/>
            </svg>
            <input
              v-model="username"
              type="text"
              class="form-input"
              placeholder="请输入工号或手机号"
              @focus="usernameFocused = true; usernameError = ''"
              @blur="validateUsername"
              @keydown.enter="handleEnter"
              autocomplete="username"
            />
          </div>
          <transition name="fade">
            <p v-if="usernameError" class="field-hint error">{{ usernameError }}</p>
          </transition>
        </div>

        <!-- 密码 -->
        <div class="form-group">
          <label class="form-label">登录密码</label>
          <div class="input-wrapper" :class="{ 'input-error': passwordError, 'input-focused': passwordFocused }">
            <svg class="input-icon" viewBox="0 0 20 20" width="20" height="20" fill="#b0b8c5">
              <rect x="3" y="8" width="14" height="10" rx="2" stroke="#b0b8c5" fill="none" stroke-width="1.5"/>
              <path d="M6 8V5a4 4 0 0 1 8 0v3" stroke="#b0b8c5" fill="none" stroke-width="1.5"/>
              <circle cx="10" cy="13" r="1" fill="#b0b8c5"/>
            </svg>
            <input
              ref="passwordInput"
              v-model="password"
              :type="showPwd ? 'text' : 'password'"
              class="form-input"
              placeholder="请输入密码"
              @focus="passwordFocused = true; passwordError = ''"
              @blur="validatePassword"
              @input="validatePasswordLength"
              @keydown.enter="handleEnter"
              autocomplete="current-password"
            />
            <button
              type="button"
              class="toggle-pwd"
              @click="showPwd = !showPwd"
              :aria-label="showPwd ? '隐藏密码' : '显示密码'"
            >
              <svg v-if="showPwd" viewBox="0 0 20 20" width="20" height="20" fill="#9098a9">
                <path d="M10 4C4 4 1 10 1 10s3 6 9 6 9-6 9-6-3-6-9-6zm0 10a4 4 0 1 1 0-8 4 4 0 0 1 0 8z"/>
                <circle cx="10" cy="10" r="2"/>
              </svg>
              <svg v-else viewBox="0 0 20 20" width="20" height="20" fill="#9098a9">
                <path d="M10 4C4 4 1 10 1 10s3 6 9 6 9-6 9-6-3-6-9-6zm0 10a4 4 0 1 1 0-8 4 4 0 0 1 0 8z"/>
                <line x1="2" y1="2" x2="18" y2="18" stroke="#9098a9" stroke-width="2" stroke-linecap="round"/>
              </svg>
            </button>
          </div>
          <transition name="fade">
            <p v-if="passwordError" class="field-hint error">{{ passwordError }}</p>
          </transition>
          <transition name="fade">
            <p v-if="passwordHint && !passwordError" class="field-hint warning">{{ passwordHint }}</p>
          </transition>
        </div>

        <!-- 记住密码 + 忘记密码 -->
        <div class="options-row">
          <label class="remember-label">
            <input type="checkbox" v-model="rememberMe" class="remember-checkbox" />
            <span class="checkmark"></span>
            <span class="remember-text">记住密码</span>
          </label>
          <a href="#" class="forgot-link" @click.prevent="handleForgot">忘记密码</a>
        </div>

        <!-- 登录按钮 -->
        <button
          type="submit"
          class="login-btn"
          :class="{ 'btn-loading': loading }"
          :disabled="loading"
        >
          <span v-if="!loading" class="btn-text">登 录</span>
          <span v-else class="btn-loading-text">
            <span class="spinner"></span>
            验证中…
          </span>
        </button>
      </form>

      <!-- 注册入口 -->
      <p class="first-time-hint">
        还没有账号？
        <a href="#" class="register-link" @click.prevent="$emit('go-register')">立即注册</a>
      </p>
      <p class="second-hint">首次登录或忘记工号？请联系本单位信访办</p>
      <p class="admin-entry">
        <a href="#" class="admin-link" @click.prevent="$emit('go-admin')">管理员入口</a>
      </p>
    </div>

    <!-- 页脚 -->
    <p class="footer-text">&copy; 2025 油田信访办公室 版本 2.1.0</p>

    <!-- 成功提示 Toast -->
    <transition name="toast-slide">
      <div v-if="successToast" class="success-toast">{{ successToast }}</div>
    </transition>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'LoginView',
  data() {
    return {
      username: '',
      password: '',
      showPwd: false,
      rememberMe: false,
      loading: false,
      usernameFocused: false,
      passwordFocused: false,
      usernameError: '',
      passwordError: '',
      passwordHint: '',
      errorMsg: '',
      successToast: '',
      lastSubmitTime: 0
    }
  },
  methods: {
    validateUsername() {
      this.usernameFocused = false
      if (!this.username.trim()) {
        this.usernameError = '请输入工号'
      } else {
        this.usernameError = ''
      }
    },
    validatePassword() {
      this.passwordFocused = false
      this.passwordHint = ''
      if (!this.password) {
        this.passwordError = '请输入密码'
      } else {
        this.passwordError = ''
      }
    },
    validatePasswordLength() {
      if (this.password && this.password.length < 6) {
        this.passwordHint = '密码长度至少6位'
      } else {
        this.passwordHint = ''
      }
    },
    handleEnter() {
      this.handleLogin()
    },
    showError(msg) {
      this.errorMsg = msg
      setTimeout(() => {
        this.errorMsg = ''
      }, 3000)
    },
    async handleLogin() {
      this.validateUsername()
      this.validatePassword()

      if (this.usernameError || this.passwordError) return
      if (!this.username.trim()) {
        this.showError('请输入工号')
        return
      }
      if (!this.password) {
        this.showError('请输入密码')
        return
      }

      // 提交防抖：2秒内禁止重复提交
      const now = Date.now()
      if (now - this.lastSubmitTime < 2000) return
      this.lastSubmitTime = now

      this.loading = true
      this.errorMsg = ''

      // 暂无后端实体类，任意账号密码均可登录
      setTimeout(() => {
        this.loading = false
        this.successToast = '登录成功，正在跳转…'
        setTimeout(() => {
          this.successToast = ''
          this.$emit('login-success', { username: this.username.trim() })
        }, 1500)
      }, 800)
    },
    handleForgot() {
      this.showError('请联系本单位信访办重置密码')
    }
  }
}
</script>

<style scoped>
/* =============================================
   Design — Login Page
   ============================================= */

/* Page Container */
.login-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: var(--canvas);
  font-family: var(--font-body);
  padding: 24px;
  position: relative;
  animation: fadeIn 0.4s ease;
}

/* ==================== Login Card ==================== */
.login-card {
  background: #ffffff;
  width: 420px;
  max-width: 100%;
  border-radius: var(--radius-xl);
  padding: 44px 36px 36px;
  box-shadow: var(--shadow-lg);
  border: 1px solid var(--hairline);
  position: relative;
  overflow: hidden;
  animation: slideUp 0.4s ease;
}

/* ==================== Error Bar ==================== */
.error-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  background: var(--error-bg);
  border: 1px solid var(--error-border);
  color: var(--error);
  border-radius: var(--radius-sm);
  padding: 12px 14px;
  margin-bottom: 16px;
  font-size: 13px;
  animation: shake 0.4s ease, slideDown 0.3s ease;
}

.error-icon {
  flex-shrink: 0;
}

/* ==================== Brand ==================== */
.brand {
  text-align: center;
  margin-bottom: 28px;
}

.brand-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 60px;
  height: 60px;
  background: var(--surface-soft);
  border-radius: var(--radius-lg);
  margin-bottom: 14px;
  transition: transform var(--transition-base);
}

.brand-icon:hover {
  transform: scale(1.05);
}

.brand-title {
  font-family: var(--font-display);
  font-size: 24px;
  font-weight: 600;
  color: var(--ink);
  line-height: 1.35;
  letter-spacing: -0.3px;
  margin: 0;
}

.brand-subtitle {
  font-size: 13px;
  color: var(--muted);
  margin: 6px 0 0;
  letter-spacing: 0.3px;
}

.brand-divider {
  height: 1px;
  background: var(--hairline);
  margin: 22px 0;
}

/* ==================== Form ==================== */
.form-group {
  margin-bottom: 20px;
}

.form-label {
  font-size: 13px;
  font-weight: 500;
  color: var(--body);
  display: block;
  margin-bottom: 6px;
  letter-spacing: 0.2px;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
  height: 46px;
  background: var(--canvas);
  border: 1px solid var(--hairline);
  border-radius: var(--radius-md);
  transition:
    border-color var(--transition-base),
    box-shadow var(--transition-base);
}

.input-wrapper:hover {
  border-color: #d5cdc4;
}

.input-wrapper.input-focused {
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(204, 120, 92, 0.15);
}

.input-wrapper.input-error {
  border-color: var(--error);
}

.input-wrapper.input-error.input-focused {
  box-shadow: 0 0 0 3px rgba(198, 69, 69, 0.15);
}

.input-icon {
  position: absolute;
  left: 14px;
  flex-shrink: 0;
  opacity: 0.45;
  transition: opacity var(--transition-fast);
}

.input-wrapper.input-focused .input-icon {
  opacity: 0.7;
}

.form-input {
  width: 100%;
  height: 100%;
  border: none;
  background: transparent;
  padding-left: 42px;
  padding-right: 14px;
  font-size: 14px;
  color: var(--ink);
  outline: none;
  border-radius: var(--radius-md);
  font-family: var(--font-body);
}

.form-input::placeholder {
  color: var(--muted-soft);
}

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
  opacity: 0.45;
  transition: opacity var(--transition-fast), background var(--transition-fast);
}

.toggle-pwd:hover {
  opacity: 0.8;
  background: var(--surface-soft);
}

/* ==================== Field Hints ==================== */
.field-hint {
  margin: 6px 0 0;
  font-size: 12px;
  line-height: 1;
  animation: fadeIn 0.2s ease;
}

.field-hint.error {
  color: var(--error);
}

.field-hint.warning {
  color: var(--warning);
}

/* ==================== Options Row ==================== */
.options-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 36px;
  margin-bottom: 24px;
}

.remember-label {
  display: flex;
  align-items: center;
  cursor: pointer;
  gap: 8px;
  position: relative;
}

.remember-checkbox {
  position: absolute;
  opacity: 0;
  width: 0;
  height: 0;
}

.checkmark {
  width: 16px;
  height: 16px;
  border: 1.5px solid #d0cbc4;
  border-radius: 3px;
  flex-shrink: 0;
  position: relative;
  transition:
    background var(--transition-base),
    border-color var(--transition-base),
    transform var(--transition-fast);
}

.remember-label:hover .checkmark {
  border-color: var(--primary);
}

.remember-checkbox:checked + .checkmark {
  background: var(--primary);
  border-color: var(--primary);
  transform: scale(1.05);
}

.remember-checkbox:checked + .checkmark::after {
  content: '';
  position: absolute;
  left: 4px;
  top: 1px;
  width: 5px;
  height: 9px;
  border: solid #fff;
  border-width: 0 2px 2px 0;
  transform: rotate(45deg);
}

.remember-text {
  font-size: 13px;
  color: var(--body);
}

.forgot-link {
  font-size: 13px;
  color: var(--primary);
  text-decoration: none;
  transition: color var(--transition-fast);
}

.forgot-link:hover {
  color: var(--primary-active);
  text-decoration: underline;
}

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
  transition:
    background var(--transition-base),
    transform var(--transition-fast),
    box-shadow var(--transition-base),
    opacity var(--transition-base);
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: var(--font-body);
}

.login-btn:hover {
  background: var(--primary-active);
  box-shadow: 0 4px 14px rgba(204, 120, 92, 0.35);
}

.login-btn:active {
  transform: scale(0.97);
  box-shadow: 0 2px 6px rgba(204, 120, 92, 0.2);
}

.login-btn:disabled {
  opacity: 0.75;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.btn-text {
  line-height: 1;
}

.btn-loading-text {
  display: flex;
  align-items: center;
  gap: 8px;
  line-height: 1;
}

.spinner {
  display: inline-block;
  width: 18px;
  height: 18px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

/* ==================== Hint Links ==================== */
.first-time-hint {
  text-align: center;
  font-size: 13px;
  color: var(--muted);
  margin-top: 20px;
}

.register-link {
  color: var(--primary);
  text-decoration: none;
  font-weight: 500;
  transition: color var(--transition-fast);
}

.register-link:hover {
  color: var(--primary-active);
  text-decoration: underline;
}

.second-hint {
  text-align: center;
  font-size: 12px;
  color: var(--muted-soft);
  margin-top: 6px;
}

.admin-entry {
  text-align: center;
  margin-top: 4px;
}

.admin-link {
  font-size: 12px;
  color: var(--muted-soft);
  text-decoration: none;
  transition: color var(--transition-fast);
}

.admin-link:hover {
  color: var(--primary);
}

/* ==================== Footer ==================== */
.footer-text {
  position: fixed;
  bottom: 24px;
  left: 0;
  right: 0;
  text-align: center;
  font-size: 12px;
  color: var(--muted-soft);
}

/* ==================== Success Toast ==================== */
.success-toast {
  position: fixed;
  top: 24px;
  left: 50%;
  transform: translateX(-50%);
  background: var(--ink);
  color: var(--on-dark);
  padding: 10px 24px;
  border-radius: var(--radius-md);
  font-size: 14px;
  z-index: 9999;
  box-shadow: var(--shadow-lg);
  animation: toastIn 0.3s ease-out;
}

/* ==================== Animations ==================== */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideUp {
  from { opacity: 0; transform: translateY(16px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes slideDown {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  20% { transform: translateX(-6px); }
  40% { transform: translateX(6px); }
  60% { transform: translateX(-4px); }
  80% { transform: translateX(4px); }
}

@keyframes toastIn {
  from { opacity: 0; transform: translateX(-50%) translateY(-16px); }
  to { opacity: 1; transform: translateX(-50%) translateY(0); }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* ==================== Transition Classes ==================== */
.slide-down-enter-active {
  animation: slideDown 0.3s ease-out;
}
.slide-down-leave-active {
  animation: slideDown 0.3s ease-in reverse;
}

.fade-enter-active {
  animation: fadeIn 0.25s ease-out;
}
.fade-leave-active {
  animation: fadeIn 0.25s ease-in reverse;
}

.toast-slide-enter-active {
  animation: toastIn 0.3s ease-out;
}
.toast-slide-leave-active {
  animation: toastIn 0.3s ease-in reverse;
}

/* ==================== Responsive ==================== */
@media (max-width: 480px) {
  .login-card {
    width: 100%;
    padding: 28px 20px;
  }

  .brand-title {
    font-size: 20px;
  }

  .input-wrapper {
    height: 44px;
  }

  .login-btn {
    height: 44px;
  }

  .footer-text {
    position: static;
    margin-top: 16px;
  }
}
</style>

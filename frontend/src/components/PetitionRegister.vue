<template>
  <div class="petition-register-page">
    <header class="page-header">
      <div class="header-left">
        <button class="btn-back" @click="$emit('go-home')">← 返回首页</button>
      </div>
      <div class="header-center">
        <h1>信访登记表</h1>
        <p>请如实填写以下信息，带 <span class="required-star">*</span> 的为必填项</p>
      </div>
      <div class="header-right"></div>
    </header>

    <div class="form-container">
      <form @submit.prevent="handleSubmit">

        <!-- 信访人信息 -->
        <div class="form-section">
          <h3 class="section-title">信访人信息</h3>
          <div class="form-row">
            <div class="form-group">
              <label><span class="required-star">*</span> 信访人姓名</label>
              <input v-model="form.petitionerName" type="text" maxlength="50"
                placeholder="请输入信访人姓名" />
              <span class="field-error" v-if="errors.petitionerName">{{ errors.petitionerName }}</span>
            </div>
            <div class="form-group">
              <label><span class="required-star">*</span> 身份证号</label>
              <input v-model="form.petitionerIdCard" type="text" maxlength="18"
                placeholder="请输入18位身份证号" />
              <span class="field-error" v-if="errors.petitionerIdCard">{{ errors.petitionerIdCard }}</span>
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label><span class="required-star">*</span> 联系电话</label>
              <input v-model="form.petitionerPhone" type="text" maxlength="11"
                placeholder="请输入手机号码" />
              <span class="field-error" v-if="errors.petitionerPhone">{{ errors.petitionerPhone }}</span>
            </div>
            <div class="form-group">
              <label>工号</label>
              <input v-model="form.petitionerEmployeeNo" type="text" maxlength="32"
                placeholder="请输入工号（选填）" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group full-width">
              <label>联系地址</label>
              <input v-model="form.petitionerAddress" type="text" maxlength="200"
                placeholder="请输入联系地址（选填）" />
            </div>
          </div>
        </div>

        <!-- 信访渠道 -->
        <div class="form-section">
          <h3 class="section-title">信访渠道</h3>
          <div class="form-row">
            <div class="form-group">
              <label><span class="required-star">*</span> 信访渠道</label>
              <select v-model="form.channelCode">
                <option value="">请选择信访渠道</option>
                <option value="visit">来访</option>
                <option value="letter">来信</option>
                <option value="call">来电</option>
                <option value="online">网上信访</option>
              </select>
              <span class="field-error" v-if="errors.channelCode">{{ errors.channelCode }}</span>
            </div>
            <div class="form-group">
              <label><span class="required-star">*</span> 是否集体访</label>
              <select v-model="form.isCollective">
                <option :value="null">请选择</option>
                <option :value="0">个人访</option>
                <option :value="1">集体访</option>
              </select>
              <span class="field-error" v-if="errors.isCollective">{{ errors.isCollective }}</span>
            </div>
          </div>

          <!-- 来访字段 -->
          <div class="form-row" v-if="form.channelCode === 'visit'">
            <div class="form-group">
              <label>来访日期</label>
              <input v-model="form.visitDate" type="date" />
            </div>
            <div class="form-group">
              <label>接访人</label>
              <input v-model="form.receptionist" type="text" maxlength="50"
                placeholder="请输入接访人姓名" />
            </div>
          </div>

          <!-- 来信字段 -->
          <div class="form-row" v-if="form.channelCode === 'letter'">
            <div class="form-group">
              <label>收件日期</label>
              <input v-model="form.letterReceiveDate" type="date" />
            </div>
            <div class="form-group">
              <label>来信邮编</label>
              <input v-model="form.letterPostCode" type="text" maxlength="20"
                placeholder="请输入来信邮编" />
            </div>
          </div>

          <!-- 来电字段 -->
          <div class="form-row" v-if="form.channelCode === 'call'">
            <div class="form-group">
              <label>来电日期</label>
              <input v-model="form.callDate" type="date" />
            </div>
            <div class="form-group">
              <label>来电号码</label>
              <input v-model="form.callerNumber" type="text" maxlength="100"
                placeholder="请输入来电号码" />
            </div>
          </div>

          <!-- 集体访人数 -->
          <div class="form-row" v-if="form.isCollective === 1">
            <div class="form-group">
              <label><span class="required-star">*</span> 来访人数</label>
              <input v-model.number="form.visitorCount" type="number" min="1"
                placeholder="请输入来访人数" />
              <span class="field-error" v-if="errors.visitorCount">{{ errors.visitorCount }}</span>
            </div>
            <div class="form-group"></div>
          </div>
        </div>

        <!-- 诉求信息 -->
        <div class="form-section">
          <h3 class="section-title">诉求信息</h3>
          <div class="form-row">
            <div class="form-group">
              <label><span class="required-star">*</span> 诉求类别一级</label>
              <select v-model="form.appealCategoryLevel1" @change="onLevel1Change">
                <option value="">请选择诉求类别</option>
                <option v-for="(items, key) in categories" :key="key" :value="key">{{ key }}</option>
              </select>
              <span class="field-error" v-if="errors.appealCategoryLevel1">{{ errors.appealCategoryLevel1 }}</span>
            </div>
            <div class="form-group">
              <label>诉求类别二级</label>
              <select v-model="form.appealCategoryLevel2" :disabled="!form.appealCategoryLevel1">
                <option value="">请选择二级类别</option>
                <option v-for="item in level2Options" :key="item" :value="item">{{ item }}</option>
              </select>
            </div>
          </div>
          <div class="form-row">
            <div class="form-group full-width">
              <label><span class="required-star">*</span> 诉求内容</label>
              <textarea v-model="form.appealContent" rows="6"
                placeholder="请详细描述您的诉求内容，包括事情经过、涉及人员、时间地点等"></textarea>
              <span class="char-count">{{ form.appealContent.length }} 字</span>
              <span class="field-error" v-if="errors.appealContent">{{ errors.appealContent }}</span>
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>关键词</label>
              <input v-model="form.keywordTags" type="text" maxlength="500"
                placeholder="多个关键词用逗号分隔（选填）" />
            </div>
            <div class="form-group">
              <label>涉及单位</label>
              <input v-model="form.involvedOrgIds" type="text" maxlength="500"
                placeholder="请输入涉及单位名称（选填）" />
            </div>
          </div>
        </div>

        <!-- 操作按钮 -->
        <div class="form-actions">
          <button type="button" class="btn-reset" @click="handleReset">重 置</button>
          <button type="submit" class="btn-submit" :disabled="submitting">
            <span v-if="submitting" class="spinner"></span>
            {{ submitting ? '提交中...' : '提 交' }}
          </button>
        </div>

      </form>
    </div>

    <!-- 成功提示弹窗 -->
    <div class="toast-overlay" v-if="successToast" @click="successToast = ''">
      <div class="toast-card" @click.stop>
        <div class="toast-icon">✓</div>
        <h2>登记成功</h2>
        <p>您的信访诉求已成功提交</p>
        <div class="toast-code">
          <span class="code-label">信访编号</span>
          <span class="code-value">{{ submittedCode }}</span>
        </div>
        <p class="toast-note">请妥善保存此编号，用于后续进度查询</p>
        <button class="btn-back-home" @click="$emit('go-home')">返回首页</button>
      </div>
    </div>

    <!-- 错误提示 -->
    <div class="toast-error" v-if="errorToast">{{ errorToast }}</div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'PetitionRegister',
  emits: ['go-home'],
  data() {
    return {
      categories: {},
      form: {
        petitionerName: '',
        petitionerIdCard: '',
        petitionerPhone: '',
        petitionerAddress: '',
        petitionerEmployeeNo: '',
        channelCode: '',
        isCollective: null,
        visitorCount: null,
        receptionist: '',
        visitDate: '',
        letterReceiveDate: '',
        letterPostCode: '',
        callDate: '',
        callerNumber: '',
        appealCategoryLevel1: '',
        appealCategoryLevel2: '',
        appealCategoryLevel3: '',
        appealContent: '',
        keywordTags: '',
        involvedOrgIds: ''
      },
      errors: {},
      submitting: false,
      successToast: '',
      submittedCode: '',
      errorToast: ''
    }
  },
  computed: {
    level2Options() {
      if (!this.form.appealCategoryLevel1) return []
      return this.categories[this.form.appealCategoryLevel1] || []
    }
  },
  mounted() {
    this.fetchCategories()
  },
  methods: {
    async fetchCategories() {
      try {
        const res = await axios.get('/api/petitions/categories')
        if (res.data.success) {
          this.categories = res.data.data
        }
      } catch {
        // fallback to empty
      }
    },
    onLevel1Change() {
      this.form.appealCategoryLevel2 = ''
      this.form.appealCategoryLevel3 = ''
    },
    validate() {
      this.errors = {}
      if (!this.form.petitionerName.trim()) {
        this.errors.petitionerName = '请输入信访人姓名'
      }
      if (!this.form.petitionerIdCard.trim()) {
        this.errors.petitionerIdCard = '请输入身份证号'
      } else if (!/^(\d{18}|\d{17}[Xx])$/.test(this.form.petitionerIdCard.trim())) {
        this.errors.petitionerIdCard = '身份证号格式不正确'
      }
      if (!this.form.petitionerPhone.trim()) {
        this.errors.petitionerPhone = '请输入联系电话'
      } else if (!/^1\d{10}$/.test(this.form.petitionerPhone.trim())) {
        this.errors.petitionerPhone = '手机号码格式不正确'
      }
      if (!this.form.channelCode) {
        this.errors.channelCode = '请选择信访渠道'
      }
      if (this.form.isCollective === null) {
        this.errors.isCollective = '请选择是否集体访'
      }
      if (this.form.isCollective === 1 && !this.form.visitorCount) {
        this.errors.visitorCount = '请输入来访人数'
      }
      if (!this.form.appealCategoryLevel1) {
        this.errors.appealCategoryLevel1 = '请选择诉求类别'
      }
      if (!this.form.appealContent.trim()) {
        this.errors.appealContent = '请输入诉求内容'
      }
      return Object.keys(this.errors).length === 0
    },
    buildPayload() {
      const p = { ...this.form }
      if (p.isCollective !== 1) p.visitorCount = null
      if (p.channelCode !== 'visit') {
        p.visitDate = ''
        p.receptionist = ''
      }
      if (p.channelCode !== 'letter') {
        p.letterReceiveDate = ''
        p.letterPostCode = ''
      }
      if (p.channelCode !== 'call') {
        p.callDate = ''
        p.callerNumber = ''
      }
      // Convert date strings to ISO format or null
      return {
        petitionerName: p.petitionerName.trim(),
        petitionerIdCard: p.petitionerIdCard.trim(),
        petitionerPhone: p.petitionerPhone.trim(),
        petitionerAddress: p.petitionerAddress.trim(),
        petitionerEmployeeNo: p.petitionerEmployeeNo.trim(),
        channelCode: p.channelCode,
        isCollective: p.isCollective,
        visitorCount: p.visitorCount,
        receptionist: p.receptionist || null,
        visitDate: p.visitDate ? new Date(p.visitDate).toISOString() : null,
        letterReceiveDate: p.letterReceiveDate ? new Date(p.letterReceiveDate).toISOString() : null,
        letterPostCode: p.letterPostCode || null,
        callDate: p.callDate ? new Date(p.callDate).toISOString() : null,
        callerNumber: p.callerNumber || null,
        appealCategoryLevel1: p.appealCategoryLevel1,
        appealCategoryLevel2: p.appealCategoryLevel2 || null,
        appealCategoryLevel3: p.appealCategoryLevel3 || null,
        appealContent: p.appealContent.trim(),
        keywordTags: p.keywordTags.trim() || null,
        involvedOrgIds: p.involvedOrgIds.trim() || null
      }
    },
    async handleSubmit() {
      if (!this.validate()) return

      this.submitting = true
      try {
        const payload = this.buildPayload()
        const res = await axios.post('/api/petitions', payload)
        if (res.data.success) {
          this.submittedCode = res.data.petitionCode
          this.successToast = true
        } else {
          this.errorToast = res.data.message || '提交失败，请重试'
        }
      } catch (err) {
        this.errorToast = err.response?.data?.message || '网络错误，请稍后重试'
      } finally {
        this.submitting = false
      }
    },
    handleReset() {
      this.form = {
        petitionerName: '',
        petitionerIdCard: '',
        petitionerPhone: '',
        petitionerAddress: '',
        petitionerEmployeeNo: '',
        channelCode: '',
        isCollective: null,
        visitorCount: null,
        receptionist: '',
        visitDate: '',
        letterReceiveDate: '',
        letterPostCode: '',
        callDate: '',
        callerNumber: '',
        appealCategoryLevel1: '',
        appealCategoryLevel2: '',
        appealCategoryLevel3: '',
        appealContent: '',
        keywordTags: '',
        involvedOrgIds: ''
      }
      this.errors = {}
    }
  },
  watch: {
    errorToast(val) {
      if (val) setTimeout(() => { this.errorToast = '' }, 3000)
    }
  }
}
</script>

<style scoped>
/* =============================================
   Design — Petition Register
   ============================================= */
.petition-register-page {
  min-height: 100vh;
  background: var(--canvas);
  font-family: var(--font-body);
  animation: fadeIn 0.4s ease;
}

/* ==================== Header ==================== */
.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 40px;
  background: #ffffff;
  border-bottom: 1px solid var(--hairline);
}

.header-center {
  text-align: center;
  flex: 1;
}

.header-center h1 {
  font-family: var(--font-display);
  font-size: 20px;
  font-weight: 600;
  color: var(--ink);
  letter-spacing: -0.3px;
  margin: 0 0 4px;
}

.header-center p {
  margin: 0;
  font-size: 13px;
  color: var(--muted);
}

.header-left, .header-right { width: 120px; }

.required-star { color: var(--error); font-weight: bold; }

.btn-back {
  background: none;
  border: 1px solid var(--primary);
  color: var(--primary);
  padding: 8px 18px;
  border-radius: var(--radius-md);
  cursor: pointer;
  font-size: 14px;
  font-family: var(--font-body);
  transition:
    background var(--transition-fast),
    color var(--transition-fast);
}

.btn-back:hover {
  background: var(--primary);
  color: var(--on-primary);
}

.btn-back:active {
  transform: scale(0.97);
}

/* ==================== Form Container ==================== */
.form-container {
  max-width: 720px;
  margin: 24px auto 40px;
  background: #ffffff;
  border-radius: var(--radius-xl);
  border: 1px solid var(--hairline);
  box-shadow: var(--shadow-lg);
  padding: 36px 40px;
  animation: slideUp 0.4s ease;
}

/* ==================== Sections ==================== */
.form-section {
  margin-bottom: 28px;
  padding-bottom: 24px;
  border-bottom: 1px solid var(--hairline-soft);
}

.form-section:last-of-type {
  border-bottom: none;
  margin-bottom: 0;
}

.section-title {
  font-family: var(--font-display);
  font-size: 16px;
  font-weight: 600;
  color: var(--ink);
  margin: 0 0 18px;
  padding-left: 12px;
  border-left: 3px solid var(--primary);
  letter-spacing: -0.2px;
}

/* ==================== Form Layout ==================== */
.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 16px;
}

.form-row:last-child { margin-bottom: 0; }

.form-group {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.form-group.full-width { flex: 2; }

.form-group label {
  font-size: 13px;
  font-weight: 500;
  color: var(--body);
  margin-bottom: 6px;
}

.form-group input,
.form-group select,
.form-group textarea {
  padding: 10px 14px;
  border: 1px solid var(--hairline);
  border-radius: var(--radius-md);
  font-size: 14px;
  color: var(--ink);
  background: var(--canvas);
  transition:
    border-color var(--transition-base),
    box-shadow var(--transition-base);
  outline: none;
  font-family: var(--font-body);
}

.form-group input:hover,
.form-group select:hover,
.form-group textarea:hover {
  border-color: #d5cdc4;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(204, 120, 92, 0.15);
}

.form-group input::placeholder,
.form-group textarea::placeholder { color: var(--muted-soft); }

.form-group select:disabled {
  background: var(--surface-soft);
  color: var(--muted);
  cursor: not-allowed;
}

.form-group textarea {
  resize: vertical;
  min-height: 100px;
  line-height: 1.6;
}

.char-count {
  text-align: right;
  font-size: 12px;
  color: var(--muted-soft);
  margin-top: 4px;
}

.field-error {
  font-size: 12px;
  color: var(--error);
  margin-top: 4px;
  animation: fadeIn 0.2s ease;
}

/* ==================== Action Buttons ==================== */
.form-actions {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-top: 32px;
  padding-top: 24px;
  border-top: 1px solid var(--hairline-soft);
}

.btn-submit {
  padding: 12px 48px;
  border: none;
  border-radius: var(--radius-md);
  background: var(--primary);
  color: var(--on-primary);
  font-size: 15px;
  font-weight: 500;
  cursor: pointer;
  font-family: var(--font-body);
  transition:
    background var(--transition-base),
    transform var(--transition-fast),
    box-shadow var(--transition-base),
    opacity var(--transition-base);
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.btn-submit:hover:not(:disabled) {
  background: var(--primary-active);
  box-shadow: 0 4px 14px rgba(204,120,92,0.35);
}

.btn-submit:active:not(:disabled) {
  transform: scale(0.97);
}

.btn-submit:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-reset {
  padding: 12px 36px;
  border: 1px solid var(--hairline);
  border-radius: var(--radius-md);
  background: #ffffff;
  color: var(--muted);
  font-size: 14px;
  cursor: pointer;
  font-family: var(--font-body);
  transition:
    background var(--transition-fast),
    border-color var(--transition-fast),
    color var(--transition-fast);
}

.btn-reset:hover {
  background: var(--canvas);
  border-color: #d5cdc4;
  color: var(--body);
}

.btn-reset:active {
  transform: scale(0.98);
}

.spinner {
  display: inline-block;
  width: 14px; height: 14px;
  border: 2px solid rgba(255,255,255,0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
  margin-right: 6px;
  vertical-align: middle;
}

@keyframes spin { to { transform: rotate(360deg); } }

/* ==================== Success Toast ==================== */
.toast-overlay {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(20,20,19,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: fadeIn 0.2s ease;
}

.toast-card {
  background: #ffffff;
  border-radius: var(--radius-xl);
  padding: 40px 48px;
  text-align: center;
  box-shadow: var(--shadow-xl);
  border: 1px solid var(--hairline);
  animation: slideUp 0.3s ease;
  max-width: 400px;
  width: 90%;
}

.toast-icon {
  width: 56px; height: 56px;
  border-radius: 50%;
  background: var(--success-bg);
  color: var(--success);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  font-weight: bold;
  margin-bottom: 16px;
}

.toast-card h2 {
  font-family: var(--font-display);
  margin: 0 0 8px;
  font-size: 20px;
  color: var(--ink);
}

.toast-card > p {
  margin: 0 0 20px;
  color: var(--muted);
  font-size: 14px;
}

.toast-code {
  background: var(--surface-soft);
  border-radius: var(--radius-md);
  padding: 16px 24px;
  margin-bottom: 8px;
}

.code-label {
  display: block;
  font-size: 12px;
  color: var(--muted);
  margin-bottom: 4px;
}

.code-value {
  font-size: 22px;
  font-weight: 700;
  color: var(--primary);
  letter-spacing: 1px;
}

.toast-note {
  font-size: 12px;
  color: var(--warning);
  margin: 12px 0 20px;
}

.btn-back-home {
  padding: 10px 36px;
  background: var(--primary);
  color: var(--on-primary);
  border: none;
  border-radius: var(--radius-md);
  font-size: 14px;
  cursor: pointer;
  font-family: var(--font-body);
  transition:
    background var(--transition-fast),
    transform var(--transition-fast);
}

.btn-back-home:hover {
  background: var(--primary-active);
}

.btn-back-home:active {
  transform: scale(0.97);
}

/* ==================== Error Toast ==================== */
.toast-error {
  position: fixed;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  background: var(--error-bg);
  color: var(--error);
  padding: 12px 28px;
  border-radius: var(--radius-md);
  font-size: 14px;
  z-index: 1001;
  border: 1px solid var(--error-border);
  box-shadow: var(--shadow-md);
  animation: toastIn 0.3s ease;
}

/* ==================== Animations ==================== */
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
@keyframes slideUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
@keyframes toastIn { from { opacity: 0; transform: translateX(-50%) translateY(-12px); } to { opacity: 1; transform: translateX(-50%) translateY(0); } }
</style>

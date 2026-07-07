<template>
  <div class="register-page">
    <div class="register-card">
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
        <h1 class="brand-title">油田信访管理系统</h1>
        <p class="brand-subtitle">用户注册</p>
        <div class="brand-divider"></div>
      </div>

      <!-- 注册表单 -->
      <form @submit.prevent="handleRegister" novalidate>
        <!-- 第一行：姓名 + 性别 -->
        <div class="form-row">
          <div class="form-group form-group-half">
            <label class="form-label"><span class="required">*</span>姓名</label>
            <div class="input-wrapper" :class="{ 'input-error': errors.name, 'input-focused': focused.name }">
              <input
                v-model="form.name"
                type="text"
                class="form-input"
                placeholder="请输入真实姓名"
                @focus="focused.name = true; clearError('name')"
                @blur="focused.name = false; validate('name')"
              />
            </div>
            <transition name="fade"><p v-if="errors.name" class="field-hint error">{{ errors.name }}</p></transition>
          </div>
          <div class="form-group form-group-half">
            <label class="form-label"><span class="required">*</span>性别</label>
            <div class="input-wrapper" :class="{ 'input-error': errors.gender, 'input-focused': focused.gender }">
              <select
                v-model="form.gender"
                class="form-input form-select"
                @focus="focused.gender = true; clearError('gender')"
                @blur="focused.gender = false; validate('gender')"
              >
                <option value="" disabled>请选择</option>
                <option value="male">男</option>
                <option value="female">女</option>
              </select>
            </div>
            <transition name="fade"><p v-if="errors.gender" class="field-hint error">{{ errors.gender }}</p></transition>
          </div>
        </div>

        <!-- 第二行：证件类型 + 证件号码 -->
        <div class="form-row">
          <div class="form-group form-group-half">
            <label class="form-label"><span class="required">*</span>证件类型</label>
            <div class="input-wrapper" :class="{ 'input-error': errors.idType, 'input-focused': focused.idType }">
              <select
                v-model="form.idType"
                class="form-input form-select"
                @focus="focused.idType = true; clearError('idType')"
                @blur="focused.idType = false; validate('idType')"
              >
                <option value="" disabled>请选择</option>
                <option value="idcard">居民身份证</option>
                <option value="passport">护照</option>
                <option value="officer">军官证</option>
              </select>
            </div>
            <transition name="fade"><p v-if="errors.idType" class="field-hint error">{{ errors.idType }}</p></transition>
          </div>
          <div class="form-group form-group-half">
            <label class="form-label"><span class="required">*</span>证件号码</label>
            <div class="input-wrapper" :class="{ 'input-error': errors.idNumber, 'input-focused': focused.idNumber }">
              <input
                v-model="form.idNumber"
                type="text"
                class="form-input"
                :placeholder="idNumberPlaceholder"
                :maxlength="idNumberMaxLength"
                @focus="focused.idNumber = true; clearError('idNumber')"
                @blur="focused.idNumber = false; validate('idNumber')"
                @input="filterIdNumber"
              />
            </div>
            <transition name="fade"><p v-if="errors.idNumber" class="field-hint error">{{ errors.idNumber }}</p></transition>
          </div>
        </div>

        <!-- 住址：省市区三级 -->
        <div class="form-group">
          <label class="form-label"><span class="required">*</span>住址</label>
          <div class="form-row">
            <div class="form-group-third">
              <select
                v-model="form.province"
                class="form-input form-select"
                :class="{ 'input-error': errors.province }"
                @change="onProvinceChange"
              >
                <option value="" disabled>请选择省</option>
                <option v-for="p in regions" :key="p.name" :value="p.name">{{ p.name }}</option>
              </select>
            </div>
            <div class="form-group-third">
              <select
                v-model="form.city"
                class="form-input form-select"
                :class="{ 'input-error': errors.province }"
                @change="onCityChange"
              >
                <option value="" disabled>请选择市</option>
                <option v-for="c in availableCities" :key="c.name" :value="c.name">{{ c.name }}</option>
              </select>
            </div>
            <div class="form-group-third">
              <select
                v-model="form.district"
                class="form-input form-select"
                :class="{ 'input-error': errors.province }"
                @change="errors.province = ''"
              >
                <option value="" disabled>请选择区</option>
                <option v-for="d in availableDistricts" :key="d" :value="d">{{ d }}</option>
              </select>
            </div>
          </div>
          <transition name="fade"><p v-if="errors.province" class="field-hint error">{{ errors.province }}</p></transition>
        </div>

        <!-- 详细住址 -->
        <div class="form-group">
          <label class="form-label"><span class="required">*</span>详细住址</label>
          <div class="input-wrapper" :class="{ 'input-error': errors.detailAddress, 'input-focused': focused.detailAddress }">
            <input
              v-model="form.detailAddress"
              type="text"
              class="form-input"
              placeholder="请具体填写所在镇、街道、社区、村"
              @focus="focused.detailAddress = true; clearError('detailAddress')"
              @blur="focused.detailAddress = false; validate('detailAddress')"
            />
          </div>
          <transition name="fade"><p v-if="errors.detailAddress" class="field-hint error">{{ errors.detailAddress }}</p></transition>
        </div>

        <!-- 第三行：出生日期 + 政治面貌 -->
        <div class="form-row">
          <div class="form-group form-group-half">
            <label class="form-label"><span class="required">*</span>出生日期</label>
            <div class="input-wrapper" :class="{ 'input-error': errors.birthdate, 'input-focused': focused.birthdate }">
              <input
                v-model="form.birthdate"
                type="date"
                class="form-input"
                @focus="focused.birthdate = true; clearError('birthdate')"
                @blur="focused.birthdate = false; validate('birthdate')"
              />
            </div>
            <transition name="fade"><p v-if="errors.birthdate" class="field-hint error">{{ errors.birthdate }}</p></transition>
          </div>
          <div class="form-group form-group-half">
            <label class="form-label"><span class="required">*</span>政治面貌</label>
            <div class="input-wrapper" :class="{ 'input-error': errors.political, 'input-focused': focused.political }">
              <select
                v-model="form.political"
                class="form-input form-select"
                @focus="focused.political = true; clearError('political')"
                @blur="focused.political = false; validate('political')"
              >
                <option value="" disabled>请选择</option>
                <option value="mass">群众</option>
                <option value="member">共青团员</option>
                <option value="party">中共党员</option>
                <option value="other">其他党派</option>
              </select>
            </div>
            <transition name="fade"><p v-if="errors.political" class="field-hint error">{{ errors.political }}</p></transition>
          </div>
        </div>

        <!-- 第四行：民族 + 职业 -->
        <div class="form-row">
          <div class="form-group form-group-half">
            <label class="form-label">民族</label>
            <div class="input-wrapper" :class="{ 'input-focused': focused.ethnicity }">
              <select
                v-model="form.ethnicity"
                class="form-input form-select"
                @focus="focused.ethnicity = true"
                @blur="focused.ethnicity = false"
              >
                <option value="" disabled>请选择</option>
                <option value="han">汉族</option>
                <option value="hui">回族</option>
                <option value="man">满族</option>
                <option value="mongol">蒙古族</option>
                <option value="tibetan">藏族</option>
                <option value="uyghur">维吾尔族</option>
                <option value="other">其他</option>
              </select>
            </div>
          </div>
          <div class="form-group form-group-half">
            <label class="form-label"><span class="required">*</span>职业</label>
            <div class="input-wrapper" :class="{ 'input-error': errors.occupation, 'input-focused': focused.occupation }">
              <select
                v-model="form.occupation"
                class="form-input form-select"
                @focus="focused.occupation = true; clearError('occupation')"
                @blur="focused.occupation = false; validate('occupation')"
              >
                <option value="" disabled>请选择</option>
                <option v-for="o in occupationOptions" :key="o" :value="o">{{ o }}</option>
              </select>
            </div>
            <transition name="fade"><p v-if="errors.occupation" class="field-hint error">{{ errors.occupation }}</p></transition>
          </div>
        </div>

        <!-- 第五行：工作单位 + 邮政编码 -->
        <div class="form-row">
          <div class="form-group form-group-half">
            <label class="form-label">工作单位</label>
            <div class="input-wrapper" :class="{ 'input-focused': focused.workUnit }">
              <input
                v-model="form.workUnit"
                type="text"
                class="form-input"
                placeholder="请输入工作单位"
                @focus="focused.workUnit = true"
                @blur="focused.workUnit = false"
              />
            </div>
          </div>
          <div class="form-group form-group-half">
            <label class="form-label">邮政编码</label>
            <div class="input-wrapper" :class="{ 'input-focused': focused.postalCode }">
              <input
                v-model="form.postalCode"
                type="text"
                class="form-input"
                placeholder="请输入邮政编码"
                @focus="focused.postalCode = true"
                @blur="focused.postalCode = false"
              />
            </div>
          </div>
        </div>

        <!-- 电子邮箱 -->
        <div class="form-group">
          <label class="form-label">电子邮箱</label>
          <div class="input-wrapper" :class="{ 'input-focused': focused.email }">
            <input
              v-model="form.email"
              type="email"
              class="form-input"
              placeholder="请输入电子邮箱"
              @focus="focused.email = true"
              @blur="focused.email = false"
            />
          </div>
        </div>

        <!-- 户口所在地 -->
        <div class="form-group">
          <label class="form-label">户口所在地</label>
          <div class="input-wrapper" :class="{ 'input-focused': focused.hukou }">
            <input
              v-model="form.hukou"
              type="text"
              class="form-input"
              placeholder="请输入户口所在地"
              @focus="focused.hukou = true"
              @blur="focused.hukou = false"
            />
          </div>
        </div>

        <!-- 通讯地址 -->
        <div class="form-group">
          <label class="form-label">通讯地址</label>
          <div class="input-wrapper" :class="{ 'input-focused': focused.mailingAddress }">
            <input
              v-model="form.mailingAddress"
              type="text"
              class="form-input"
              placeholder="请输入通讯地址"
              @focus="focused.mailingAddress = true"
              @blur="focused.mailingAddress = false"
            />
          </div>
        </div>

        <!-- 第六行：固定电话 + 手机号码 -->
        <div class="form-row">
          <div class="form-group form-group-half">
            <label class="form-label">固定电话</label>
            <div class="input-wrapper" :class="{ 'input-focused': focused.landline }">
              <input
                v-model="form.landline"
                type="text"
                class="form-input"
                placeholder="请输入固定电话"
                @focus="focused.landline = true"
                @blur="focused.landline = false"
              />
            </div>
          </div>
          <div class="form-group form-group-half">
            <label class="form-label"><span class="required">*</span>手机号码</label>
            <div class="input-wrapper" :class="{ 'input-error': errors.mobile, 'input-focused': focused.mobile }">
              <input
                v-model="form.mobile"
                type="text"
                class="form-input"
                placeholder="请输入手机号码"
                @focus="focused.mobile = true; clearError('mobile')"
                @blur="focused.mobile = false; validate('mobile')"
              />
            </div>
            <transition name="fade"><p v-if="errors.mobile" class="field-hint error">{{ errors.mobile }}</p></transition>
          </div>
        </div>

        <!-- 手机验证码 -->
        <div class="form-group">
          <label class="form-label"><span class="required">*</span>手机验证码</label>
          <div class="input-wrapper" :class="{ 'input-error': errors.smsCode, 'input-focused': focused.smsCode }">
            <input
              v-model="form.smsCode"
              type="text"
              class="form-input sms-input"
              placeholder="请输入手机验证码"
              @focus="focused.smsCode = true; clearError('smsCode')"
              @blur="focused.smsCode = false; validate('smsCode')"
            />
            <button
              type="button"
              class="sms-btn"
              :disabled="smsCountdown > 0"
              @click="sendSmsCode"
            >
              {{ smsCountdown > 0 ? smsCountdown + 's后重发' : '获取验证码' }}
            </button>
          </div>
          <transition name="fade"><p v-if="errors.smsCode" class="field-hint error">{{ errors.smsCode }}</p></transition>
        </div>

        <!-- 验证问题 + 验证答案 -->
        <div class="form-row">
          <div class="form-group form-group-half">
            <label class="form-label"><span class="required">*</span>验证问题</label>
            <div class="input-wrapper" :class="{ 'input-error': errors.verifyQuestion, 'input-focused': focused.verifyQuestion }">
              <select
                v-model="form.verifyQuestion"
                class="form-input form-select"
                @focus="focused.verifyQuestion = true; clearError('verifyQuestion')"
                @blur="focused.verifyQuestion = false; validate('verifyQuestion')"
              >
                <option value="" disabled>请选择</option>
                <option value="school">您就读的第一所小学名称？</option>
                <option value="mother">您母亲的名字？</option>
                <option value="pet">您最喜欢的宠物名字？</option>
                <option value="city">您出生的城市？</option>
              </select>
            </div>
            <transition name="fade"><p v-if="errors.verifyQuestion" class="field-hint error">{{ errors.verifyQuestion }}</p></transition>
          </div>
          <div class="form-group form-group-half">
            <label class="form-label"><span class="required">*</span>验证答案</label>
            <div class="input-wrapper" :class="{ 'input-error': errors.verifyAnswer, 'input-focused': focused.verifyAnswer }">
              <input
                v-model="form.verifyAnswer"
                type="text"
                class="form-input"
                placeholder="请输入验证答案"
                @focus="focused.verifyAnswer = true; clearError('verifyAnswer')"
                @blur="focused.verifyAnswer = false; validate('verifyAnswer')"
              />
            </div>
            <transition name="fade"><p v-if="errors.verifyAnswer" class="field-hint error">{{ errors.verifyAnswer }}</p></transition>
          </div>
        </div>

        <!-- 按钮区 -->
        <div class="btn-row">
          <button
            type="submit"
            class="register-btn"
            :class="{ 'btn-loading': loading }"
            :disabled="loading"
          >
            <span v-if="!loading" class="btn-text">下一步</span>
            <span v-else class="btn-loading-text">
              <span class="spinner"></span>
              提交中…
            </span>
          </button>
          <button type="button" class="reset-btn" @click="handleReset">重置</button>
        </div>
      </form>

      <!-- 返回登录 -->
      <p class="switch-hint">
        已有账号？
        <a href="#" class="switch-link" @click.prevent="$emit('go-login')">返回登录</a>
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
export default {
  name: 'RegisterView',
  emits: ['go-login'],
  data() {
    return {
      form: {
        name: '',
        gender: '',
        idType: '',
        idNumber: '',
        province: '',
        city: '',
        district: '',
        detailAddress: '',
        birthdate: '',
        political: '',
        ethnicity: '',
        occupation: '',
        workUnit: '',
        postalCode: '',
        email: '',
        hukou: '',
        mailingAddress: '',
        landline: '',
        mobile: '',
        smsCode: '',
        verifyQuestion: '',
        verifyAnswer: ''
      },
      focused: {
        name: false, gender: false, idType: false, idNumber: false,
        detailAddress: false, birthdate: false, political: false,
        ethnicity: false, occupation: false, workUnit: false, postalCode: false,
        email: false, hukou: false, mailingAddress: false, landline: false,
        mobile: false, smsCode: false, verifyQuestion: false, verifyAnswer: false
      },
      errors: {
        name: '', gender: '', idType: '', idNumber: '',
        province: '', detailAddress: '', birthdate: '', political: '',
        occupation: '', mobile: '', smsCode: '', verifyQuestion: '', verifyAnswer: ''
      },
      loading: false,
      errorMsg: '',
      successToast: '',
      smsCountdown: 0,
      smsTimer: null,
      lastSubmitTime: 0,
      occupationOptions: [
        '石油工人', '技术人员', '管理人员', '教师', '医生',
        '公务员', '企业职员', '农民', '个体经营', '学生',
        '退休人员', '其他'
      ],
      regions: [
        { name: '北京市', cities: [{ name: '北京市', districts: ['东城区', '西城区', '朝阳区', '海淀区', '丰台区', '石景山区', '通州区'] }] },
        { name: '天津市', cities: [{ name: '天津市', districts: ['和平区', '河东区', '河西区', '南开区', '河北区', '红桥区', '滨海新区'] }] },
        { name: '河北省', cities: [
          { name: '石家庄市', districts: ['长安区', '桥西区', '新华区', '裕华区'] },
          { name: '唐山市', districts: ['路北区', '路南区', '古冶区', '开平区'] }
        ]},
        { name: '山西省', cities: [
          { name: '太原市', districts: ['小店区', '迎泽区', '杏花岭区', '尖草坪区'] }
        ]},
        { name: '辽宁省', cities: [
          { name: '沈阳市', districts: ['和平区', '沈河区', '大东区', '皇姑区'] },
          { name: '大连市', districts: ['中山区', '西岗区', '沙河口区', '甘井子区'] }
        ]},
        { name: '黑龙江省', cities: [
          { name: '哈尔滨市', districts: ['道里区', '南岗区', '道外区', '松北区'] },
          { name: '大庆市', districts: ['萨尔图区', '龙凤区', '让胡路区', '红岗区'] }
        ]},
        { name: '山东省', cities: [
          { name: '济南市', districts: ['历下区', '市中区', '槐荫区', '天桥区'] },
          { name: '青岛市', districts: ['市南区', '市北区', '黄岛区', '崂山区'] },
          { name: '东营市', districts: ['东营区', '河口区', '垦利区'] }
        ]},
        { name: '新疆维吾尔自治区', cities: [
          { name: '乌鲁木齐市', districts: ['天山区', '沙依巴克区', '新市区', '水磨沟区'] },
          { name: '克拉玛依市', districts: ['独山子区', '克拉玛依区', '白碱滩区', '乌尔禾区'] }
        ]}
      ]
    }
  },
  computed: {
    availableCities() {
      const p = this.regions.find(r => r.name === this.form.province)
      return p ? p.cities : []
    },
    availableDistricts() {
      const p = this.regions.find(r => r.name === this.form.province)
      if (!p) return []
      const c = p.cities.find(c => c.name === this.form.city)
      return c ? c.districts : []
    },
    idNumberPlaceholder() {
      if (this.form.idType === 'idcard') return '请输入18位身份证号码'
      if (this.form.idType === 'passport') return '请输入护照号码'
      if (this.form.idType === 'officer') return '请输入军官证号码'
      return '请输入证件号码'
    },
    idNumberMaxLength() {
      if (this.form.idType === 'idcard') return 18
      return 30
    }
  },
  beforeUnmount() {
    if (this.smsTimer) clearInterval(this.smsTimer)
  },
  methods: {
    clearError(field) {
      this.errors[field] = ''
    },
    validate(field) {
      const v = this.form[field]
      if (field === 'name' && !v.trim()) {
        this.errors.name = '请输入真实姓名'
      } else if (field === 'gender' && !v) {
        this.errors.gender = '请选择性别'
      } else if (field === 'idType' && !v) {
        this.errors.idType = '请选择证件类型'
      } else if (field === 'idNumber') {
        if (!v.trim()) {
          this.errors.idNumber = '请输入证件号码'
        } else if (this.form.idType === 'idcard' && v.trim().length !== 18) {
          this.errors.idNumber = '身份证号码须为18位'
        }
      } else if (field === 'province' || field === 'city' || field === 'district') {
        if (!this.form.province || !this.form.city || !this.form.district) {
          this.errors.province = '请选择省市区'
        } else {
          this.errors.province = ''
        }
      } else if (field === 'detailAddress' && !v.trim()) {
        this.errors.detailAddress = '请输入详细住址'
      } else if (field === 'birthdate' && !v) {
        this.errors.birthdate = '请选择出生日期'
      } else if (field === 'political' && !v) {
        this.errors.political = '请选择政治面貌'
      } else if (field === 'occupation' && !v.trim()) {
        this.errors.occupation = '请输入职业'
      } else if (field === 'mobile') {
        if (!v.trim()) {
          this.errors.mobile = '请输入手机号码'
        } else if (!/^1\d{10}$/.test(v.trim())) {
          this.errors.mobile = '请输入正确的手机号码'
        }
      } else if (field === 'smsCode' && !v.trim()) {
        this.errors.smsCode = '请输入手机验证码'
      } else if (field === 'verifyQuestion' && !v) {
        this.errors.verifyQuestion = '请选择验证问题'
      } else if (field === 'verifyAnswer' && !v.trim()) {
        this.errors.verifyAnswer = '请输入验证答案'
      }
    },
    validateAll() {
      const requiredFields = ['name', 'gender', 'idType', 'idNumber', 'province', 'detailAddress',
        'birthdate', 'political', 'occupation', 'mobile', 'smsCode', 'verifyQuestion', 'verifyAnswer']
      let valid = true
      for (const f of requiredFields) {
        this.validate(f)
        if (this.errors[f]) valid = false
      }
      return valid
    },
    sendSmsCode() {
      if (this.smsCountdown > 0) return
      if (!this.form.mobile.trim()) {
        this.showError('请先输入手机号码')
        this.validate('mobile')
        return
      }
      if (!/^1\d{10}$/.test(this.form.mobile.trim())) {
        this.showError('请输入正确的手机号码')
        return
      }
      this.smsCountdown = 60
      this.smsTimer = setInterval(() => {
        this.smsCountdown--
        if (this.smsCountdown <= 0) {
          clearInterval(this.smsTimer)
          this.smsTimer = null
        }
      }, 1000)
      this.showError('')
      this.successToast = '验证码已发送'
      setTimeout(() => { this.successToast = '' }, 2000)
    },
    onProvinceChange() {
      this.form.city = ''
      this.form.district = ''
      this.errors.province = ''
    },
    onCityChange() {
      this.form.district = ''
      this.errors.province = ''
    },
    filterIdNumber() {
      if (this.form.idType === 'idcard') {
        this.form.idNumber = this.form.idNumber.replace(/\D/g, '')
      }
    },
    showError(msg) {
      this.errorMsg = msg
      if (msg) {
        setTimeout(() => { this.errorMsg = '' }, 3000)
      }
    },
    handleRegister() {
      if (!this.validateAll()) {
        this.showError('请完善必填信息')
        return
      }

      const now = Date.now()
      if (now - this.lastSubmitTime < 2000) return
      this.lastSubmitTime = now

      this.loading = true
      this.errorMsg = ''

      setTimeout(() => {
        this.loading = false
        this.successToast = '注册成功，即将跳转到登录页…'
        setTimeout(() => {
          this.successToast = ''
          this.$emit('go-login')
        }, 1500)
      }, 800)
    },
    handleReset() {
      Object.keys(this.form).forEach(k => { this.form[k] = '' })
      Object.keys(this.errors).forEach(k => { this.errors[k] = '' })
      this.errors.birthdate = ''
      this.errorMsg = ''
    }
  }
}
</script>

<style scoped>
/* =============================================
   Design — Register Page
   ============================================= */
.register-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  background: var(--canvas);
  font-family: var(--font-body);
  padding: 40px 20px;
  animation: fadeIn 0.4s ease;
}

.register-card {
  background: #ffffff;
  width: 580px;
  max-width: 100%;
  border-radius: var(--radius-xl);
  padding: 36px 40px;
  box-shadow: var(--shadow-lg);
  border: 1px solid var(--hairline);
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

.error-icon { flex-shrink: 0; }

/* ==================== Brand ==================== */
.brand { text-align: center; }

.brand-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 56px;
  height: 56px;
  background: var(--surface-soft);
  border-radius: var(--radius-lg);
  margin-bottom: 12px;
  transition: transform var(--transition-base);
}

.brand-icon:hover { transform: scale(1.05); }

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
  margin: 20px 0 24px;
}

/* ==================== Required Star ==================== */
.required { color: var(--error); }

/* ==================== Section ==================== */
.form-section {
  margin-bottom: 24px;
}

.section-title {
  font-family: var(--font-display);
  font-size: 16px;
  font-weight: 600;
  color: var(--ink);
  margin-bottom: 16px;
  padding-bottom: 8px;
  border-bottom: 1px solid var(--hairline-soft);
  letter-spacing: -0.2px;
}

/* ==================== Form Layout ==================== */
.form-row {
  display: flex;
  gap: 16px;
  margin-bottom: 16px;
}

.form-row:last-child { margin-bottom: 0; }

.form-group {
  flex: 1;
  min-width: 0;
  margin-bottom: 0;
}

.form-group-half { flex: 1; min-width: 0; }
.form-group-third { flex: 1; min-width: 0; }

.form-label {
  font-size: 13px;
  font-weight: 500;
  color: var(--body);
  display: block;
  margin-bottom: 5px;
  letter-spacing: 0.2px;
}

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
  height: 42px;
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

.input-wrapper:focus-within {
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(204, 120, 92, 0.15);
}

.input-wrapper.input-error {
  border-color: var(--error);
}

.input-wrapper.input-error:focus-within {
  box-shadow: 0 0 0 3px rgba(198, 69, 69, 0.15);
}

.form-input {
  width: 100%;
  height: 100%;
  border: none;
  background: transparent;
  padding: 0 14px;
  font-size: 14px;
  color: var(--ink);
  outline: none;
  border-radius: var(--radius-md);
  font-family: var(--font-body);
}

.form-input::placeholder {
  color: var(--muted-soft);
}

.form-select {
  cursor: pointer;
  appearance: none;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 20 20' width='20' height='20' fill='%238e8b82' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M5.5 7.5l4.5 5 4.5-5H5.5z'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 10px center;
  padding-right: 32px;
}

.form-select option { color: var(--ink); }

/* SMS Input */
.sms-input {
  padding-right: 110px;
}

.sms-btn {
  position: absolute;
  right: 4px;
  height: 32px;
  padding: 0 12px;
  border: none;
  border-radius: var(--radius-sm);
  background: var(--primary);
  color: var(--on-primary);
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  white-space: nowrap;
  font-family: var(--font-body);
  transition:
    background var(--transition-fast),
    opacity var(--transition-fast);
}

.sms-btn:hover {
  background: var(--primary-active);
}

.sms-btn:disabled {
  background: var(--primary-disabled);
  color: var(--muted);
  cursor: not-allowed;
}

/* ==================== Field Hints ==================== */
.field-hint {
  margin: 5px 0 0;
  font-size: 12px;
  line-height: 1;
  min-height: 14px;
  animation: fadeIn 0.2s ease;
}

.field-hint.error { color: var(--error); }

/* ==================== Buttons ==================== */
.btn-row {
  display: flex;
  gap: 12px;
  margin-top: 24px;
}

.register-btn {
  flex: 1;
  height: 44px;
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

.register-btn:hover {
  background: var(--primary-active);
  box-shadow: 0 4px 14px rgba(204, 120, 92, 0.35);
}

.register-btn:active {
  transform: scale(0.97);
  box-shadow: 0 2px 6px rgba(204, 120, 92, 0.2);
}

.register-btn:disabled {
  opacity: 0.75;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.reset-btn {
  width: 80px;
  height: 44px;
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

.reset-btn:hover {
  background: var(--canvas);
  border-color: #d5cdc4;
  color: var(--body);
}

.reset-btn:active {
  transform: scale(0.98);
}

/* Loading */
.btn-text { line-height: 1; }
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

@keyframes spin { to { transform: rotate(360deg); } }

/* ==================== Switch Link ==================== */
.switch-hint {
  text-align: center;
  font-size: 13px;
  color: var(--muted);
  margin-top: 20px;
}

.switch-link {
  color: var(--primary);
  text-decoration: none;
  font-weight: 500;
  transition: color var(--transition-fast);
}

.switch-link:hover {
  color: var(--primary-active);
  text-decoration: underline;
}

/* ==================== Footer ==================== */
.footer-text {
  margin-top: 24px;
  text-align: center;
  font-size: 12px;
  color: var(--muted-soft);
}

/* ==================== Toast ==================== */
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
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
@keyframes slideUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }
@keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
@keyframes shake { 0%,100% { transform: translateX(0); } 20% { transform: translateX(-6px); } 40% { transform: translateX(6px); } 60% { transform: translateX(-4px); } 80% { transform: translateX(4px); } }
@keyframes toastIn { from { opacity: 0; transform: translateX(-50%) translateY(-16px); } to { opacity: 1; transform: translateX(-50%) translateY(0); } }

/* Transition Classes */
.slide-down-enter-active { animation: slideDown 0.3s ease-out; }
.slide-down-leave-active { animation: slideDown 0.3s ease-in reverse; }
.fade-enter-active { animation: fadeIn 0.25s ease-out; }
.fade-leave-active { animation: fadeIn 0.25s ease-in reverse; }
.toast-slide-enter-active { animation: toastIn 0.3s ease-out; }
.toast-slide-leave-active { animation: toastIn 0.3s ease-in reverse; }

/* ==================== Responsive ==================== */
@media (max-width: 620px) {
  .register-card {
    width: 100%;
    padding: 24px 20px;
  }

  .form-row {
    flex-direction: column;
    gap: 0;
    margin-bottom: 0;
  }

  .form-row .form-group {
    margin-bottom: 14px;
  }

  .brand-title { font-size: 20px; }

  .input-wrapper { height: 40px; }

  .register-btn { height: 42px; }
  .reset-btn { height: 42px; }

  .footer-text { margin-top: 16px; }
}
</style>

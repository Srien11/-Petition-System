-- ============================================================================
-- 新疆油田信访管理系统 (OPMS) 数据库建库建表脚本
-- 数据库名: op_oil_petition
-- 数据库版本: MySQL 8.0
-- 字符集: utf8mb4  排序规则: utf8mb4_unicode_ci  存储引擎: InnoDB
-- 编制依据: 《新疆油田信访管理系统软件需求说明书》
-- 编制日期: 2026-06
-- ============================================================================

-- ============================================================================
-- 第一部分：建库
-- ============================================================================
CREATE DATABASE IF NOT EXISTS op_oil_petition
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE op_oil_petition;

-- ============================================================================
-- 第二部分：系统基础表组（XT子系统）
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. 三级组织架构表
-- ----------------------------------------------------------------------------
CREATE TABLE sys_organization (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '组织ID',
    org_code        VARCHAR(32)     NOT NULL COMMENT '组织编码（唯一）',
    org_name        VARCHAR(100)    NOT NULL COMMENT '组织名称',
    org_level       TINYINT         NOT NULL COMMENT '组织层级：1油田公司总部 2二级单位 3基层站队/作业区',
    parent_id       BIGINT          DEFAULT NULL COMMENT '上级组织ID（根节点为NULL）',
    org_path        VARCHAR(500)    DEFAULT NULL COMMENT '组织路径（如 /1/3/15，便于递归查询）',
    manager_name    VARCHAR(50)     DEFAULT NULL COMMENT '负责人姓名',
    contact_phone   VARCHAR(20)     DEFAULT NULL COMMENT '联系电话',
    sort_order      INT             DEFAULT 0 COMMENT '排序号',
    status          TINYINT         DEFAULT 1 COMMENT '状态：0停用 1启用',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_org_code (org_code),
    KEY idx_parent_id (parent_id),
    KEY idx_org_level (org_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='三级组织架构表';

INSERT INTO sys_organization (org_code, org_name, org_level, parent_id, org_path, manager_name, contact_phone, sort_order) VALUES
('XJYT', '新疆油田有限责任公司', 1, NULL, '/1', '张建国', '0990-6888888', 1);
INSERT INTO sys_organization (org_code, org_name, org_level, parent_id, org_path, manager_name, contact_phone, sort_order) VALUES
('XJYT-CYC01', '采油一厂', 2, 1, '/1/2', '李明辉', '0990-6222222', 1);

-- ----------------------------------------------------------------------------
-- 2. 系统用户表
-- ----------------------------------------------------------------------------
CREATE TABLE sys_user (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    username        VARCHAR(50)     NOT NULL COMMENT '登录账号（对接统一认证系统）',
    password        VARCHAR(255)    DEFAULT NULL COMMENT '密码（统一认证接管后可为NULL，仅本地测试账号使用）',
    real_name       VARCHAR(50)     NOT NULL COMMENT '真实姓名',
    employee_no     VARCHAR(32)     DEFAULT NULL COMMENT '员工编号（对接HR系统）',
    id_card         VARCHAR(100)    DEFAULT NULL COMMENT '身份证号【AES-256加密存储，前端页面脱敏展示】',
    phone           VARCHAR(100)    DEFAULT NULL COMMENT '手机号【AES-256加密存储，前端页面脱敏展示】',
    email           VARCHAR(100)    DEFAULT NULL COMMENT '邮箱',
    org_id          BIGINT          DEFAULT NULL COMMENT '所属组织ID',
    org_name        VARCHAR(100)    DEFAULT NULL COMMENT '所属组织名称（冗余字段，提升查询效率）',
    position        VARCHAR(50)     DEFAULT NULL COMMENT '岗位/职务',
    user_type       TINYINT         NOT NULL DEFAULT 1 COMMENT '用户类型：1内部员工 2离退休人员 3外部关联人员',
    status          TINYINT         DEFAULT 1 COMMENT '账号状态：0停用 1启用 2锁定',
    last_login_time DATETIME       DEFAULT NULL COMMENT '最近登录时间',
    last_login_ip   VARCHAR(50)     DEFAULT NULL COMMENT '最近登录IP',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username),
    UNIQUE KEY uk_employee_no (employee_no),
    KEY idx_org_id (org_id),
    KEY idx_real_name (real_name),
    KEY idx_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统用户表';

INSERT INTO sys_user (username, password, real_name, employee_no, org_id, org_name, position, user_type) VALUES
('admin', '$2a$10$dummyBcryptHashForDemoAdmin', '系统管理员', 'EMP00001', 1, '新疆油田有限责任公司', '系统管理员', 1);
INSERT INTO sys_user (username, password, real_name, employee_no, org_id, org_name, position, user_type) VALUES
('zhangsan', '$2a$10$dummyBcryptHashForDemoUser', '张三', 'EMP00002', 2, '采油一厂', '信访岗', 1);

-- ----------------------------------------------------------------------------
-- 3. 系统角色表
-- ----------------------------------------------------------------------------
CREATE TABLE sys_role (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '角色ID',
    role_code       VARCHAR(50)     NOT NULL COMMENT '角色编码（唯一）',
    role_name       VARCHAR(100)    NOT NULL COMMENT '角色名称',
    role_type       TINYINT         NOT NULL COMMENT '角色类型：1信访管理员 2业务办理人 3专项工作人员 4系统管理员 5信访群众',
    description     VARCHAR(500)    DEFAULT NULL COMMENT '角色描述',
    data_scope      TINYINT         DEFAULT 1 COMMENT '数据权限范围：1仅本人 2本部门 3本部门及下级 4全公司',
    status          TINYINT         DEFAULT 1 COMMENT '状态：0停用 1启用',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_role_code (role_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统角色表';

INSERT INTO sys_role (role_code, role_name, role_type, description, data_scope) VALUES
('ROLE_ADMIN', '信访管理员', 1, '拥有全量功能权限，负责统筹调度和规则确认', 4);
INSERT INTO sys_role (role_code, role_name, role_type, description, data_scope) VALUES
('ROLE_HANDLER', '业务办理人', 2, '负责信访件的签收、办理、反馈和审核', 2);

-- ----------------------------------------------------------------------------
-- 4. 用户角色关联表
-- ----------------------------------------------------------------------------
CREATE TABLE sys_user_role (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '关联ID',
    user_id         BIGINT          NOT NULL COMMENT '用户ID',
    role_id         BIGINT          NOT NULL COMMENT '角色ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_role (user_id, role_id),
    KEY idx_user_id (user_id),
    KEY idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

INSERT INTO sys_user_role (user_id, role_id) VALUES (1, 1);
INSERT INTO sys_user_role (user_id, role_id) VALUES (2, 2);

-- ----------------------------------------------------------------------------
-- 5. 系统字典表
-- ----------------------------------------------------------------------------
CREATE TABLE sys_dict_type (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '字典类型ID',
    dict_code       VARCHAR(50)     NOT NULL COMMENT '字典类型编码',
    dict_name       VARCHAR(100)    NOT NULL COMMENT '字典类型名称',
    status          TINYINT         DEFAULT 1 COMMENT '状态：0停用 1启用',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_dict_code (dict_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统字典类型表';

INSERT INTO sys_dict_type (dict_code, dict_name) VALUES ('CHANNEL_TYPE', '信访渠道类型');
INSERT INTO sys_dict_type (dict_code, dict_name) VALUES ('PETITION_STATUS', '信访办理状态');

CREATE TABLE sys_dict_item (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '字典项ID',
    dict_code       VARCHAR(50)     NOT NULL COMMENT '字典类型编码（关联sys_dict_type.dict_code）',
    item_code       VARCHAR(50)     NOT NULL COMMENT '字典项编码',
    item_name       VARCHAR(100)    NOT NULL COMMENT '字典项名称',
    item_value      VARCHAR(500)    DEFAULT NULL COMMENT '字典项值（扩展）',
    sort_order      INT             DEFAULT 0 COMMENT '排序号',
    status          TINYINT         DEFAULT 1 COMMENT '状态：0停用 1启用',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_dict_code (dict_code),
    UNIQUE KEY uk_dict_item (dict_code, item_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统字典项表';

INSERT INTO sys_dict_item (dict_code, item_code, item_name, sort_order) VALUES
('CHANNEL_TYPE', 'LF', '来访', 1),
('CHANNEL_TYPE', 'LX', '来信', 2),
('CHANNEL_TYPE', 'LD', '来电', 3),
('CHANNEL_TYPE', 'WS', '网上信访', 4),
('CHANNEL_TYPE', 'SZ', '上级转送', 5),
('CHANNEL_TYPE', 'LP', '领导批示', 6);
INSERT INTO sys_dict_item (dict_code, item_code, item_name, sort_order) VALUES
('PETITION_STATUS', 'DRAFT', '草稿', 1),
('PETITION_STATUS', 'PENDING_DUPLICATE', '待判重', 2);

-- ----------------------------------------------------------------------------
-- 6. 系统配置表
-- ----------------------------------------------------------------------------
CREATE TABLE sys_config (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '配置ID',
    config_key      VARCHAR(100)    NOT NULL COMMENT '配置键（唯一）',
    config_value    TEXT            NOT NULL COMMENT '配置值',
    config_desc     VARCHAR(500)    DEFAULT NULL COMMENT '配置说明',
    config_group    VARCHAR(50)     DEFAULT NULL COMMENT '配置分组：PETITION时限 DISPATCH流转 WARNING预警 SYSTEM系统',
    status          TINYINT         DEFAULT 1 COMMENT '状态：0停用 1启用',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

INSERT INTO sys_config (config_key, config_value, config_desc, config_group) VALUES
('petition.default_deadline_days', '30', '交办/转办默认办理时限（天）', 'PETITION');
INSERT INTO sys_config (config_key, config_value, config_desc, config_group) VALUES
('petition.reply_deadline_days', '5', '直接答复时限（工作日）', 'PETITION');

-- ----------------------------------------------------------------------------
-- 7. 登录日志表（基础表结构，分区DDL见末尾）
-- ----------------------------------------------------------------------------
CREATE TABLE sys_login_log (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    user_id         BIGINT          DEFAULT NULL COMMENT '用户ID',
    username        VARCHAR(50)     NOT NULL COMMENT '登录账号',
    login_time      DATETIME        NOT NULL COMMENT '登录时间',
    login_ip        VARCHAR(50)     DEFAULT NULL COMMENT '登录IP地址',
    login_device    VARCHAR(200)    DEFAULT NULL COMMENT '登录设备信息（User-Agent）',
    login_type      TINYINT         NOT NULL DEFAULT 1 COMMENT '登录方式：1账号密码 2统一认证SSO 3手机验证码',
    login_result    TINYINT         NOT NULL COMMENT '登录结果：0失败 1成功',
    fail_reason     VARCHAR(200)    DEFAULT NULL COMMENT '失败原因',
    logout_time     DATETIME        DEFAULT NULL COMMENT '登出时间',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id, login_time),
    KEY idx_user_id (user_id),
    KEY idx_login_time (login_time),
    KEY idx_login_result (login_result)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='登录日志表（按月分区）'
PARTITION BY RANGE (TO_DAYS(login_time)) (
    PARTITION p202606 VALUES LESS THAN (TO_DAYS('2026-07-01')),
    PARTITION p202607 VALUES LESS THAN (TO_DAYS('2026-08-01')),
    PARTITION p202608 VALUES LESS THAN (TO_DAYS('2026-09-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

INSERT INTO sys_login_log (user_id, username, login_time, login_ip, login_type, login_result) VALUES
(1, 'admin', '2026-06-01 09:00:00', '192.168.1.100', 2, 1);
INSERT INTO sys_login_log (user_id, username, login_time, login_ip, login_type, login_result) VALUES
(2, 'zhangsan', '2026-06-01 09:30:00', '192.168.2.50', 1, 1);

-- ----------------------------------------------------------------------------
-- 8. 全量操作日志表（基础表结构，分区DDL见末尾）
-- ----------------------------------------------------------------------------
CREATE TABLE sys_operation_log (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    user_id         BIGINT          DEFAULT NULL COMMENT '操作人ID',
    username        VARCHAR(50)     NOT NULL COMMENT '操作人账号',
    real_name       VARCHAR(50)     DEFAULT NULL COMMENT '操作人姓名',
    org_id          BIGINT          DEFAULT NULL COMMENT '操作人所属组织ID',
    operation_time  DATETIME        NOT NULL COMMENT '操作时间',
    operation_ip    VARCHAR(50)     DEFAULT NULL COMMENT '操作IP地址',
    operation_module VARCHAR(100)   NOT NULL COMMENT '操作模块（如PT-02多渠道登记）',
    operation_type  VARCHAR(50)     NOT NULL COMMENT '操作类型：INSERT UPDATE DELETE SELECT EXPORT APPROVE',
    operation_object VARCHAR(200)   DEFAULT NULL COMMENT '操作对象（如表名或业务编号）',
    operation_summary VARCHAR(1000) DEFAULT NULL COMMENT '操作摘要',
    request_params  TEXT            DEFAULT NULL COMMENT '请求参数（JSON，敏感字段已脱敏）',
    operation_result TINYINT        NOT NULL DEFAULT 1 COMMENT '操作结果：0失败 1成功',
    error_message   TEXT            DEFAULT NULL COMMENT '异常信息',
    cost_time       INT             DEFAULT NULL COMMENT '耗时（毫秒）',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id, operation_time),
    KEY idx_user_id (user_id),
    KEY idx_operation_time (operation_time),
    KEY idx_operation_module (operation_module),
    KEY idx_operation_type (operation_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='全量操作日志表（按月分区）'
PARTITION BY RANGE (TO_DAYS(operation_time)) (
    PARTITION p202606 VALUES LESS THAN (TO_DAYS('2026-07-01')),
    PARTITION p202607 VALUES LESS THAN (TO_DAYS('2026-08-01')),
    PARTITION p202608 VALUES LESS THAN (TO_DAYS('2026-09-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

INSERT INTO sys_operation_log (user_id, username, real_name, operation_time, operation_module, operation_type, operation_object, operation_summary) VALUES
(1, 'admin', '系统管理员', '2026-06-01 10:00:00', 'XT-01', 'INSERT', 'sys_user', '新增用户张三');
INSERT INTO sys_operation_log (user_id, username, real_name, operation_time, operation_module, operation_type, operation_object, operation_summary) VALUES
(1, 'admin', '系统管理员', '2026-06-01 10:05:00', 'XT-05', 'UPDATE', 'sys_dict_item', '修改字典项：来访渠道');

-- ----------------------------------------------------------------------------
-- 9. 接口调用日志表
-- ----------------------------------------------------------------------------
CREATE TABLE sys_api_call_log (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    caller_system   VARCHAR(100)    NOT NULL COMMENT '调用方系统名称',
    api_name        VARCHAR(200)    NOT NULL COMMENT '接口名称/URL路径',
    api_method      VARCHAR(10)     NOT NULL COMMENT '请求方法：GET POST PUT DELETE',
    call_time       DATETIME        NOT NULL COMMENT '调用时间',
    request_params  TEXT            DEFAULT NULL COMMENT '请求参数（脱敏后）',
    response_code   VARCHAR(10)     DEFAULT NULL COMMENT '响应HTTP状态码',
    response_body   TEXT            DEFAULT NULL COMMENT '响应体摘要（截断至前500字符）',
    cost_time       INT             DEFAULT NULL COMMENT '接口耗时（毫秒）',
    call_result     TINYINT         NOT NULL DEFAULT 1 COMMENT '调用结果：0失败 1成功',
    error_message   TEXT            DEFAULT NULL COMMENT '异常信息',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id),
    KEY idx_call_time (call_time),
    KEY idx_caller_system (caller_system),
    KEY idx_api_name (api_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='接口调用日志表';

INSERT INTO sys_api_call_log (caller_system, api_name, api_method, call_time, response_code, call_result) VALUES
('OPMS-WEB', '/api/v1/petition/search', 'GET', '2026-06-01 10:30:00', '200', 1);
INSERT INTO sys_api_call_log (caller_system, api_name, api_method, call_time, response_code, call_result) VALUES
('ZHANGXINYOU', '/api/v1/push/message', 'POST', '2026-06-01 11:00:00', '200', 1);


-- ============================================================================
-- 第三部分：信访办理核心表组（PT子系统）
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 10. 信访事项主表
-- ----------------------------------------------------------------------------
CREATE TABLE petition (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    petition_code   VARCHAR(30)     NOT NULL COMMENT '信访编号（规则：XF+YYYYMM+4位流水+2位渠道编码，如XF2026050001LF）',
    -- 信访人信息
    petitioner_name VARCHAR(50)     NOT NULL COMMENT '信访人姓名',
    petitioner_id_card VARCHAR(100) DEFAULT NULL COMMENT '信访人身份证号【AES-256加密存储，前端页面脱敏展示】',
    petitioner_phone VARCHAR(100)   DEFAULT NULL COMMENT '信访人联系电话【AES-256加密存储，前端页面脱敏展示】',
    petitioner_address VARCHAR(200) DEFAULT NULL COMMENT '信访人住址【AES-256加密存储，前端页面脱敏展示】',
    petitioner_employee_no VARCHAR(32) DEFAULT NULL COMMENT '信访人员工编号（关联HR系统）',
    -- 渠道信息
    channel_code    VARCHAR(10)     NOT NULL COMMENT '渠道编码：LF来访 LX来信 LD来电 WS网上信访 SZ上级转送 LP领导批示',
    -- 来访渠道专有字段
    visitor_count   INT             DEFAULT 1 COMMENT '来访人数',
    is_collective   TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否集体访：0否 1是（来访人数>5自动标记）',
    receptionist    VARCHAR(50)     DEFAULT NULL COMMENT '接访人姓名',
    visit_date      DATETIME        DEFAULT NULL COMMENT '来访日期',
    -- 来信渠道专有字段
    letter_receive_date DATETIME    DEFAULT NULL COMMENT '来信收到日期',
    letter_post_code VARCHAR(20)    DEFAULT NULL COMMENT '来信邮编',
    -- 来电渠道专有字段
    call_date       DATETIME        DEFAULT NULL COMMENT '来电日期',
    caller_number   VARCHAR(100)    DEFAULT NULL COMMENT '来电号码',
    -- 上级转送专有字段
    superior_org    VARCHAR(200)    DEFAULT NULL COMMENT '上级转送单位名称',
    superior_doc_no VARCHAR(100)    DEFAULT NULL COMMENT '上级转送文号',
    superior_date   DATETIME        DEFAULT NULL COMMENT '上级转送日期',
    -- 领导批示专有字段
    leader_name     VARCHAR(50)     DEFAULT NULL COMMENT '批示领导姓名',
    leader_opinion  TEXT            DEFAULT NULL COMMENT '领导批示意见',
    leader_date     DATETIME        DEFAULT NULL COMMENT '领导批示日期',
    -- 诉求信息
    appeal_category_level1 VARCHAR(50)  DEFAULT NULL COMMENT '诉求类别一级分类',
    appeal_category_level2 VARCHAR(50)  DEFAULT NULL COMMENT '诉求类别二级分类',
    appeal_category_level3 VARCHAR(50)  DEFAULT NULL COMMENT '诉求类别三级分类',
    involved_org_ids VARCHAR(500)   DEFAULT NULL COMMENT '涉及单位ID列表（JSON数组，多选）',
    appeal_content  TEXT            NOT NULL COMMENT '诉求内容（富文本）',
    keyword_tags    VARCHAR(500)    DEFAULT NULL COMMENT '关键字标签（逗号分隔）',
    -- 附件数量（附件文件存NAS，元数据在attachment表）
    attachment_count INT            DEFAULT 0 COMMENT '附件数量',
    -- 判重信息
    is_duplicate    TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否重复件：0否（新件） 1是',
    duplicate_petition_id BIGINT    DEFAULT NULL COMMENT '关联的原始信访件ID（判重确认后关联）',
    -- 判重相似度存储字段（三级判重规则）
    dup_similarity_name      DECIMAL(5,2) DEFAULT NULL COMMENT '姓名匹配相似度（精确匹配=100）',
    dup_similarity_id_card   DECIMAL(5,2) DEFAULT NULL COMMENT '身份证匹配相似度',
    dup_similarity_phone     DECIMAL(5,2) DEFAULT NULL COMMENT '手机号匹配相似度',
    dup_similarity_keyword   DECIMAL(5,2) DEFAULT NULL COMMENT '关键字匹配相似度（0-100）',
    dup_check_detail  TEXT            DEFAULT NULL COMMENT '判重详细结果（JSON：匹配到的历史件列表及各项得分）',
    -- 分类处置信息
    disposal_type   VARCHAR(20)     DEFAULT NULL COMMENT '处置方式：REPLY_DIRECT直接答复 TRANSFER转办 ASSIGN交办 REPORT呈报 ARCHIVE存查',
    disposal_opinion TEXT           DEFAULT NULL COMMENT '拟办意见（含分流理由/办理要求/注意事项）',
    disposal_time   DATETIME        DEFAULT NULL COMMENT '分类处置时间',
    disposal_by     BIGINT          DEFAULT NULL COMMENT '分类处置人ID',
    -- 流转状态
    status          VARCHAR(30)     NOT NULL DEFAULT 'DRAFT' COMMENT '当前状态：DRAFT草稿 PENDING_DUPLICATE待判重 PENDING_DISPOSAL待处置 IN_PROGRESS办理中 PENDING_INTERNAL_REVIEW待内部审核 PENDING_FINAL_REVIEW待信访科审核 COMPLETED已办结 ARCHIVED已归档',
    status_history  TEXT            DEFAULT NULL COMMENT '状态变更历史（JSON数组：[{from,to,time,operator}]）',
    -- 时限信息
    deadline_date   DATETIME        DEFAULT NULL COMMENT '办理截止日期',
    is_overtime     TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否超期：0正常 1临期（≤7天） 2已超期',
    -- 归档信息
    archive_date    DATETIME        DEFAULT NULL COMMENT '归档日期',
    archive_retention VARCHAR(20)   DEFAULT NULL COMMENT '保管期限：1年 3年 5年 10年 PERMANENT永久',
    archive_remind_date DATETIME    DEFAULT NULL COMMENT '保管到期提醒日期（到期前3个月）',
    -- 办结信息
    complete_date   DATETIME        DEFAULT NULL COMMENT '办结日期',
    -- 来源标记
    source_flag     VARCHAR(20)     DEFAULT 'MANUAL' COMMENT '来源标记：MANUAL人工登记 ONLINE网上信访 IMPORT历史迁移',
    -- 登记信息
    register_by     BIGINT          DEFAULT NULL COMMENT '登记人ID',
    register_time   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '登记时间',
    register_org_id BIGINT          DEFAULT NULL COMMENT '登记人所属组织ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_petition_code (petition_code),
    KEY idx_petitioner_name (petitioner_name),
    KEY idx_petitioner_phone (petitioner_phone),
    KEY idx_channel_code (channel_code),
    KEY idx_status (status),
    KEY idx_register_time (register_time),
    KEY idx_deadline_date (deadline_date),
    KEY idx_is_overtime (is_overtime),
    KEY idx_register_org_id (register_org_id),
    KEY idx_is_collective (is_collective)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信访事项主表';

INSERT INTO petition (petition_code, petitioner_name, channel_code, visitor_count, is_collective, receptionist, visit_date,
    appeal_category_level1, appeal_category_level2, appeal_content, keyword_tags,
    status, register_by, register_org_id)
VALUES ('XF2026060001LF', '王建国', 'LF', 1, 0, '张三', '2026-06-01 09:30:00',
    '劳动用工', '薪酬待遇', '反映2026年5月工资核算有误，请求重新核算并补发差额。', '工资,核算,补发',
    'IN_PROGRESS', 2, 2);
INSERT INTO petition (petition_code, petitioner_name, channel_code, visitor_count, is_collective,
    appeal_category_level1, appeal_category_level2, appeal_content,
    status, register_by, register_org_id)
VALUES ('XF2026060002WS', '李秀英', 'WS', 1, 0,
    '社会保障', '养老保险', '本人将于2026年8月退休，咨询养老金核算标准和具体金额计算方式。',
    'PENDING_DISPOSAL', 1, 1);

-- ----------------------------------------------------------------------------
-- 11. 判重关联表（重复信访关联表）
-- ----------------------------------------------------------------------------
CREATE TABLE petition_duplicate_relation (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    petition_id     BIGINT          NOT NULL COMMENT '当前信访件ID',
    original_petition_id BIGINT     NOT NULL COMMENT '原始信访件ID（历史重复件）',
    match_rule      VARCHAR(50)     NOT NULL COMMENT '匹配规则：EXACT_NAME_ID精确匹配(姓名+身份证) FUZZY_NAME_PHONE模糊匹配(姓名+电话) KEYWORD关键字匹配',
    match_score     DECIMAL(5,2)    NOT NULL COMMENT '匹配度得分（0-100）',
    confirm_by      BIGINT          DEFAULT NULL COMMENT '确认人ID',
    confirm_time    DATETIME        DEFAULT NULL COMMENT '确认时间',
    confirm_status  VARCHAR(20)     DEFAULT 'PENDING' COMMENT '确认状态：PENDING待确认 CONFIRMED确认重复 REJECTED确认新件',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_petition_id (petition_id),
    KEY idx_original_petition_id (original_petition_id),
    KEY idx_match_rule (match_rule)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='重复信访关联表';

INSERT INTO petition_duplicate_relation (petition_id, original_petition_id, match_rule, match_score, confirm_status) VALUES
(2, 1, 'KEYWORD', 45.50, 'PENDING');
INSERT INTO petition_duplicate_relation (petition_id, original_petition_id, match_rule, match_score, confirm_by, confirm_time, confirm_status) VALUES
(1, 1, 'EXACT_NAME_ID', 0.00, 1, '2026-06-01 10:00:00', 'CONFIRMED');

-- ----------------------------------------------------------------------------
-- 12. 交办/转办/呈报单表
-- ----------------------------------------------------------------------------
CREATE TABLE petition_dispatch (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    petition_id     BIGINT          NOT NULL COMMENT '关联信访件ID',
    dispatch_type   VARCHAR(20)     NOT NULL COMMENT '派单类型：ASSIGN交办 TRANSFER转办 REPORT呈报',
    -- 交办/转办信息
    from_org_id     BIGINT          NOT NULL COMMENT '发起单位ID（信访办公室）',
    from_user_id    BIGINT          NOT NULL COMMENT '发起人ID',
    to_org_id       BIGINT          NOT NULL COMMENT '主办单位ID',
    to_org_name     VARCHAR(100)    NOT NULL COMMENT '主办单位名称（冗余）',
    dispatch_opinion TEXT           NOT NULL COMMENT '交办/转办/呈报意见',
    -- 呈报特有字段
    report_leader_name VARCHAR(50)  DEFAULT NULL COMMENT '呈报领导姓名',
    report_leader_opinion TEXT      DEFAULT NULL COMMENT '领导批示意见',
    report_leader_date DATETIME     DEFAULT NULL COMMENT '领导批示日期',
    -- 时限字段
    deadline_days   INT             NOT NULL DEFAULT 30 COMMENT '办理时限（天）',
    deadline_date   DATETIME        NOT NULL COMMENT '办理截止日期',
    -- 签收信息
    is_received     TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否已签收：0未签收 1已签收',
    received_by     BIGINT          DEFAULT NULL COMMENT '签收人ID',
    received_time   DATETIME        DEFAULT NULL COMMENT '签收时间',
    -- 退回信息
    is_returned     TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否被退回：0否 1退回申请中 2退回已审批',
    return_reason   VARCHAR(500)    DEFAULT NULL COMMENT '退回原因',
    return_apply_time DATETIME      DEFAULT NULL COMMENT '退回申请时间',
    return_approve_by BIGINT        DEFAULT NULL COMMENT '退回审批人ID',
    return_approve_time DATETIME    DEFAULT NULL COMMENT '退回审批时间',
    return_approve_opinion VARCHAR(500) DEFAULT NULL COMMENT '退回审批意见',
    -- 延期信息
    is_extended     TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否延期：0否 1延期申请中 2延期已批准 3延期已驳回',
    extension_apply_reason VARCHAR(500) DEFAULT NULL COMMENT '延期申请原因',
    extension_days  INT             DEFAULT NULL COMMENT '申请延期天数',
    extension_apply_time DATETIME   DEFAULT NULL COMMENT '延期申请时间',
    extension_approve_by BIGINT     DEFAULT NULL COMMENT '延期审批人ID',
    extension_approve_time DATETIME DEFAULT NULL COMMENT '延期审批时间',
    extension_approve_opinion VARCHAR(500) DEFAULT NULL COMMENT '延期审批意见',
    new_deadline_date DATETIME      DEFAULT NULL COMMENT '延期后新的截止日期',
    -- 协办单位列表（冗余子表汇总）
    assist_org_names VARCHAR(500)   DEFAULT NULL COMMENT '协办单位名称列表（逗号分隔，冗余方便展示）',
    -- 状态
    status          VARCHAR(30)     NOT NULL DEFAULT 'PENDING_RECEIVE' COMMENT '状态：PENDING_RECEIVE待签收 RECEIVED已签收 IN_PROGRESS办理中 RETURNED已退回 COMPLETED已完成',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_petition_id (petition_id),
    KEY idx_to_org_id (to_org_id),
    KEY idx_dispatch_type (dispatch_type),
    KEY idx_status (status),
    KEY idx_deadline_date (deadline_date),
    KEY idx_is_received (is_received)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='交办/转办/呈报单表';

INSERT INTO petition_dispatch (petition_id, dispatch_type, from_org_id, from_user_id, to_org_id, to_org_name,
    dispatch_opinion, deadline_days, deadline_date, status)
VALUES (1, 'ASSIGN', 1, 1, 2, '采油一厂',
    '请采油一厂核实王建国反映的工资核算问题，在30日内调查处理并反馈结果。', 30, '2026-07-01 00:00:00', 'RECEIVED');
INSERT INTO petition_dispatch (petition_id, dispatch_type, from_org_id, from_user_id, to_org_id, to_org_name,
    dispatch_opinion, deadline_days, deadline_date, status)
VALUES (2, 'TRANSFER', 1, 1, 2, '人力资源部',
    '请人力资源部就李秀英咨询的养老金核算标准问题给予专业答复，5个工作日内直接答复信访人。', 5, '2026-06-08 00:00:00', 'PENDING_RECEIVE');

-- ----------------------------------------------------------------------------
-- 13. 协办记录表
-- ----------------------------------------------------------------------------
CREATE TABLE petition_assist_record (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    dispatch_id     BIGINT          NOT NULL COMMENT '关联转办单ID（仅TRANSFER转办类型可有协办）',
    petition_id     BIGINT          NOT NULL COMMENT '关联信访件ID',
    assist_org_id   BIGINT          NOT NULL COMMENT '协办单位ID',
    assist_org_name VARCHAR(100)    NOT NULL COMMENT '协办单位名称',
    assist_requirement TEXT         NOT NULL COMMENT '协办要求',
    deadline_days   INT             NOT NULL DEFAULT 7 COMMENT '协办时限（天）',
    deadline_date   DATETIME        NOT NULL COMMENT '协办截止日期',
    reply_content   TEXT            DEFAULT NULL COMMENT '协办回复内容',
    reply_time      DATETIME        DEFAULT NULL COMMENT '协办回复时间',
    reply_by        BIGINT          DEFAULT NULL COMMENT '协办回复人ID',
    is_overtime     TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否超期：0正常 1已超期',
    status          VARCHAR(30)     NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING待回复 REPLIED已回复 OVERDUE已超期',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_dispatch_id (dispatch_id),
    KEY idx_petition_id (petition_id),
    KEY idx_assist_org_id (assist_org_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='协办记录表';

INSERT INTO petition_assist_record (dispatch_id, petition_id, assist_org_id, assist_org_name, assist_requirement, deadline_days, deadline_date)
VALUES (2, 2, 3, '社保中心', '请核实李秀英同志的工龄和缴费记录，提供养老金测算数据。', 7, '2026-06-13 00:00:00');
INSERT INTO petition_assist_record (dispatch_id, petition_id, assist_org_id, assist_org_name, assist_requirement, deadline_days, deadline_date, status)
VALUES (1, 1, 1, '薪酬管理科', '请提供王建国2026年5月考勤和工资核算明细。', 3, '2026-06-04 00:00:00', 'REPLIED');

-- ----------------------------------------------------------------------------
-- 14. 办理过程记录表
-- ----------------------------------------------------------------------------
CREATE TABLE petition_process_record (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    petition_id     BIGINT          NOT NULL COMMENT '关联信访件ID',
    dispatch_id     BIGINT          DEFAULT NULL COMMENT '关联派单ID',
    record_type     VARCHAR(30)     NOT NULL COMMENT '记录类型：INVESTIGATION调查取证 COMMUNICATION沟通协调 MEASURES采取措施 POLICY政策研究 OTHER其他',
    record_content  TEXT            NOT NULL COMMENT '过程记录内容',
    record_time     DATETIME        NOT NULL COMMENT '记录时间',
    record_by       BIGINT          NOT NULL COMMENT '记录人ID',
    record_by_name  VARCHAR(50)     NOT NULL COMMENT '记录人姓名',
    attachment_ids  VARCHAR(500)    DEFAULT NULL COMMENT '关联附件ID列表（逗号分隔）',
    sort_order      INT             DEFAULT 0 COMMENT '排序号（时间线展示用）',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_petition_id (petition_id),
    KEY idx_record_time (record_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='办理过程记录表（按时间线展示）';

INSERT INTO petition_process_record (petition_id, dispatch_id, record_type, record_content, record_time, record_by, record_by_name, sort_order) VALUES
(1, 1, 'INVESTIGATION', '已调取王建国2026年5月考勤记录和工资发放明细，初步核实存在加班费计算遗漏的情况。', '2026-06-02 14:00:00', 2, '张三', 1);
INSERT INTO petition_process_record (petition_id, dispatch_id, record_type, record_content, record_time, record_by, record_by_name, sort_order) VALUES
(1, 1, 'COMMUNICATION', '已与王建国本人电话沟通，确认其反映的5月工资差额为3天法定假日加班费共计450元。', '2026-06-03 10:30:00', 2, '张三', 2);

-- ----------------------------------------------------------------------------
-- 15. 最终反馈表
-- ----------------------------------------------------------------------------
CREATE TABLE petition_final_feedback (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    petition_id     BIGINT          NOT NULL COMMENT '关联信访件ID',
    dispatch_id     BIGINT          DEFAULT NULL COMMENT '关联派单ID',
    -- 反馈内容
    feedback_content TEXT           NOT NULL COMMENT '办理结果详细描述（≤10000字符）',
    reply_to_petitioner TEXT        NOT NULL COMMENT '答复信访人情况说明',
    is_appease      VARCHAR(20)     NOT NULL COMMENT '是否息诉罢访：YES是 NO否 PARTIAL部分接受',
    is_appease_note VARCHAR(500)    DEFAULT NULL COMMENT '未息诉罢访原因说明',
    evidence_attachment_ids VARCHAR(500) DEFAULT NULL COMMENT '证据附件ID列表（办结前必须至少上传1个）',
    -- 审核信息（两级审核）
    internal_review_status VARCHAR(20) DEFAULT 'PENDING' COMMENT '内部审核状态：PENDING待审核 PASS通过 REJECT退回',
    internal_review_by BIGINT        DEFAULT NULL COMMENT '内部审核人ID（承办单位内部负责人）',
    internal_review_time DATETIME    DEFAULT NULL COMMENT '内部审核时间',
    internal_review_opinion VARCHAR(500) DEFAULT NULL COMMENT '内部审核意见',
    internal_reject_reason VARCHAR(500) DEFAULT NULL COMMENT '内部审核退回原因',
    final_review_status VARCHAR(20)  DEFAULT 'PENDING' COMMENT '信访科审核状态：PENDING待审核 PASS通过 REJECT退回',
    final_review_by BIGINT           DEFAULT NULL COMMENT '信访科审核人ID（信访管理员）',
    final_review_time DATETIME       DEFAULT NULL COMMENT '信访科审核时间',
    final_review_opinion VARCHAR(500) DEFAULT NULL COMMENT '信访科审核意见',
    final_reject_reason VARCHAR(500)  DEFAULT NULL COMMENT '信访科审核退回原因',
    feedback_by     BIGINT          NOT NULL COMMENT '反馈人ID',
    feedback_time   DATETIME        NOT NULL COMMENT '反馈提交时间',
    feedback_org_id BIGINT          DEFAULT NULL COMMENT '反馈人所属组织ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_petition_id (petition_id),
    KEY idx_internal_review_status (internal_review_status),
    KEY idx_final_review_status (final_review_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='最终反馈表（含两级审核）';

INSERT INTO petition_final_feedback (petition_id, dispatch_id, feedback_content, reply_to_petitioner, is_appease,
    internal_review_status, feedback_by, feedback_time, feedback_org_id)
VALUES (1, 1, '经核查，王建国2026年5月工资中漏计3天法定假日加班费450元，已通知薪酬管理科予以补发，补发金额将在6月工资中一并发放。',
    '已于2026年6月5日电话告知王建国核查结果和补发安排，王建国表示接受。', 'YES',
    'PENDING', 2, '2026-06-05 16:00:00', 2);
INSERT INTO petition_final_feedback (petition_id, dispatch_id, feedback_content, reply_to_petitioner, is_appease,
    internal_review_status, feedback_by, feedback_time, feedback_org_id)
VALUES (2, 2, '根据李秀英同志的个人档案和社保缴费记录，其养老金预计为3850元/月，具体以退休当月社保系统核算为准。',
    '已通过电话向李秀英解释养老金核算政策，建议其退休当月携带身份证到社保大厅办理。', 'YES',
    'PASS', 3, '2026-06-03 11:00:00', 1);

-- ----------------------------------------------------------------------------
-- 16. 督办单表
-- ----------------------------------------------------------------------------
CREATE TABLE petition_supervision (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    supervision_code VARCHAR(30)    NOT NULL COMMENT '督办编号（规则：DB+年份+4位流水，如DB20260001）',
    petition_id     BIGINT          NOT NULL COMMENT '关联信访件ID',
    dispatch_id     BIGINT          DEFAULT NULL COMMENT '关联派单ID',
    -- 督办类型
    trigger_type    VARCHAR(10)     NOT NULL COMMENT '触发类型：DB01时限过半无过程记录 DB02信访人再次反映或上级过问 DB03反馈退回超5天未重提交 DB04协办超3天未回复',
    trigger_detail  TEXT            DEFAULT NULL COMMENT '触发详情说明',
    -- 督办内容
    supervised_org_id BIGINT        NOT NULL COMMENT '被督办单位ID',
    supervised_org_name VARCHAR(100) NOT NULL COMMENT '被督办单位名称',
    supervision_reason TEXT         NOT NULL COMMENT '督办原因',
    supervision_requirement TEXT    NOT NULL COMMENT '督办要求',
    feedback_deadline DATETIME      NOT NULL COMMENT '督办限定反馈日期（默认7天）',
    -- 督办反馈
    feedback_content TEXT           DEFAULT NULL COMMENT '督办反馈内容',
    feedback_time   DATETIME        DEFAULT NULL COMMENT '督办反馈时间',
    feedback_by     BIGINT          DEFAULT NULL COMMENT '督办反馈人ID',
    -- 状态
    status          VARCHAR(30)     NOT NULL DEFAULT 'ISSUED' COMMENT '状态：ISSUED已发出 FEEDBACKED已反馈 CLOSED已闭环',
    issued_by       BIGINT          NOT NULL COMMENT '督办发起人ID',
    issued_time     DATETIME        NOT NULL COMMENT '督办发起时间',
    close_time      DATETIME        DEFAULT NULL COMMENT '闭环时间',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_supervision_code (supervision_code),
    KEY idx_petition_id (petition_id),
    KEY idx_trigger_type (trigger_type),
    KEY idx_status (status),
    KEY idx_supervised_org_id (supervised_org_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='督办单表';

INSERT INTO petition_supervision (supervision_code, petition_id, trigger_type, trigger_detail,
    supervised_org_id, supervised_org_name, supervision_reason, supervision_requirement,
    feedback_deadline, issued_by, issued_time)
VALUES ('DB20260001', 1, 'DB01', '交办已过15天，但仅有1条调查过程记录，无后续处理进展。',
    2, '采油一厂', '办理进度偏慢，时限已过半但过程记录不完整。',
    '请于7日内补充办理过程记录，并明确后续处理计划和预计完成时间。',
    '2026-06-13 00:00:00', 1, '2026-06-06 09:00:00');
INSERT INTO petition_supervision (supervision_code, petition_id, trigger_type, trigger_detail,
    supervised_org_id, supervised_org_name, supervision_reason, supervision_requirement,
    feedback_deadline, status, issued_by, issued_time, feedback_content, feedback_time, feedback_by)
VALUES ('DB20260002', 2, 'DB04', '要求社保中心协办已超过3天，未收到协办回复。',
    3, '社保中心', '协办超3天未回复。',
    '请于3日内完成协办并提交回复。',
    '2026-06-09 00:00:00', 'FEEDBACKED', 1, '2026-06-05 10:00:00',
    '因社保系统升级维护，数据查询延迟，已加急处理。', '2026-06-06 08:30:00', 4);

-- ----------------------------------------------------------------------------
-- 17. 延期/退回记录表（办理过程中的延期和退回历史）
-- ----------------------------------------------------------------------------
CREATE TABLE petition_extension_return (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    petition_id     BIGINT          NOT NULL COMMENT '关联信访件ID',
    dispatch_id     BIGINT          DEFAULT NULL COMMENT '关联派单ID',
    record_type     VARCHAR(20)     NOT NULL COMMENT '记录类型：EXTENSION延期 RETURN退回',
    apply_reason    TEXT            NOT NULL COMMENT '申请原因',
    apply_days      INT             DEFAULT NULL COMMENT '申请延期天数（延期类型时填写）',
    apply_by        BIGINT          NOT NULL COMMENT '申请人ID',
    apply_time      DATETIME        NOT NULL COMMENT '申请时间',
    approve_status  VARCHAR(20)     NOT NULL DEFAULT 'PENDING' COMMENT '审批状态：PENDING待审批 APPROVED已批准 REJECTED已驳回',
    approve_by      BIGINT          DEFAULT NULL COMMENT '审批人ID',
    approve_time    DATETIME        DEFAULT NULL COMMENT '审批时间',
    approve_opinion VARCHAR(500)    DEFAULT NULL COMMENT '审批意见',
    new_deadline_date DATETIME      DEFAULT NULL COMMENT '延期后新的截止日期',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_petition_id (petition_id),
    KEY idx_approve_status (approve_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='延期/退回记录表';

INSERT INTO petition_extension_return (petition_id, dispatch_id, record_type, apply_reason, apply_days,
    apply_by, apply_time, approve_status)
VALUES (1, 1, 'EXTENSION', '因涉及跨部门数据核实（人力+财务），需延长办理时间。', 15,
    2, '2026-06-20 00:00:00', 'PENDING');
INSERT INTO petition_extension_return (petition_id, dispatch_id, record_type, apply_reason,
    apply_by, apply_time, approve_status, approve_by, approve_time, approve_opinion)
VALUES (2, 2, 'RETURN', '李秀英养老金问题属于人力资源部职责范围，非本单位能答复，申请退回重新指派。',
    3, '2026-06-02 00:00:00', 'APPROVED', 1, '2026-06-02 14:00:00', '同意退回，由信访管理员重新分类处置。');

-- ----------------------------------------------------------------------------
-- 18. 附件元数据表
-- ----------------------------------------------------------------------------
CREATE TABLE attachment (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '附件ID',
    business_type   VARCHAR(50)     NOT NULL COMMENT '业务类型：PETITION信访件 PROCESS_RECORD过程记录 FEEDBACK反馈 REPORT办结报告 TEMPLATE模板',
    business_id     BIGINT          NOT NULL COMMENT '关联业务记录ID',
    file_name       VARCHAR(255)    NOT NULL COMMENT '原始文件名',
    file_path       VARCHAR(500)    NOT NULL COMMENT 'NAS文件访问路径（不存储二进制）',
    file_size       BIGINT          DEFAULT NULL COMMENT '文件大小（字节）',
    file_type       VARCHAR(50)     DEFAULT NULL COMMENT '文件类型/MIME类型',
    file_ext        VARCHAR(20)     DEFAULT NULL COMMENT '文件扩展名（pdf/jpg/png/doc/docx/xlsx）',
    file_md5        VARCHAR(64)     DEFAULT NULL COMMENT '文件MD5哈希值（用于去重和完整性校验）',
    upload_by       BIGINT          NOT NULL COMMENT '上传人ID',
    upload_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
    download_count  INT             DEFAULT 0 COMMENT '下载次数',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_business (business_type, business_id),
    KEY idx_file_md5 (file_md5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='附件元数据表（文件实体存NAS）';

INSERT INTO attachment (business_type, business_id, file_name, file_path, file_size, file_ext, upload_by) VALUES
('PETITION', 1, '2026年5月工资条.pdf', '/nas/oilfield/petition/2026/06/XF2026060001LF/wage_slip.pdf', 245760, 'pdf', 2);
INSERT INTO attachment (business_type, business_id, file_name, file_path, file_size, file_ext, upload_by) VALUES
('FEEDBACK', 1, '补发工资通知.pdf', '/nas/oilfield/petition/2026/06/XF2026060001LF/supplement_notice.pdf', 153600, 'pdf', 2);


-- ============================================================================
-- 第四部分：专项工作表组（ZX子系统）
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 19. 不稳定因素隐患排查表
-- ----------------------------------------------------------------------------
CREATE TABLE zx_risk_screening (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    screening_code  VARCHAR(30)     NOT NULL COMMENT '排查编号（规则：PC+年份+4位流水，如PC20260001）',
    screening_date  DATE            NOT NULL COMMENT '排查日期',
    screening_org_id BIGINT         NOT NULL COMMENT '排查单位ID',
    screening_org_name VARCHAR(100) NOT NULL COMMENT '排查单位名称',
    risk_type_level1 VARCHAR(50)    NOT NULL COMMENT '隐患类型一级分类',
    risk_type_level2 VARCHAR(50)    DEFAULT NULL COMMENT '隐患类型二级分类',
    risk_type_level3 VARCHAR(50)    DEFAULT NULL COMMENT '隐患类型三级分类',
    involved_persons VARCHAR(500)   NOT NULL COMMENT '涉及人员（姓名列表，多人分号分隔）',
    involved_count  INT             DEFAULT 1 COMMENT '涉及人数',
    risk_description TEXT           NOT NULL COMMENT '隐患描述（≤2000字符）',
    risk_level      VARCHAR(10)     NOT NULL COMMENT '风险等级：HIGH高中 LOW低',
    control_person  VARCHAR(50)     NOT NULL COMMENT '稳控责任人姓名',
    control_measure TEXT            NOT NULL COMMENT '化解措施',
    resolution_deadline DATE        DEFAULT NULL COMMENT '化解时限（高/中风险必须指定）',
    current_status  VARCHAR(20)     NOT NULL DEFAULT 'UNRESOLVED' COMMENT '当前状态：UNRESOLVED未化解 RESOLVING化解中 RESOLVED已化解 REBOUND反弹',
    status_update_time DATETIME     DEFAULT NULL COMMENT '状态更新时间',
    register_by     BIGINT          NOT NULL COMMENT '登记人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_screening_code (screening_code),
    KEY idx_screening_org_id (screening_org_id),
    KEY idx_risk_level (risk_level),
    KEY idx_current_status (current_status),
    KEY idx_screening_date (screening_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='不稳定因素隐患排查表';

INSERT INTO zx_risk_screening (screening_code, screening_date, screening_org_id, screening_org_name,
    risk_type_level1, risk_type_level2, involved_persons, involved_count, risk_description,
    risk_level, control_person, control_measure, resolution_deadline, register_by)
VALUES ('PC20260001', '2026-06-01', 2, '采油一厂',
    '劳动用工', '劳动合同', '赵六;钱七;孙八', 3,
    '采油一厂作业三区部分劳务派遣人员因转正名额问题产生不满情绪，存在集体上访隐患。',
    'HIGH', '刘明', '1.组织政策宣讲会解释转正政策；2.摸排符合条件的派遣人员名单；3.制定分批转正计划并公示。',
    '2026-07-15', 2);
INSERT INTO zx_risk_screening (screening_code, screening_date, screening_org_id, screening_org_name,
    risk_type_level1, involved_persons, risk_description,
    risk_level, control_person, control_measure, current_status, register_by)
VALUES ('PC20260002', '2026-06-03', 1, '新疆油田有限责任公司',
    '环境保护', '周边居民代表约20人',
    '油田某作业区附近居民反映地下水受到污染，要求油田进行环境检测并提供补偿方案。',
    'HIGH', '陈大伟', '1.联系环保部门开展水质检测；2.成立专项工作组开展入户走访；3.根据检测结果制定补偿或治理方案。',
    'RESOLVING', 1);

-- ----------------------------------------------------------------------------
-- 20. 重点事项化解（包案）表
-- ----------------------------------------------------------------------------
CREATE TABLE zx_key_resolution (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    resolution_code VARCHAR(30)     NOT NULL COMMENT '化解编号（规则：HJ+年份+4位流水，如HJ20260001）',
    case_name       VARCHAR(200)    NOT NULL COMMENT '事项名称',
    related_petition_ids VARCHAR(500) DEFAULT NULL COMMENT '关联信访件ID列表（1:N，逗号分隔）',
    package_leader  VARCHAR(50)     NOT NULL COMMENT '包案领导姓名',
    package_leader_title VARCHAR(100) DEFAULT NULL COMMENT '包案领导职务',
    responsible_org_ids VARCHAR(500) NOT NULL COMMENT '责任单位ID列表（多选，逗号分隔，首位为主办）',
    responsible_org_names VARCHAR(500) NOT NULL COMMENT '责任单位名称列表（冗余）',
    resolution_plan TEXT            NOT NULL COMMENT '化解方案（≤5000字符）',
    progress_percent INT            DEFAULT 0 COMMENT '当前进度（0-100百分比）',
    estimated_resolution_date DATE  DEFAULT NULL COMMENT '预计化解时间',
    actual_resolution_date DATE     DEFAULT NULL COMMENT '实际化解时间',
    resolution_result VARCHAR(20)   DEFAULT NULL COMMENT '化解结果：SUCCESS成功 PARTIAL部分 FAILED未化解 TRANSFERRED_LEGAL转入司法',
    follow_up_measure TEXT          DEFAULT NULL COMMENT '后续稳控措施',
    timeline_log    TEXT            DEFAULT NULL COMMENT '动态时间线（JSON数组：[{date,action,operator}]）',
    current_status  VARCHAR(30)     NOT NULL DEFAULT 'IN_PROGRESS' COMMENT '状态：IN_PROGRESS化解中 COMPLETED已完成 SUSPENDED暂停',
    create_by       BIGINT          NOT NULL COMMENT '创建人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_resolution_code (resolution_code),
    KEY idx_package_leader (package_leader),
    KEY idx_current_status (current_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='重点事项化解（包案）表';

INSERT INTO zx_key_resolution (resolution_code, case_name, related_petition_ids,
    package_leader, package_leader_title, responsible_org_ids, responsible_org_names,
    resolution_plan, progress_percent, estimated_resolution_date, create_by)
VALUES ('HJ20260001', '采油一厂劳务派遣转正问题', '1',
    '张建国', '副总经理', '2,3', '采油一厂,人力资源部',
    '第一阶段（6月）：组织政策宣讲，摸排符合条件人员；第二阶段（7月）：制定分批转正方案并公示；第三阶段（8-9月）：完成首批转正。',
    30, '2026-09-30', 1);
INSERT INTO zx_key_resolution (resolution_code, case_name,
    package_leader, package_leader_title, responsible_org_ids, responsible_org_names,
    resolution_plan, progress_percent, estimated_resolution_date, resolution_result,
    actual_resolution_date, current_status, create_by)
VALUES ('HJ20260002', '某作业区环保信访问题', '刘伟', '安全总监',
    '2,4', '采油一厂,安全环保部',
    '已完成水质检测并出具报告，确认无污染超标；补偿方案已于6月1日公示。',
    100, '2026-06-01', 'SUCCESS', '2026-06-01', 'COMPLETED', 1);

-- ----------------------------------------------------------------------------
-- 21. 稳定风险评估表
-- ----------------------------------------------------------------------------
CREATE TABLE zx_stability_risk_assessment (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    assessment_code VARCHAR(30)     NOT NULL COMMENT '评估编号（规则：PG+年份+4位流水，如PG20260001）',
    assessment_title VARCHAR(200)   NOT NULL COMMENT '评估事项标题',
    assessment_type VARCHAR(50)     NOT NULL COMMENT '评估类型：POLICY政策调整 PROJECT重大项目 OTHER其他',
    assessment_org_id BIGINT        NOT NULL COMMENT '评估单位ID',
    assessment_org_name VARCHAR(100) NOT NULL COMMENT '评估单位名称',
    assessment_content TEXT         NOT NULL COMMENT '评估事项内容描述',
    -- 四项评分字段（每项1-10分）
    score_legality  INT             NOT NULL COMMENT '合法性评分（1-10分）：是否符合法律法规和政策要求',
    score_legality_remark TEXT      DEFAULT NULL COMMENT '合法性评分依据',
    score_rationality INT           NOT NULL COMMENT '合理性评分（1-10分）：是否符合科学发展观和群众利益',
    score_rationality_remark TEXT   DEFAULT NULL COMMENT '合理性评分依据',
    score_feasibility INT           NOT NULL COMMENT '可行性评分（1-10分）：实施条件和时机是否成熟',
    score_feasibility_remark TEXT   DEFAULT NULL COMMENT '可行性评分依据',
    score_controllability INT       NOT NULL COMMENT '可控性评分（1-10分）：是否存在引发不稳定因素的可能',
    score_controllability_remark TEXT DEFAULT NULL COMMENT '可控性评分依据',
    -- 综合评分与自动判定
    total_score     INT             NOT NULL COMMENT '综合总分（四项评分之和）',
    risk_level      VARCHAR(10)     NOT NULL COMMENT '自动判定风险等级：HIGH高风险(≤23分) MEDIUM中风险(24-31分) LOW低风险(≥32分)',
    -- 三级审核
    dept_review_status VARCHAR(20)  DEFAULT 'PENDING' COMMENT '部门审核状态：PENDING待审核 PASS通过 REJECT退回',
    dept_review_by   BIGINT         DEFAULT NULL COMMENT '部门审核人ID',
    dept_review_time DATETIME       DEFAULT NULL COMMENT '部门审核时间',
    dept_review_opinion TEXT        DEFAULT NULL COMMENT '部门审核意见',
    petition_review_status VARCHAR(20) DEFAULT 'PENDING' COMMENT '信访科复核状态：PENDING待审核 PASS通过 REJECT退回',
    petition_review_by BIGINT       DEFAULT NULL COMMENT '信访科复核人ID',
    petition_review_time DATETIME   DEFAULT NULL COMMENT '信访科复核时间',
    petition_review_opinion TEXT    DEFAULT NULL COMMENT '信访科复核意见',
    leader_approve_status VARCHAR(20) DEFAULT 'PENDING' COMMENT '领导审批状态：PENDING待审批 APPROVED已批准 REJECTED已驳回',
    leader_approve_by BIGINT        DEFAULT NULL COMMENT '审批领导ID',
    leader_approve_time DATETIME    DEFAULT NULL COMMENT '领导审批时间',
    leader_approve_opinion TEXT     DEFAULT NULL COMMENT '领导审批意见',
    assessment_by   BIGINT          NOT NULL COMMENT '评估人ID',
    assessment_date DATE            NOT NULL COMMENT '评估日期',
    status          VARCHAR(30)     NOT NULL DEFAULT 'DRAFT' COMMENT '状态：DRAFT草稿 IN_REVIEW审核中 APPROVED已批准 COMPLETED已完成',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_assessment_code (assessment_code),
    KEY idx_risk_level (risk_level),
    KEY idx_assessment_org_id (assessment_org_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='稳定风险评估表';

INSERT INTO zx_stability_risk_assessment (assessment_code, assessment_title, assessment_type,
    assessment_org_id, assessment_org_name, assessment_content,
    score_legality, score_rationality, score_feasibility, score_controllability,
    total_score, risk_level,
    assessment_by, assessment_date, status)
VALUES ('PG20260001', '采油三厂劳务派遣转正方案风险评估', 'POLICY',
    2, '采油一厂',
    '采油三厂拟对符合条件的58名劳务派遣人员分批转正。需评估该方案在政策合规性、员工接受度、实施风险等方面的稳定风险。',
    8, 7, 6, 5,
    26, 'MEDIUM',
    2, '2026-06-02', 'IN_REVIEW');
INSERT INTO zx_stability_risk_assessment (assessment_code, assessment_title, assessment_type,
    assessment_org_id, assessment_org_name, assessment_content,
    score_legality, score_rationality, score_feasibility, score_controllability,
    total_score, risk_level,
    dept_review_status, petition_review_status, leader_approve_status,
    assessment_by, assessment_date, status)
VALUES ('PG20260002', '油田小区物业费调整方案风险评估', 'POLICY',
    1, '新疆油田有限责任公司',
    '拟从2026年9月起对油田家属区物业费进行调整，涉及约2万户职工家庭。需评估调价的合理性、居民承受能力和群体性事件风险。',
    9, 8, 8, 7,
    32, 'LOW',
    'PASS', 'PASS', 'APPROVED',
    1, '2026-06-01', 'COMPLETED');

-- ----------------------------------------------------------------------------
-- 22. 领导接访下访登记表
-- ----------------------------------------------------------------------------
CREATE TABLE zx_leader_reception (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    reception_code  VARCHAR(30)     NOT NULL COMMENT '接访编号（规则：JF+年份+4位流水，如JF20260001）',
    leader_name     VARCHAR(50)     NOT NULL COMMENT '接访领导姓名',
    leader_title    VARCHAR(100)    NOT NULL COMMENT '接访领导职务',
    reception_type  VARCHAR(20)     NOT NULL COMMENT '接访类型：ON_SITE现场接访 VISIT下访 VISIT_APPOINTMENT约访',
    reception_date  DATETIME        NOT NULL COMMENT '接访日期时间',
    reception_location VARCHAR(200) NOT NULL COMMENT '接访地点',
    -- 来访群众信息
    visitor_name    VARCHAR(50)     NOT NULL COMMENT '来访群众姓名',
    visitor_count   INT             DEFAULT 1 COMMENT '来访人数',
    visitor_contact VARCHAR(100)    DEFAULT NULL COMMENT '来访人联系方式',
    visit_subject   VARCHAR(200)    NOT NULL COMMENT '来访事由/反映问题摘要',
    visit_detail    TEXT            DEFAULT NULL COMMENT '来访详细内容',
    -- 接访处理
    leader_opinion  TEXT            NOT NULL COMMENT '接访领导处理意见',
    assigned_dept   VARCHAR(200)    DEFAULT NULL COMMENT '承办部门',
    assigned_deadline DATE          DEFAULT NULL COMMENT '承办截止日期',
    -- 办理结果
    process_result  TEXT            DEFAULT NULL COMMENT '办理结果',
    process_date    DATE            DEFAULT NULL COMMENT '办理完成日期',
    petitioner_satisfaction VARCHAR(20) DEFAULT NULL COMMENT '信访人满意度：SATISFIED满意 BASIC基本满意 UNSATISFIED不满意',
    -- 关联信访件
    related_petition_id BIGINT      DEFAULT NULL COMMENT '关联系统信访件ID（接访后转入系统为信访件的关联）',
    accompany_persons VARCHAR(200)  DEFAULT NULL COMMENT '陪同接访人员（多人逗号分隔）',
    register_by     BIGINT          NOT NULL COMMENT '登记人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_reception_code (reception_code),
    KEY idx_leader_name (leader_name),
    KEY idx_reception_date (reception_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='领导接访下访登记表';

INSERT INTO zx_leader_reception (reception_code, leader_name, leader_title, reception_type,
    reception_date, reception_location, visitor_name, visit_subject, leader_opinion,
    assigned_dept, register_by)
VALUES ('JF20260001', '张建国', '副总经理', 'ON_SITE',
    '2026-06-03 09:00:00', '油田公司总部一楼信访接待室', '周文斌',
    '反映其工伤认定申请提交3个月未获批复，影响治疗费用报销。',
    '请人力资源部一周内核实周文斌同志工伤认定材料提交情况，如材料齐全则尽快完成认定程序；如材料不全则一次性告知补正清单。',
    '人力资源部', 1);
INSERT INTO zx_leader_reception (reception_code, leader_name, leader_title, reception_type,
    reception_date, reception_location, visitor_name, visitor_count, visit_subject, leader_opinion,
    related_petition_id, register_by)
VALUES ('JF20260002', '刘伟', '安全总监', 'VISIT',
    '2026-06-04 14:00:00', '玛湖油田作业区现场', '作业区员工代表', 6,
    '作业区偏远站点通勤班车班次不足，倒班员工出行困难。',
    '请后勤保障部与运输公司协调，评估增加通勤班次的可行性，两周内提出方案。',
    1, 1);

-- ----------------------------------------------------------------------------
-- 23. 特殊群体管控表
-- ----------------------------------------------------------------------------
CREATE TABLE zx_special_group_control (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    group_name      VARCHAR(100)    NOT NULL COMMENT '群体名称/标识',
    group_type      VARCHAR(50)     NOT NULL COMMENT '群体类型：VETERAN退役军人 RETIREE离退休人员 DISPLACED征地安置 REMOTE偏远站点 OTHER其他',
    group_size      INT             DEFAULT NULL COMMENT '群体规模（人数）',
    key_person_name VARCHAR(50)     NOT NULL COMMENT '重点人员姓名（群体牵头人或代表）',
    key_person_id_card VARCHAR(100) DEFAULT NULL COMMENT '重点人员身份证号【AES-256加密存储】',
    key_person_phone VARCHAR(100)   DEFAULT NULL COMMENT '重点人员电话【AES-256加密存储】',
    key_person_address VARCHAR(200) DEFAULT NULL COMMENT '重点人员住址【AES-256加密存储】',
    core_demand     TEXT            NOT NULL COMMENT '核心诉求/关注焦点',
    risk_assessment VARCHAR(10)     NOT NULL COMMENT '风险评估：HIGH高中 LOW低',
    control_measure TEXT            NOT NULL COMMENT '稳控措施',
    control_person  VARCHAR(50)     NOT NULL COMMENT '管控责任人姓名',
    control_person_phone VARCHAR(100) DEFAULT NULL COMMENT '管控责任人电话',
    recent_activity TEXT            DEFAULT NULL COMMENT '近期动向',
    psychological_note TEXT         DEFAULT NULL COMMENT '心理疏导记录（对接心理疏导调解室）',
    last_update_time DATETIME       NOT NULL COMMENT '最近更新时间',
    register_by     BIGINT          NOT NULL COMMENT '登记人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_group_type (group_type),
    KEY idx_risk_assessment (risk_assessment)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='特殊群体管控表';

INSERT INTO zx_special_group_control (group_name, group_type, group_size, key_person_name,
    core_demand, risk_assessment, control_measure, control_person,
    recent_activity, last_update_time, register_by)
VALUES ('采油三厂劳务派遣人员群体', 'REMOTE', 58, '赵六',
    '要求按政策规定转为正式合同制员工，享受同工同酬待遇。',
    'HIGH', '1.每月召开一次座谈会通报转正进展；2.安排专人对接该群体诉求；3.加快转正方案审批流程。',
    '刘明', '2026年5月底曾口头表示若6月无实质性进展将组织集体上访。',
    '2026-06-05 00:00:00', 2);
INSERT INTO zx_special_group_control (group_name, group_type, group_size, key_person_name,
    core_demand, risk_assessment, control_measure, control_person,
    recent_activity, last_update_time, register_by)
VALUES ('2000年前退休职工养老金诉求群体', 'RETIREE', 320, '吴建国',
    '认为2000年改制前的工龄未被完整纳入养老金计算，要求重新核算补发。',
    'HIGH', '1.梳理涉及人员名单和档案材料；2.联合社保中心进行政策比对；3.逐人核算并书面答复。',
    '郑大伟', '2026年4月推选吴建国等5人为代表，拟向油田总部提交联名信函。',
    '2026-06-01 00:00:00', 1);

-- ----------------------------------------------------------------------------
-- 24. 业务模板表
-- ----------------------------------------------------------------------------
CREATE TABLE zx_business_template (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '模板ID',
    template_name   VARCHAR(200)    NOT NULL COMMENT '模板名称',
    template_type   VARCHAR(50)     NOT NULL COMMENT '模板类型：REPLY答复函 DISPATCH交办/转办函 SUPERVISION督办单 REPORT办结报告 ASSESSMENT评估报告 OTHER其他',
    template_content TEXT           NOT NULL COMMENT '模板内容（含占位符，如{petition_code}{petitioner_name}）',
    usage_count     INT             DEFAULT 0 COMMENT '使用次数',
    is_default      TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否默认模板：0否 1是',
    upload_by       BIGINT          DEFAULT NULL COMMENT '上传人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_template_type (template_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='业务模板表';

INSERT INTO zx_business_template (template_name, template_type, template_content, is_default, upload_by) VALUES
('标准答复函模板', 'REPLY', '关于{petition_code}号信访事项的答复意见书\n\n{p petitioner_name}同志：\n您于{petition_date}反映的{appeal_summary}问题，经我单位调查核实，现将有关情况答复如下：\n{reply_content}\n如不服本答复意见，可在收到本答复意见书之日起30日内向上一级信访部门提出复查申请。\n\n{reply_org_name}\n{reply_date}', 1, 1);
INSERT INTO zx_business_template (template_name, template_type, template_content, is_default, upload_by) VALUES
('交办函模板', 'DISPATCH', '信访事项交办函\n\n{to_org_name}：\n现将{p petitioner_name}反映的{appeal_summary}问题（信访编号：{petition_code}）交由你单位办理。请于{deadline_date}前完成调查处理并反馈结果。\n\n联系人：{contact_person}\n联系电话：{contact_phone}\n\n{from_org_name}\n{dispatch_date}', 1, 1);


-- ============================================================================
-- 第五部分：七类台账表组（TZ子系统）
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 25. 文件制度台账表
-- ----------------------------------------------------------------------------
CREATE TABLE tz_document_ledger (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    doc_title       VARCHAR(200)    NOT NULL COMMENT '文件/制度标题',
    doc_type        VARCHAR(50)     NOT NULL COMMENT '文件类型：LAW法规 POLICY公司制度 NOTICE通知 CIRCULAR通报 OTHER其他',
    doc_number      VARCHAR(100)    DEFAULT NULL COMMENT '文件编号/文号',
    issue_date      DATE            NOT NULL COMMENT '发布/印发日期',
    issue_org       VARCHAR(200)    DEFAULT NULL COMMENT '发布单位',
    effective_date  DATE            DEFAULT NULL COMMENT '生效日期',
    expire_date     DATE            DEFAULT NULL COMMENT '废止日期（NULL表示现行有效）',
    doc_summary     TEXT            DEFAULT NULL COMMENT '文件内容摘要',
    keywords        VARCHAR(500)    DEFAULT NULL COMMENT '关键词',
    attachment_ids  VARCHAR(500)    DEFAULT NULL COMMENT '附件ID列表（关联attachment表）',
    archive_location VARCHAR(200)   DEFAULT NULL COMMENT '纸质原件存档位置',
    status          VARCHAR(20)     NOT NULL DEFAULT 'EFFECTIVE' COMMENT '效力状态：EFFECTIVE现行有效 EXPIRED已废止 SUPERSEDED已被替代',
    register_by     BIGINT          NOT NULL COMMENT '登记人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_doc_type (doc_type),
    KEY idx_issue_date (issue_date),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='文件制度台账表';

INSERT INTO tz_document_ledger (doc_title, doc_type, doc_number, issue_date, issue_org, doc_summary, keywords, register_by) VALUES
('中华人民共和国信访工作条例', 'LAW', '国务院令第752号', '2022-02-25', '中共中央、国务院',
    '规范信访工作，保护信访人合法权益，维护信访秩序。自2022年5月1日起施行。', '信访条例,行政法规', 1);
INSERT INTO tz_document_ledger (doc_title, doc_type, doc_number, issue_date, issue_org, doc_summary, keywords, register_by) VALUES
('新疆油田公司信访工作管理办法', 'POLICY', 'XJYT-XF-2025-001', '2025-01-15', '新疆油田有限责任公司信访办公室',
    '规范油田信访工作流程，明确各级单位信访工作职责和办理标准。', '管理办法,油田制度', 1);

-- ----------------------------------------------------------------------------
-- 26. 报告函件台账表
-- ----------------------------------------------------------------------------
CREATE TABLE tz_report_letter_ledger (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    letter_title    VARCHAR(200)    NOT NULL COMMENT '报告/函件标题',
    letter_type     VARCHAR(50)     NOT NULL COMMENT '函件类型：REPORT_TO_SUPERIOR上报函 NOTICE_TO_SUBORDINATE下发通知 REPLY_TO_PETITION答复函 INTER_DEPT函件 OTHER其他',
    letter_number   VARCHAR(100)    DEFAULT NULL COMMENT '函件编号/文号',
    send_date       DATE            NOT NULL COMMENT '发函日期',
    sender_org      VARCHAR(200)    NOT NULL COMMENT '发函单位',
    receiver_org    VARCHAR(200)    NOT NULL COMMENT '收函单位/收件人',
    related_petition_id BIGINT      DEFAULT NULL COMMENT '关联信访件ID',
    letter_summary  TEXT            DEFAULT NULL COMMENT '函件内容摘要',
    attachment_ids  VARCHAR(500)    DEFAULT NULL COMMENT '附件ID列表',
    is_replied      TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否已收到回函：0否 1是',
    reply_date      DATE            DEFAULT NULL COMMENT '回函日期',
    register_by     BIGINT          NOT NULL COMMENT '登记人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_letter_type (letter_type),
    KEY idx_send_date (send_date),
    KEY idx_related_petition_id (related_petition_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='报告函件台账表';

INSERT INTO tz_report_letter_ledger (letter_title, letter_type, letter_number, send_date, sender_org, receiver_org, related_petition_id, letter_summary, register_by) VALUES
('关于采油一厂王建国信访事项的交办函', 'NOTICE_TO_SUBORDINATE', 'XF-JB-2026-001', '2026-06-01', '油田信访办公室', '采油一厂', 1,
    '将王建国反映的工资核算问题交采油一厂办理，要求30日内反馈结果。', 1);
INSERT INTO tz_report_letter_ledger (letter_title, letter_type, letter_number, send_date, sender_org, receiver_org, letter_summary, register_by) VALUES
('关于2026年5月信访工作情况的报告', 'REPORT_TO_SUPERIOR', 'XF-BG-2026-005', '2026-06-01', '油田信访办公室', '集团公司信访办公室',
    '汇报2026年5月新疆油田信访工作总体情况、主要指标和重点案件进展。', 1);

-- ----------------------------------------------------------------------------
-- 27. 包案管理台账表
-- ----------------------------------------------------------------------------
CREATE TABLE tz_package_case_ledger (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    case_name       VARCHAR(200)    NOT NULL COMMENT '包案事项名称',
    case_type       VARCHAR(50)     NOT NULL COMMENT '事项类型：EMPLOYMENT用工问题 WELFARE福利待遇 ENVIRONMENT环境保护 HISTORICAL历史遗留 OTHER其他',
    package_year    VARCHAR(4)      NOT NULL COMMENT '包案年度（如2026）',
    package_level   VARCHAR(20)     NOT NULL COMMENT '包案级别：COMPANY公司级 FACTORY厂处级 WORKSHOP车间级',
    package_leader  VARCHAR(50)     NOT NULL COMMENT '包案领导姓名',
    package_leader_title VARCHAR(100) NOT NULL COMMENT '包案领导职务',
    responsible_org VARCHAR(200)    NOT NULL COMMENT '责任单位名称',
    contact_person  VARCHAR(50)     DEFAULT NULL COMMENT '联系人姓名',
    contact_phone   VARCHAR(100)    DEFAULT NULL COMMENT '联系人电话',
    main_issue      TEXT            NOT NULL COMMENT '主要问题描述',
    resolution_plan TEXT            NOT NULL COMMENT '化解方案',
    start_date      DATE            NOT NULL COMMENT '包案起始日期',
    end_date        DATE            DEFAULT NULL COMMENT '化解完成日期',
    progress_description TEXT       DEFAULT NULL COMMENT '进展描述',
    status          VARCHAR(20)     NOT NULL DEFAULT 'IN_PROGRESS' COMMENT '状态：IN_PROGRESS化解中 COMPLETED已化解 DEFERRED延期',
    register_by     BIGINT          NOT NULL COMMENT '登记人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_package_year (package_year),
    KEY idx_package_level (package_level),
    KEY idx_package_leader (package_leader)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='包案管理台账表';

INSERT INTO tz_package_case_ledger (case_name, case_type, package_year, package_level, package_leader, package_leader_title,
    responsible_org, contact_person, main_issue, resolution_plan, start_date, register_by) VALUES
('采油一厂劳务派遣转正问题', 'EMPLOYMENT', '2026', 'FACTORY', '张建国', '副总经理',
    '采油一厂', '刘明', '劳务派遣人员转正名额有限，部分长期派遣人员未能转正。',
    '1.摸排符合条件人员；2.制定分批转正方案；3.公示转正名单。', '2026-06-01', 1);
INSERT INTO tz_package_case_ledger (case_name, case_type, package_year, package_level, package_leader, package_leader_title,
    responsible_org, main_issue, resolution_plan, start_date, end_date, status, register_by) VALUES
('退休职工补充医疗保险问题', 'WELFARE', '2026', 'COMPANY', '刘伟', '安全总监',
    '人力资源部、社保中心', '部分退休职工反映补充医疗保险报销比例降低，影响就医负担。',
    '1.梳理政策变化依据；2.逐人核算报销差额；3.提交公司领导专题会议研究。', '2026-01-15', '2026-05-20', 'COMPLETED', 1);

-- ----------------------------------------------------------------------------
-- 28. 信访档案台账表
-- ----------------------------------------------------------------------------
CREATE TABLE tz_archive_ledger (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    archive_code    VARCHAR(30)     NOT NULL COMMENT '档案编号',
    petition_id     BIGINT          DEFAULT NULL COMMENT '关联信访件ID',
    petition_code   VARCHAR(30)     DEFAULT NULL COMMENT '关联信访编号',
    archive_type    VARCHAR(50)     NOT NULL COMMENT '档案类型：CASE_ARCHIVE结案卷宗 ANNUAL_REPORT年度报告 STATISTICS统计报表 OTHER其他',
    archive_box_no  VARCHAR(50)     DEFAULT NULL COMMENT '档案盒编号（纸质档案）',
    archive_location VARCHAR(200)   DEFAULT NULL COMMENT '档案存放位置（档案室柜号）',
    archive_date    DATE            NOT NULL COMMENT '归档日期',
    retention_period VARCHAR(20)    NOT NULL COMMENT '保管期限：1年 3年 5年 10年 PERMANENT永久',
    destroy_date    DATE            DEFAULT NULL COMMENT '销毁日期（保管到期后）',
    archive_summary TEXT            DEFAULT NULL COMMENT '档案内容摘要',
    electronic_path VARCHAR(500)    DEFAULT NULL COMMENT '电子档案NAS存储路径',
    is_electronic   TINYINT(1)      NOT NULL DEFAULT 1 COMMENT '是否有电子版：0仅纸质 1有电子版',
    register_by     BIGINT          NOT NULL COMMENT '登记人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_archive_code (archive_code),
    KEY idx_petition_id (petition_id),
    KEY idx_archive_date (archive_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信访档案台账表';

INSERT INTO tz_archive_ledger (archive_code, petition_id, petition_code, archive_type, archive_box_no,
    archive_location, archive_date, retention_period, archive_summary, electronic_path, register_by) VALUES
('DA20260001', 1, 'XF2026060001LF', 'CASE_ARCHIVE', 'XF-2026-06-001', '油田信访档案室A区3号柜',
    '2026-06-06', '10年', '王建国反映工资核算问题信访件全套卷宗（含登记表、交办单、办理记录、答复函）。',
    '/nas/oilfield/archive/2026/XF2026060001LF/', 1);
INSERT INTO tz_archive_ledger (archive_code, petition_id, petition_code, archive_type, archive_date, retention_period, is_electronic, register_by) VALUES
('DA20260002', 2, 'XF2026060002WS', 'CASE_ARCHIVE', '2026-06-06', '3年', 1, 1);

-- ----------------------------------------------------------------------------
-- 29. 业务培训台账表
-- ----------------------------------------------------------------------------
CREATE TABLE tz_training_ledger (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    training_title  VARCHAR(200)    NOT NULL COMMENT '培训标题/主题',
    training_type   VARCHAR(50)     NOT NULL COMMENT '培训类型：LAW_REGULATION法规政策 BUSINESS_SKILL业务技能 SYSTEM_OPERATION系统操作 OTHER其他',
    training_date   DATE            NOT NULL COMMENT '培训日期',
    training_duration DECIMAL(4,1)  DEFAULT NULL COMMENT '培训时长（小时）',
    training_location VARCHAR(200)  DEFAULT NULL COMMENT '培训地点',
    trainer_name    VARCHAR(50)     NOT NULL COMMENT '培训讲师/主讲人姓名',
    trainer_title   VARCHAR(100)    DEFAULT NULL COMMENT '培训讲师职务/单位',
    trainee_count   INT             DEFAULT 0 COMMENT '参训人数',
    trainee_scope   VARCHAR(200)    DEFAULT NULL COMMENT '参训人员范围（如：各二级单位信访岗）',
    training_content TEXT           DEFAULT NULL COMMENT '培训内容摘要',
    training_material_path VARCHAR(500) DEFAULT NULL COMMENT '培训材料NAS存储路径',
    assessment_result VARCHAR(100)  DEFAULT NULL COMMENT '考核结果（如：全员通过）',
    satisfaction_score DECIMAL(3,1) DEFAULT NULL COMMENT '培训满意度评分（1-5）',
    register_by     BIGINT          NOT NULL COMMENT '登记人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_training_date (training_date),
    KEY idx_training_type (training_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='业务培训台账表';

INSERT INTO tz_training_ledger (training_title, training_type, training_date, training_duration, training_location,
    trainer_name, trainer_title, trainee_count, trainee_scope, training_content, register_by) VALUES
('《信访工作条例》专题学习培训', 'LAW_REGULATION', '2026-05-15', 4.0, '油田公司B座3楼培训室',
    '张建国', '副总经理', 120, '油田公司总部及23个二级单位信访工作人员',
    '1.《信访工作条例》全文解读；2.信访办理流程规范化要求；3.典型信访案例剖析。', 1);
INSERT INTO tz_training_ledger (training_title, training_type, training_date, training_duration, training_location,
    trainer_name, trainee_count, trainee_scope, training_content, register_by) VALUES
('油田信访管理系统操作培训', 'SYSTEM_OPERATION', '2026-06-20', 3.0, '油田公司B座3楼培训室',
    '刘宇琛', '项目开发经理', 80, '信访管理员及各单位信访岗代表',
    '1.系统登录和待办管理；2.信访登记和判重操作；3.转交办和反馈流程；4.台账管理。', 1);

-- ----------------------------------------------------------------------------
-- 30. 人员信息台账表
-- ----------------------------------------------------------------------------
CREATE TABLE tz_personnel_ledger (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    person_name     VARCHAR(50)     NOT NULL COMMENT '姓名',
    employee_no     VARCHAR(32)     DEFAULT NULL COMMENT '员工编号',
    id_card         VARCHAR(100)    DEFAULT NULL COMMENT '身份证号【AES-256加密存储，前端页面脱敏展示】',
    phone           VARCHAR(100)    DEFAULT NULL COMMENT '联系电话【AES-256加密存储，前端页面脱敏展示】',
    org_name        VARCHAR(100)    NOT NULL COMMENT '所属单位',
    position        VARCHAR(100)    DEFAULT NULL COMMENT '岗位/职务',
    personnel_type  VARCHAR(50)     NOT NULL COMMENT '人员类型：PETITION_STAFF信访专职 CONCURRENT_STAFF信访兼职 LEADER包案领导 VOLUNTEER志愿者 GRID网格员 OTHER其他',
    duty_description TEXT           DEFAULT NULL COMMENT '信访工作职责描述',
    training_records TEXT           DEFAULT NULL COMMENT '培训记录（JSON：[{date,course,result}]）',
    certificate_info VARCHAR(200)   DEFAULT NULL COMMENT '资质证书信息',
    contact_phone   VARCHAR(100)    DEFAULT NULL COMMENT '工作联系电话',
    contact_email   VARCHAR(100)    DEFAULT NULL COMMENT '工作邮箱',
    status          VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE' COMMENT '在岗状态：ACTIVE在岗 TRANSFERRED调离 RETIRED退休',
    register_by     BIGINT          NOT NULL COMMENT '登记人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_person_name (person_name),
    KEY idx_personnel_type (personnel_type),
    KEY idx_org_name (org_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='人员信息台账表';

INSERT INTO tz_personnel_ledger (person_name, employee_no, org_name, position, personnel_type, duty_description, register_by) VALUES
('张三', 'EMP00002', '采油一厂', '信访岗', 'PETITION_STAFF',
    '负责采油一厂信访件的登记、流转、反馈和台账管理，对接油田信访办公室。', 1);
INSERT INTO tz_personnel_ledger (person_name, org_name, position, personnel_type, duty_description, register_by) VALUES
('李四', '信访办公室', '信访管理员', 'PETITION_STAFF',
    '负责全公司信访件的分类处置、转交办指派、督办跟踪和统计分析。', 1);

-- ----------------------------------------------------------------------------
-- 31. 历史资料台账表
-- ----------------------------------------------------------------------------
CREATE TABLE tz_historical_data_ledger (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    data_title      VARCHAR(200)    NOT NULL COMMENT '资料标题/名称',
    data_type       VARCHAR(50)     NOT NULL COMMENT '资料类型：EXCEL台账 SCANNED扫描件 PHOTO照片 REPORT报告 OTHER其他',
    data_period_start DATE          DEFAULT NULL COMMENT '资料覆盖起始日期',
    data_period_end DATE            DEFAULT NULL COMMENT '资料覆盖截止日期',
    data_description TEXT           DEFAULT NULL COMMENT '资料内容描述',
    original_format VARCHAR(50)     DEFAULT NULL COMMENT '原始格式（如XLS/JPG/PDF）',
    electronic_path VARCHAR(500)    DEFAULT NULL COMMENT '电子版NAS存储路径',
    physical_location VARCHAR(200)  DEFAULT NULL COMMENT '纸质原件存放位置',
    record_count    INT             DEFAULT NULL COMMENT '包含记录数（估算）',
    is_digitized    TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否已数字化：0未数字化 1已数字化',
    register_by     BIGINT          NOT NULL COMMENT '登记人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_data_type (data_type),
    KEY idx_data_period (data_period_start, data_period_end)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='历史资料台账表';

INSERT INTO tz_historical_data_ledger (data_title, data_type, data_period_start, data_period_end,
    data_description, original_format, record_count, is_digitized, register_by) VALUES
('2000年-2010年信访登记台账汇总', 'EXCEL', '2000-01-01', '2010-12-31',
    '2000年至2010年十年间信访事项的Excel登记台账，按月分sheet记录，包含信访人、诉求、渠道、办理结果等基本信息。',
    'XLS', 50000, 0, 1);
INSERT INTO tz_historical_data_ledger (data_title, data_type, data_period_start, data_period_end,
    data_description, original_format, record_count, is_digitized, electronic_path, register_by) VALUES
('2011年-2020年信访扫描档案', 'SCANNED', '2011-01-01', '2020-12-31',
    '2011至2020年信访纸质登记表和答复函的扫描件，按年度分文件夹存储。',
    'JPG', 30000, 1, '/nas/oilfield/historical/scanned/2011-2020/', 1);

-- ----------------------------------------------------------------------------
-- 32. 历史数据迁移记录表
-- ----------------------------------------------------------------------------
CREATE TABLE tz_historical_migration_record (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    migration_batch VARCHAR(50)     NOT NULL COMMENT '迁移批次号（如MIG20260601）',
    migration_type  VARCHAR(50)     NOT NULL COMMENT '迁移类型：EXCEL_IMPORT Excel导入 OLD_SYSTEM旧系统迁移 MANUAL手工录入',
    source_file_path VARCHAR(500)   DEFAULT NULL COMMENT '源文件路径（Excel导入时）',
    source_description TEXT         DEFAULT NULL COMMENT '数据来源描述',
    total_rows      INT             NOT NULL DEFAULT 0 COMMENT '源数据总行数',
    success_rows    INT             NOT NULL DEFAULT 0 COMMENT '成功导入行数',
    failed_rows     INT             NOT NULL DEFAULT 0 COMMENT '失败行数',
    error_report_path VARCHAR(500)  DEFAULT NULL COMMENT '错误报告文件路径',
    target_table    VARCHAR(100)    NOT NULL COMMENT '目标数据表名',
    migration_start_time DATETIME   NOT NULL COMMENT '迁移开始时间',
    migration_end_time DATETIME     DEFAULT NULL COMMENT '迁移结束时间',
    migration_status VARCHAR(20)    NOT NULL DEFAULT 'IN_PROGRESS' COMMENT '迁移状态：IN_PROGRESS进行中 COMPLETED已完成 FAILED失败',
    verify_result   TEXT            DEFAULT NULL COMMENT '迁移校验结果（记录数对比、核心字段完整性）',
    migration_by    BIGINT          NOT NULL COMMENT '迁移执行人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_migration_batch (migration_batch),
    KEY idx_target_table (target_table)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='历史数据迁移记录表';

INSERT INTO tz_historical_migration_record (migration_batch, migration_type, source_description,
    total_rows, success_rows, failed_rows, target_table,
    migration_start_time, migration_end_time, migration_status, migration_by) VALUES
('MIG20260601', 'EXCEL_IMPORT', '2000-2010年信访登记台账Excel文件（50个年度文件）',
    50000, 49850, 150, 'petition',
    '2026-06-05 09:00:00', '2026-06-05 14:30:00', 'COMPLETED', 1);
INSERT INTO tz_historical_migration_record (migration_batch, migration_type, source_description,
    total_rows, success_rows, failed_rows, target_table,
    migration_start_time, migration_end_time, migration_status, verify_result, migration_by) VALUES
('MIG20260602', 'MANUAL', '2011-2020年纸质档案数字化后手动录入（分批进行中）',
    30000, 5000, 0, 'petition',
    '2026-06-05 15:00:00', NULL, 'IN_PROGRESS',
    '首5000条验证通过，核心字段完整性100%', 1);


-- ============================================================================
-- 第六部分：统计&预警表组（TJ子系统）
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 33. 预警规则配置表
-- ----------------------------------------------------------------------------
CREATE TABLE tj_alert_rule_config (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    rule_code       VARCHAR(20)     NOT NULL COMMENT '规则编码：YJ01同一人7天内重复信访≥2次 YJ02同一关键词7天内集中出现≥5次 YJ03某单位访量环比增长≥50% YJ04重点群体人员新信访活动 YJ05高风险事项未限期启动化解≥3天',
    rule_name       VARCHAR(200)    NOT NULL COMMENT '规则名称',
    alert_level     VARCHAR(10)     NOT NULL COMMENT '预警级别：HIGH高中 LOW低',
    check_frequency VARCHAR(20)     NOT NULL COMMENT '检查频率：REALTIME实时 DAILY每日 WEEKLY每周',
    rule_expression TEXT            NOT NULL COMMENT '规则表达式/配置（JSON格式存储阈值参数）',
    rule_description TEXT           DEFAULT NULL COMMENT '规则说明',
    is_enabled      TINYINT(1)      NOT NULL DEFAULT 1 COMMENT '是否启用：0停用 1启用',
    notify_targets  VARCHAR(500)    DEFAULT NULL COMMENT '通知目标用户ID列表（逗号分隔）',
    last_execute_time DATETIME      DEFAULT NULL COMMENT '最近执行时间',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_rule_code (rule_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='预警规则配置表';

INSERT INTO tj_alert_rule_config (rule_code, rule_name, alert_level, check_frequency, rule_expression, rule_description, notify_targets) VALUES
('YJ01', '同一人7天内重复信访≥2次', 'HIGH', 'REALTIME',
    '{"window_days":7,"min_count":2,"match_fields":["id_card","phone"]}',
    '同一信访人7天内通过任意渠道提交信访≥2次，自动预警，防止重复信访和恶意刷件。', '1');
INSERT INTO tj_alert_rule_config (rule_code, rule_name, alert_level, check_frequency, rule_expression, rule_description, notify_targets) VALUES
('YJ02', '同一关键词7天内集中出现≥5次', 'MEDIUM', 'DAILY',
    '{"window_days":7,"min_count":5,"keyword_source":"keyword_tags"}',
    '同一关键词标签（如"工资""养老金"）在7天内集中出现≥5次，可能预示群体性诉求爆发。', '1');

-- ----------------------------------------------------------------------------
-- 34. 预警消息记录表
-- ----------------------------------------------------------------------------
CREATE TABLE tj_alert_message_record (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    alert_code      VARCHAR(30)     NOT NULL COMMENT '预警消息编号（规则：YJ+年份+4位流水，如YJ20260001）',
    rule_code       VARCHAR(20)     NOT NULL COMMENT '触发规则编码（关联tj_alert_rule_config.rule_code）',
    alert_level     VARCHAR(10)     NOT NULL COMMENT '预警级别：HIGH高中 LOW低',
    alert_title     VARCHAR(200)    NOT NULL COMMENT '预警标题',
    alert_content   TEXT            NOT NULL COMMENT '预警详情内容',
    related_petition_ids VARCHAR(500) DEFAULT NULL COMMENT '关联信访件ID列表（逗号分隔）',
    related_org_id  BIGINT          DEFAULT NULL COMMENT '关联单位ID',
    alert_time      DATETIME        NOT NULL COMMENT '预警生成时间',
    -- 处置跟踪
    notified_users  VARCHAR(500)    DEFAULT NULL COMMENT '已通知用户ID列表',
    notify_channel  VARCHAR(50)     DEFAULT NULL COMMENT '通知渠道：ZHANGXINYOU掌上新油 SMS短信 EMAIL邮件',
    handle_status   VARCHAR(20)     NOT NULL DEFAULT 'PENDING' COMMENT '处置状态：PENDING待处理 INVESTIGATING排查中 SUPERVISION已督办 IGNORED已忽略',
    handle_by       BIGINT          DEFAULT NULL COMMENT '处理人ID',
    handle_time     DATETIME        DEFAULT NULL COMMENT '处理时间',
    handle_remark   TEXT            DEFAULT NULL COMMENT '处理备注',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_alert_time (alert_time),
    KEY idx_alert_level (alert_level),
    KEY idx_handle_status (handle_status),
    KEY idx_rule_code (rule_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='预警消息记录表';

INSERT INTO tj_alert_message_record (alert_code, rule_code, alert_level, alert_title, alert_content,
    related_petition_ids, alert_time, handle_status)
VALUES ('YJ20260001', 'YJ01', 'HIGH', '检测到重复信访风险',
    '信访人"王建国"（身份证号尾号1234）在7天内通过来访和网上信访两个渠道共提交2次信访，诉求内容高度相似。建议核查是否为重复件。',
    '1,2', '2026-06-03 10:00:00', 'PENDING');
INSERT INTO tj_alert_message_record (alert_code, rule_code, alert_level, alert_title, alert_content,
    related_petition_ids, related_org_id, alert_time, notify_channel, handle_status, handle_by, handle_time, handle_remark)
VALUES ('YJ20260002', 'YJ03', 'MEDIUM', '采油一厂访量环比大幅增长',
    '采油一厂本月信访量较上月环比增长65%，超过预警阈值50%。本月访量主要集中在"劳动用工"类别，建议重点关注。',
    NULL, 2, '2026-06-05 08:00:00', 'ZHANGXINYOU', 'INVESTIGATING', 1, '2026-06-05 09:00:00', '已联系采油一厂信访岗核实情况，正在排查原因。');

-- ----------------------------------------------------------------------------
-- 35. 统计指标中间表（StarSchema星型模型）
-- ----------------------------------------------------------------------------
CREATE TABLE tj_statistics_indicator (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    stat_date       DATE            NOT NULL COMMENT '统计日期',
    stat_dimension  VARCHAR(50)     NOT NULL COMMENT '统计维度：TIME时间 ORG单位 CHANNEL渠道 CATEGORY诉求类别 STATUS状态',
    dimension_value VARCHAR(100)    NOT NULL COMMENT '维度值（如：采油一厂/LF来访/劳动用工）',
    -- 统计指标
    total_count     INT             NOT NULL DEFAULT 0 COMMENT '访量总数',
    new_count       INT             NOT NULL DEFAULT 0 COMMENT '新增信访数',
    completed_count INT             NOT NULL DEFAULT 0 COMMENT '办结数',
    in_progress_count INT           NOT NULL DEFAULT 0 COMMENT '办理中数',
    overdue_count   INT             NOT NULL DEFAULT 0 COMMENT '超期数',
    collective_count INT            NOT NULL DEFAULT 0 COMMENT '集体访数',
    duplicate_count INT             NOT NULL DEFAULT 0 COMMENT '重复信访数',
    avg_process_days DECIMAL(6,2)   DEFAULT NULL COMMENT '平均办理天数',
    satisfaction_avg DECIMAL(3,2)   DEFAULT NULL COMMENT '平均满意度（1-5）',
    -- 同比环比
    last_year_count INT             DEFAULT NULL COMMENT '去年同期数',
    yoy_change_pct  DECIMAL(6,2)    DEFAULT NULL COMMENT '同比增长率(%)',
    last_period_count INT           DEFAULT NULL COMMENT '上期数（上月/上季）',
    qoq_change_pct  DECIMAL(6,2)    DEFAULT NULL COMMENT '环比增长率(%)',
    stat_level      VARCHAR(20)     NOT NULL DEFAULT 'DAILY' COMMENT '统计粒度：DAILY日 MONTHLY月 QUARTERLY季 YEARLY年',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (id),
    KEY idx_stat_date (stat_date),
    KEY idx_stat_dimension (stat_dimension),
    KEY idx_stat_level (stat_level),
    UNIQUE KEY uk_stat_record (stat_date, stat_dimension, dimension_value, stat_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='统计指标中间表（StarSchema星型模型）';

INSERT INTO tj_statistics_indicator (stat_date, stat_dimension, dimension_value, total_count, new_count, completed_count,
    in_progress_count, overdue_count, collective_count, duplicate_count, avg_process_days, stat_level)
VALUES ('2026-06-01', 'ORG', '采油一厂', 15, 3, 10, 2, 1, 1, 2, 18.5, 'DAILY');
INSERT INTO tj_statistics_indicator (stat_date, stat_dimension, dimension_value, total_count, new_count, completed_count,
    in_progress_count, overdue_count, avg_process_days, satisfaction_avg, stat_level)
VALUES ('2026-06-01', 'CHANNEL', 'LF', 8, 2, 5, 1, 0, 22.0, 4.2, 'DAILY');


-- ============================================================================
-- 第七部分：群众用户端表组（QZ子系统）
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 36. 网上信访提交表
-- ----------------------------------------------------------------------------
CREATE TABLE qz_online_petition (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    petition_id     BIGINT          DEFAULT NULL COMMENT '关联系统信访件ID（审核通过后关联petition表）',
    -- 提交模式
    submit_mode     VARCHAR(20)     NOT NULL COMMENT '提交模式：STANDARD标准表单 SIMPLIFIED简化表单（仅姓名/电话/内容）',
    -- 信访人信息
    petitioner_name VARCHAR(50)     NOT NULL COMMENT '信访人姓名',
    petitioner_phone VARCHAR(100)   NOT NULL COMMENT '信访人联系电话【AES-256加密存储】',
    petitioner_id_card VARCHAR(100) DEFAULT NULL COMMENT '身份证号（选填）【AES-256加密存储】',
    petitioner_employee_no VARCHAR(32) DEFAULT NULL COMMENT '员工编号（登录用户自动带入）',
    petitioner_org_id BIGINT        DEFAULT NULL COMMENT '所属单位ID',
    petitioner_org_name VARCHAR(100) DEFAULT NULL COMMENT '所属单位名称',
    -- 诉求信息
    appeal_category_level1 VARCHAR(50) DEFAULT NULL COMMENT '诉求类别一级',
    appeal_category_level2 VARCHAR(50) DEFAULT NULL COMMENT '诉求类别二级',
    appeal_category_level3 VARCHAR(50) DEFAULT NULL COMMENT '诉求类别三级',
    involved_org_ids VARCHAR(500)   DEFAULT NULL COMMENT '涉及单位ID列表',
    appeal_content  TEXT            NOT NULL COMMENT '诉求内容（标准模式≤5000字符，简化模式≤2000字符）',
    -- 附件（文件存NAS）
    attachment_count INT            DEFAULT 0 COMMENT '附件数量（单文件≤50MB，最多5个）',
    -- 提交后系统反馈
    feedback_message TEXT           DEFAULT NULL COMMENT '提交成功后展示的系统反馈信息（含信访编号和预计时限）',
    sms_notified    TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否已发送短信通知：0否 1是',
    -- 审核状态
    review_status   VARCHAR(20)     NOT NULL DEFAULT 'PENDING' COMMENT '审核状态：PENDING待审核 ACCEPTED已受理（转入PT流程） REJECTED不予受理',
    review_by       BIGINT          DEFAULT NULL COMMENT '审核人ID（信访管理员）',
    review_time     DATETIME        DEFAULT NULL COMMENT '审核时间',
    review_opinion  VARCHAR(500)    DEFAULT NULL COMMENT '审核意见',
    reject_reason   VARCHAR(500)    DEFAULT NULL COMMENT '不予受理原因',
    -- 提交信息
    submit_ip       VARCHAR(50)     DEFAULT NULL COMMENT '提交IP地址',
    submit_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提交时间',
    user_id         BIGINT          DEFAULT NULL COMMENT '提交用户ID（登录用户关联sys_user）',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_petition_id (petition_id),
    KEY idx_review_status (review_status),
    KEY idx_submit_time (submit_time),
    KEY idx_petitioner_phone (petitioner_phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='网上信访提交表（群众用户端）';

INSERT INTO qz_online_petition (petition_id, submit_mode, petitioner_name, petitioner_phone,
    petitioner_employee_no, petitioner_org_id, petitioner_org_name,
    appeal_category_level1, appeal_content,
    review_status, review_by, review_time, review_opinion, submit_ip, user_id)
VALUES (2, 'STANDARD', '李秀英', 'AES_PLACEHOLDER_13800138000', 'EMP00100', 1, '新疆油田有限责任公司',
    '社会保障', '本人将于2026年8月退休，咨询养老金核算标准和具体金额计算方式。请相关部门予以解答。',
    'ACCEPTED', 1, '2026-06-02 09:00:00', '属于正常政策咨询，已转入系统PT-02登记。', '10.10.10.50', 5);
INSERT INTO qz_online_petition (submit_mode, petitioner_name, petitioner_phone,
    appeal_content, review_status, submit_ip, submit_time)
VALUES ('SIMPLIFIED', '退休职工老张', 'AES_PLACEHOLDER_13909999999',
    '我是2005年退休的老职工，想了解一下为什么我的养老金比同工龄的人少了好几百？请帮我查一下。',
    'PENDING', '10.10.20.100', '2026-06-05 16:30:00');

-- ----------------------------------------------------------------------------
-- 37. 信访评价表
-- ----------------------------------------------------------------------------
CREATE TABLE qz_petition_evaluation (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    petition_id     BIGINT          NOT NULL COMMENT '关联信访件ID',
    user_id         BIGINT          DEFAULT NULL COMMENT '评价人用户ID',
    -- 评价维度
    satisfaction_score TINYINT      NOT NULL COMMENT '整体满意度（1-5星）',
    is_timely_satisfied TINYINT(1)  NOT NULL COMMENT '办理时效是否满意：0否 1是',
    problem_resolved VARCHAR(20)    NOT NULL COMMENT '问题解决程度：FULLY完全解决 PARTIAL部分解决 NOT_RESOLVED未解决',
    suggestion      VARCHAR(500)    DEFAULT NULL COMMENT '意见和建议（≤500字符）',
    evaluate_time   DATETIME        NOT NULL COMMENT '评价时间',
    evaluation_source VARCHAR(20)   DEFAULT 'WEB' COMMENT '评价来源：WEB网页端 MOBILE移动端',
    -- 评价后续
    is_low_score    TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否低分（1-2星）：0否 1是（低分自动提醒信访管理员）',
    follow_up_note  TEXT            DEFAULT NULL COMMENT '低分跟进记录',
    follow_up_time  DATETIME        DEFAULT NULL COMMENT '跟进处理时间',
    is_valid        TINYINT(1)      NOT NULL DEFAULT 1 COMMENT '评价是否有效：0无效（超期未评） 1有效',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_petition_id (petition_id),
    KEY idx_user_id (user_id),
    KEY idx_satisfaction_score (satisfaction_score)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='信访评价表（群众用户端）';

INSERT INTO qz_petition_evaluation (petition_id, user_id, satisfaction_score, is_timely_satisfied, problem_resolved,
    suggestion, evaluate_time)
VALUES (1, 5, 4, 1, 'FULLY', '办理速度很快，工作人员态度好，问题得到了满意的解决。', '2026-06-06 10:00:00');
INSERT INTO qz_petition_evaluation (petition_id, user_id, satisfaction_score, is_timely_satisfied, problem_resolved,
    suggestion, evaluate_time, is_low_score)
VALUES (2, 6, 2, 0, 'NOT_RESOLVED', '只说让我等退休当月去社保大厅办理，没有给出具体的金额计算方式，不满意。', '2026-06-06 11:00:00', 1);

-- ----------------------------------------------------------------------------
-- 38. 政策文档表
-- ----------------------------------------------------------------------------
CREATE TABLE qz_policy_document (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    doc_title       VARCHAR(200)    NOT NULL COMMENT '文档标题',
    doc_type        VARCHAR(50)     NOT NULL COMMENT '文档类型：POLICY政策法规 FAQ常见问题 NOTICE通知公告 OTHER其他',
    doc_content     TEXT            NOT NULL COMMENT '文档内容（富文本，支持图文混排）',
    doc_summary     VARCHAR(500)    DEFAULT NULL COMMENT '文档摘要（列表展示用）',
    keywords        VARCHAR(500)    DEFAULT NULL COMMENT '关键词（搜索用）',
    is_published    TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否已发布：0草稿 1已发布',
    publish_date    DATETIME        DEFAULT NULL COMMENT '发布日期',
    view_count      INT             DEFAULT 0 COMMENT '浏览次数',
    sort_order      INT             DEFAULT 0 COMMENT '排序号',
    publish_by      BIGINT          DEFAULT NULL COMMENT '发布人ID',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_doc_type (doc_type),
    KEY idx_is_published (is_published)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='政策文档表（群众用户端）';

INSERT INTO qz_policy_document (doc_title, doc_type, doc_content, doc_summary, keywords, is_published, publish_date, publish_by) VALUES
('《信访工作条例》全文', 'POLICY',
 '（此处为《信访工作条例》全文，含总则、信访工作体制、信访事项的提出和受理、信访事项的办理、监督和追责、附则共六章50条。）',
 '2022年5月1日施行的《信访工作条例》全文，中共中央、国务院发布。', '信访条例,法规', 1, '2026-06-01 00:00:00', 1);
INSERT INTO qz_policy_document (doc_title, doc_type, doc_content, doc_summary, keywords, is_published, publish_date, publish_by) VALUES
('信访后多久能收到答复？', 'FAQ',
 '根据《信访工作条例》规定：1.信访事项在15日内决定是否受理；2.受理后60日内办结，情况复杂的可延长30日；3.对处理结果不服的，可在30日内申请复查。',
 '关于信访办理时限的常见问题解答。', '办理时限,FAQ', 1, '2026-06-01 00:00:00', 1);


-- ============================================================================
-- 第八部分：移动端配套表组（YD子系统）
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 39. 消息推送记录表
-- ----------------------------------------------------------------------------
CREATE TABLE yd_message_push_record (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    push_type       VARCHAR(50)     NOT NULL COMMENT '推送类型：TODO待办提醒 URGE催办通知 ALERT预警通知 EVALUATION评价提醒 SYSTEM系统通知',
    push_title      VARCHAR(200)    NOT NULL COMMENT '推送标题',
    push_content    VARCHAR(1000)   NOT NULL COMMENT '推送内容描述',
    push_channel    VARCHAR(50)     NOT NULL COMMENT '推送渠道：ZHANGXINYOU掌上新油 SMS短信 EMAIL邮件',
    target_user_id  BIGINT          NOT NULL COMMENT '目标用户ID',
    target_user_name VARCHAR(50)    DEFAULT NULL COMMENT '目标用户姓名',
    -- 关联业务信息
    related_type    VARCHAR(50)     DEFAULT NULL COMMENT '关联业务类型（如PETITION/SUPERVISION）',
    related_id      BIGINT          DEFAULT NULL COMMENT '关联业务ID',
    jump_url        VARCHAR(500)    DEFAULT NULL COMMENT '点击跳转链接（移动端H5页面URL）',
    -- 推送状态
    push_status     VARCHAR(20)     NOT NULL DEFAULT 'PENDING' COMMENT '推送状态：PENDING待推送 PUSHING推送中 SUCCESS推送成功 FAILED推送失败',
    push_time       DATETIME        DEFAULT NULL COMMENT '实际推送时间',
    retry_count     INT             DEFAULT 0 COMMENT '重试次数',
    fail_reason     VARCHAR(500)    DEFAULT NULL COMMENT '推送失败原因',
    -- 用户处理
    is_read         TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否已读：0未读 1已读',
    read_time       DATETIME        DEFAULT NULL COMMENT '阅读时间',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    KEY idx_target_user (target_user_id, is_read),
    KEY idx_push_type (push_type),
    KEY idx_push_status (push_status),
    KEY idx_push_time (push_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='消息推送记录表（移动端）';

INSERT INTO yd_message_push_record (push_type, push_title, push_content, push_channel, target_user_id, target_user_name,
    related_type, related_id, jump_url, push_status, push_time, is_read)
VALUES ('TODO', '您有新的待办信访件', '信访件XF2026060001LF已交办至采油一厂，请及时签收办理。', 'ZHANGXINYOU', 2, '张三',
    'PETITION', 1, '/mobile/petition/detail/1', 'SUCCESS', '2026-06-01 10:00:00', 1);
INSERT INTO yd_message_push_record (push_type, push_title, push_content, push_channel, target_user_id, target_user_name,
    related_type, related_id, jump_url, push_status, is_read)
VALUES ('URGE', '信访件办理催办提醒', '信访件XF2026060001LF办理时限剩余7天，请尽快完成办理并提交反馈。', 'ZHANGXINYOU', 2, '张三',
    'PETITION', 1, '/mobile/petition/detail/1', 'SUCCESS', 0);

-- ----------------------------------------------------------------------------
-- 40. 用户免打扰配置表
-- ----------------------------------------------------------------------------
CREATE TABLE yd_user_dnd_config (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    user_id         BIGINT          NOT NULL COMMENT '用户ID',
    dnd_enabled     TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否开启免打扰：0关闭 1开启',
    -- 免打扰时段
    dnd_start_time  TIME            DEFAULT NULL COMMENT '免打扰开始时间（如22:00）',
    dnd_end_time    TIME            DEFAULT NULL COMMENT '免打扰结束时间（如07:00）',
    -- 免打扰范围（哪些类型的消息不在免打扰时段推送）
    dnd_push_types  VARCHAR(500)    DEFAULT NULL COMMENT '免打扰消息类型（逗号分隔，为空表示全部类型免打扰）',
    -- 例外规则（紧急消息始终推送）
    allow_urgent    TINYINT(1)      NOT NULL DEFAULT 1 COMMENT '紧急消息是否始终推送（不受免打扰限制）：0否 1是',
    -- 推送偏好
    preferred_channel VARCHAR(50)   DEFAULT 'ZHANGXINYOU' COMMENT '首选推送渠道：ZHANGXINYOU掌上新油 SMS短信 EMAIL邮件',
    quiet_weekend   TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '周末是否静默：0否 1是（仅推送紧急消息）',
    create_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_del          TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '逻辑删除：0正常 1已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户免打扰配置表（移动端）';

INSERT INTO yd_user_dnd_config (user_id, dnd_enabled, dnd_start_time, dnd_end_time, allow_urgent, preferred_channel) VALUES
(1, 1, '22:00:00', '07:00:00', 1, 'ZHANGXINYOU');
INSERT INTO yd_user_dnd_config (user_id, dnd_enabled, quiet_weekend, preferred_channel) VALUES
(2, 0, 1, 'ZHANGXINYOU');


-- ============================================================================
-- 附录一：数据库设计说明
-- ============================================================================
--
-- 【分表逻辑说明】
-- 1. 系统管理表组（XT）：sys_user/sys_role/sys_user_role/sys_organization/sys_dict_type/
--    sys_dict_item/sys_config/sys_login_log/sys_operation_log/sys_api_call_log
--    支撑系统基础运行，独立于业务逻辑。字典表采用 type+item 两级设计，灵活扩展。
--
-- 2. 信访办理核心表组（PT）：petition/petition_duplicate_relation/petition_dispatch/
--    petition_assist_record/petition_process_record/petition_final_feedback/
--    petition_supervision/petition_extension_return/attachment
--    承担核心办理流程，petition为所有业务的枢纽主表。dispatch区分交办/转办/呈报三种类型
--    共享同一表结构（dispatch_type字段区分），减少表数量、降低JOIN复杂度。
--    process_record支持分阶段多次记录，按时间倒序展示为时间线。
--    final_feedback含两级审核字段（内部审核+信访科审核）。
--
-- 3. 专项工作表组（ZX）：zx_risk_screening/zx_key_resolution/
--    zx_stability_risk_assessment/zx_leader_reception/zx_special_group_control/
--    zx_business_template
--    独立于信访办理流程的专项业务，各有独立的编号规则和业务字段。
--    stability_risk_assessment的risk_level由total_score自动判定，无需手动设置。
--
-- 4. 七类台账表组（TZ）：tz_document_ledger/tz_report_letter_ledger/
--    tz_package_case_ledger/tz_archive_ledger/tz_training_ledger/
--    tz_personnel_ledger/tz_historical_data_ledger/tz_historical_migration_record
--    台账表采用通用CRUD模式，每类台账独立字段模板，支持附件关联和Excel导出。
--
-- 5. 统计&预警表组（TJ）：tj_alert_rule_config/tj_alert_message_record/
--    tj_statistics_indicator
--    预警规则可配置（阈值参数以JSON存储），预警消息全流程可追溯。
--    statistics_indicator采用星型模型，支持多维度聚合和同比/环比计算。
--
-- 6. 群众用户端表组（QZ）：qz_online_petition/qz_petition_evaluation/qz_policy_document
--    网上信访提交后经审核可转入PT流程（petition表），通过petition_id关联。
--    评价表支持低分自动提醒。
--
-- 7. 移动端配套表（YD）：yd_message_push_record/yd_user_dnd_config
--    推送记录表记录全量推送历史，支持状态跟踪和重试。
--    免打扰配置支持时段和类型双重控制。
--
-- 【索引方案】
-- 1. 唯一索引：所有业务编码字段（petition_code/supervision_code/assessment_code等）建立唯一索引
-- 2. 普通索引：所有外键关联字段（petition_id/org_id/user_id等）建立普通索引，
--    支撑JOIN查询和关联筛选。不创建物理外键，约束在业务代码层实现，避免级联操作风险。
-- 3. 复合索引：高频组合查询条件（如petition表status+register_time）考虑建立复合索引
-- 4. 日志表：按时间字段建立索引，配合分区提升查询性能
-- 5. 加密字段（身份证号/手机号）：因加密后原值不可逆，仅建立普通索引用于精确匹配
--    （如判重场景通过加密后密文比对），不支持范围查询和模糊查询
--
-- 【敏感字段加密方案】
-- 1. 加密算法：AES-256-CBC，密钥通过环境变量注入，不写入配置文件或代码仓库
-- 2. 加密字段：身份证号(id_card)、手机号(phone)、住址(address)
--    - 存储层：数据库中存储加密后的密文（Base64编码），字段类型VARCHAR(100-200)
--    - 传输层：HTTPS(TLS1.2+)加密传输
--    - 应用层：后端解密后，根据角色权限决定是否脱敏后再返回前端
-- 3. 脱敏规则（前端展示）：
--    - 身份证号：显示前6位+后4位，中间以****替代（如650101****1234）
--    - 手机号：显示前3位+后4位，中间以****替代（如138****8000）
--    - 住址：仅显示到区县级别，详细地址以****替代
-- 4. 判重场景处理：判重匹配通过加密后的密文进行精确比对（相同原文加密后密文相同），
--    加密模式需确保确定性（固定IV或使用确定性加密模式，如AES-256-ECB或固定IV的CBC）
-- 5. 密钥管理：
--    - 主密钥存储在密钥管理服务(KMS)或安全环境变量中
--    - 密钥定期轮换（建议每6个月），轮换时需重新加密历史数据
--    - 备份密钥存储在信息安全管理部门的安全介质中
-- 6. 数据库备份加密：备份文件采用GPG对称加密后存储，防止备份介质丢失导致数据泄露
--
-- 【信访编号规则】
-- 格式：XF + YYYYMM + 4位流水号 + 2位渠道编码
-- 示例：XF2026050001LF = 2026年5月第1号来访信访件
-- 渠道编码：LF来访 LX来信 LD来电 WS网上信访 SZ上级转送 LP领导批示
-- 流水号：按月重置，从0001开始递增
--
-- 【督办编号规则】
-- 格式：DB + 年份 + 4位流水号
-- 示例：DB20260001 = 2026年第1号督办单
-- 触发类型：DB01时限过半无过程记录 DB02信访人再次反映 DB03反馈退回超5天未重提交 DB04协办超3天未回复
--
-- 【预警规则编码】
-- YJ01：同一人7天内重复信访≥2次（实时/高）
-- YJ02：同一关键词7天内集中出现≥5次（每日/中）
-- YJ03：某单位访量环比增长≥50%（每日/中）
-- YJ04：重点群体人员新信访活动（实时/高）
-- YJ05：高风险事项未限期启动化解≥3天（每日/高）
--
-- 【风险评估等级自动判定】
-- 综合总分=合法性+合理性+可行性+可控性四项评分之和（每项1-10分，满分40分）
-- ≥32分 → LOW低风险
-- 24-31分 → MEDIUM中风险
-- ≤23分 → HIGH高风险


-- ============================================================================
-- 附录二：按月分区的日志表模板（后续月份定期执行）
-- ============================================================================
--
-- 每月1日由DBA执行以下SQL，为下月创建新分区：
--
-- -- 登录日志：新增下一个月的分区
-- ALTER TABLE sys_login_log ADD PARTITION (
--     PARTITION p202607 VALUES LESS THAN (TO_DAYS('2026-08-01'))
-- );
--
-- -- 操作日志：新增下一个月的分区
-- ALTER TABLE sys_operation_log ADD PARTITION (
--     PARTITION p202607 VALUES LESS THAN (TO_DAYS('2026-08-01'))
-- );
--
-- 注意事项：
-- 1. 分区维护脚本建议通过MySQL Event Scheduler定时执行
-- 2. 日志保留3年，超过3年的历史分区可归档至备份服务器后删除
-- 3. 分区删除示例：ALTER TABLE sys_login_log DROP PARTITION p202306;
-- 4. p_future分区作为兜底分区，捕获超出已定义范围的数据（需定期检查是否有数据落入该分区）
-- 5. 建议设置cron/MySQL Event每月自动检查并创建下月分区

-- ============================================================================
-- 脚本结束
-- 总计：建库1个 + 建表40张 + 演示INSERT数据80条
-- 覆盖七大子系统全部业务表，严格匹配《新疆油田信访管理系统软件需求说明书》
-- ============================================================================

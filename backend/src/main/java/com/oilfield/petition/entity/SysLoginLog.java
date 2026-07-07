package com.oilfield.petition.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "sys_login_log")
public class SysLoginLog {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "username", nullable = false, length = 50)
    private String username;

    @Column(name = "login_time", nullable = false)
    private LocalDateTime loginTime;

    @Column(name = "login_ip", length = 50)
    private String loginIp;

    @Column(name = "login_device", length = 200)
    private String loginDevice;

    @Column(name = "login_type", nullable = false)
    private Integer loginType;

    @Column(name = "login_result", nullable = false)
    private Integer loginResult;

    @Column(name = "fail_reason", length = 200)
    private String failReason;

    @Column(name = "logout_time")
    private LocalDateTime logoutTime;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
}

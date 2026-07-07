package com.oilfield.petition.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "sys_operation_log")
public class SysOperationLog {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "username", nullable = false, length = 50)
    private String username;

    @Column(name = "real_name", length = 50)
    private String realName;

    @Column(name = "org_id")
    private Long orgId;

    @Column(name = "operation_time", nullable = false)
    private LocalDateTime operationTime;

    @Column(name = "operation_ip", length = 50)
    private String operationIp;

    @Column(name = "operation_module", nullable = false, length = 100)
    private String operationModule;

    @Column(name = "operation_type", nullable = false, length = 50)
    private String operationType;

    @Column(name = "operation_object", length = 200)
    private String operationObject;

    @Column(name = "operation_summary", length = 1000)
    private String operationSummary;

    @Column(name = "request_params", columnDefinition = "text")
    private String requestParams;

    @Column(name = "operation_result", nullable = false)
    private Integer operationResult;

    @Column(name = "error_message", columnDefinition = "text")
    private String errorMessage;

    @Column(name = "cost_time")
    private Integer costTime;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
}

package com.oilfield.petition.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "sys_api_call_log")
public class SysApiCallLog {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "caller_system", nullable = false, length = 100)
    private String callerSystem;

    @Column(name = "api_name", nullable = false, length = 200)
    private String apiName;

    @Column(name = "api_method", nullable = false, length = 10)
    private String apiMethod;

    @Column(name = "call_time", nullable = false)
    private LocalDateTime callTime;

    @Column(name = "request_params", columnDefinition = "text")
    private String requestParams;

    @Column(name = "response_code", length = 10)
    private String responseCode;

    @Column(name = "response_body", columnDefinition = "text")
    private String responseBody;

    @Column(name = "cost_time")
    private Integer costTime;

    @Column(name = "call_result", nullable = false)
    private Integer callResult;

    @Column(name = "error_message", columnDefinition = "text")
    private String errorMessage;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
}

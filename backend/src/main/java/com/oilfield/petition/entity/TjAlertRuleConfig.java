package com.oilfield.petition.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tj_alert_rule_config")
public class TjAlertRuleConfig {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "rule_code", nullable = false, length = 20)
    private String ruleCode;

    @Column(name = "rule_name", nullable = false, length = 200)
    private String ruleName;

    @Column(name = "alert_level", nullable = false, length = 10)
    private String alertLevel;

    @Column(name = "check_frequency", nullable = false, length = 20)
    private String checkFrequency;

    @Column(name = "rule_expression", nullable = false, columnDefinition = "text")
    private String ruleExpression;

    @Column(name = "rule_description", columnDefinition = "text")
    private String ruleDescription;

    @Column(name = "is_enabled", nullable = false)
    private Integer isEnabled = 1;

    @Column(name = "notify_targets", length = 500)
    private String notifyTargets;

    @Column(name = "last_execute_time")
    private LocalDateTime lastExecuteTime;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel = 0;
}

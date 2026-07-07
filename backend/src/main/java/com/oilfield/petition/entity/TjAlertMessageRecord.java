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
@Table(name = "tj_alert_message_record")
public class TjAlertMessageRecord {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "alert_code", nullable = false, length = 30)
    private String alertCode;

    @Column(name = "rule_code", nullable = false, length = 20)
    private String ruleCode;

    @Column(name = "alert_level", nullable = false, length = 10)
    private String alertLevel;

    @Column(name = "alert_title", nullable = false, length = 200)
    private String alertTitle;

    @Column(name = "alert_content", nullable = false, columnDefinition = "text")
    private String alertContent;

    @Column(name = "related_petition_ids", length = 500)
    private String relatedPetitionIds;

    @Column(name = "related_org_id")
    private Long relatedOrgId;

    @Column(name = "alert_time", nullable = false)
    private LocalDateTime alertTime;

    @Column(name = "notified_users", length = 500)
    private String notifiedUsers;

    @Column(name = "notify_channel", length = 50)
    private String notifyChannel;

    @Column(name = "handle_status", nullable = false, length = 20)
    private String handleStatus = "PENDING";

    @Column(name = "handle_by")
    private Long handleBy;

    @Column(name = "handle_time")
    private LocalDateTime handleTime;

    @Column(name = "handle_remark", columnDefinition = "text")
    private String handleRemark;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel = 0;
}

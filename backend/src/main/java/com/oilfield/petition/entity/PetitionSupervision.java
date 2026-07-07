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
@Table(name = "petition_supervision")
public class PetitionSupervision {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "supervision_code", nullable = false, length = 30)
    private String supervisionCode;
    @Column(name = "petition_id", nullable = false)
    private Long petitionId;
    @Column(name = "dispatch_id")
    private Long dispatchId;
    @Column(name = "trigger_type", nullable = false, length = 10)
    private String triggerType;
    @Column(name = "trigger_detail", columnDefinition = "text")
    private String triggerDetail;
    @Column(name = "supervised_org_id", nullable = false)
    private Long supervisedOrgId;
    @Column(name = "supervised_org_name", nullable = false, length = 100)
    private String supervisedOrgName;
    @Column(name = "supervision_reason", nullable = false, columnDefinition = "text")
    private String supervisionReason;
    @Column(name = "supervision_requirement", nullable = false, columnDefinition = "text")
    private String supervisionRequirement;
    @Column(name = "feedback_deadline", nullable = false)
    private LocalDateTime feedbackDeadline;
    @Column(name = "feedback_content", columnDefinition = "text")
    private String feedbackContent;
    @Column(name = "feedback_time")
    private LocalDateTime feedbackTime;
    @Column(name = "feedback_by")
    private Long feedbackBy;
    @Column(name = "status", nullable = false, length = 30)
    private String status;
    @Column(name = "issued_by", nullable = false)
    private Long issuedBy;
    @Column(name = "issued_time", nullable = false)
    private LocalDateTime issuedTime;
    @Column(name = "close_time")
    private LocalDateTime closeTime;
    @Column(name = "is_del", nullable = false)
    private Integer isDel;
    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
}

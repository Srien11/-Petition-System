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
@Table(name = "qz_online_petition")
public class QzOnlinePetition {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "petition_id")
    private Long petitionId;

    @Column(name = "submit_mode", nullable = false, length = 20)
    private String submitMode;

    @Column(name = "petitioner_name", nullable = false, length = 50)
    private String petitionerName;

    @Column(name = "petitioner_phone", nullable = false, length = 100)
    private String petitionerPhone;

    @Column(name = "petitioner_id_card", length = 100)
    private String petitionerIdCard;

    @Column(name = "petitioner_employee_no", length = 32)
    private String petitionerEmployeeNo;

    @Column(name = "petitioner_org_id")
    private Long petitionerOrgId;

    @Column(name = "petitioner_org_name", length = 100)
    private String petitionerOrgName;

    @Column(name = "appeal_category_level1", length = 50)
    private String appealCategoryLevel1;

    @Column(name = "appeal_category_level2", length = 50)
    private String appealCategoryLevel2;

    @Column(name = "appeal_category_level3", length = 50)
    private String appealCategoryLevel3;

    @Column(name = "involved_org_ids", length = 500)
    private String involvedOrgIds;

    @Column(name = "appeal_content", nullable = false, columnDefinition = "text")
    private String appealContent;

    @Column(name = "attachment_count")
    private Integer attachmentCount = 0;

    @Column(name = "feedback_message", columnDefinition = "text")
    private String feedbackMessage;

    @Column(name = "sms_notified", nullable = false)
    private Integer smsNotified = 0;

    @Column(name = "review_status", nullable = false, length = 20)
    private String reviewStatus = "PENDING";

    @Column(name = "review_by")
    private Long reviewBy;

    @Column(name = "review_time")
    private LocalDateTime reviewTime;

    @Column(name = "review_opinion", length = 500)
    private String reviewOpinion;

    @Column(name = "reject_reason", length = 500)
    private String rejectReason;

    @Column(name = "submit_ip", length = 50)
    private String submitIp;

    @Column(name = "submit_time")
    private LocalDateTime submitTime;

    @Column(name = "user_id")
    private Long userId;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel = 0;
}

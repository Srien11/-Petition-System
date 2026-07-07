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
@Table(name = "petition_final_feedback")
public class PetitionFinalFeedback {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "petition_id", nullable = false)
    private Long petitionId;
    @Column(name = "dispatch_id")
    private Long dispatchId;
    @Column(name = "feedback_content", nullable = false, columnDefinition = "text")
    private String feedbackContent;
    @Column(name = "reply_to_petitioner", nullable = false, columnDefinition = "text")
    private String replyToPetitioner;
    @Column(name = "is_appease", nullable = false, length = 20)
    private String isAppease;
    @Column(name = "is_appease_note", length = 500)
    private String isAppeaseNote;
    @Column(name = "evidence_attachment_ids", length = 500)
    private String evidenceAttachmentIds;
    @Column(name = "internal_review_status", length = 20)
    private String internalReviewStatus;
    @Column(name = "internal_review_by")
    private Long internalReviewBy;
    @Column(name = "internal_review_time")
    private LocalDateTime internalReviewTime;
    @Column(name = "internal_review_opinion", length = 500)
    private String internalReviewOpinion;
    @Column(name = "internal_reject_reason", length = 500)
    private String internalRejectReason;
    @Column(name = "final_review_status", length = 20)
    private String finalReviewStatus;
    @Column(name = "final_review_by")
    private Long finalReviewBy;
    @Column(name = "final_review_time")
    private LocalDateTime finalReviewTime;
    @Column(name = "final_review_opinion", length = 500)
    private String finalReviewOpinion;
    @Column(name = "final_reject_reason", length = 500)
    private String finalRejectReason;
    @Column(name = "feedback_by", nullable = false)
    private Long feedbackBy;
    @Column(name = "feedback_time", nullable = false)
    private LocalDateTime feedbackTime;
    @Column(name = "feedback_org_id")
    private Long feedbackOrgId;
    @Column(name = "is_del", nullable = false)
    private Integer isDel;
    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
}

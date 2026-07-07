package com.oilfield.petition.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "zx_stability_risk_assessment")
public class ZxStabilityRiskAssessment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "assessment_code", nullable = false, length = 30)
    private String assessmentCode;

    @Column(name = "assessment_title", nullable = false, length = 200)
    private String assessmentTitle;

    @Column(name = "assessment_type", nullable = false, length = 50)
    private String assessmentType;

    @Column(name = "assessment_org_id", nullable = false)
    private Long assessmentOrgId;

    @Column(name = "assessment_org_name", nullable = false, length = 100)
    private String assessmentOrgName;

    @Column(name = "assessment_content", nullable = false, columnDefinition = "text")
    private String assessmentContent;

    @Column(name = "score_legality", nullable = false)
    private Integer scoreLegality;

    @Column(name = "score_legality_remark", columnDefinition = "text")
    private String scoreLegalityRemark;

    @Column(name = "score_rationality", nullable = false)
    private Integer scoreRationality;

    @Column(name = "score_rationality_remark", columnDefinition = "text")
    private String scoreRationalityRemark;

    @Column(name = "score_feasibility", nullable = false)
    private Integer scoreFeasibility;

    @Column(name = "score_feasibility_remark", columnDefinition = "text")
    private String scoreFeasibilityRemark;

    @Column(name = "score_controllability", nullable = false)
    private Integer scoreControllability;

    @Column(name = "score_controllability_remark", columnDefinition = "text")
    private String scoreControllabilityRemark;

    @Column(name = "total_score", nullable = false)
    private Integer totalScore;

    @Column(name = "risk_level", nullable = false, length = 10)
    private String riskLevel;

    @Column(name = "dept_review_status", length = 20)
    private String deptReviewStatus;

    @Column(name = "dept_review_by")
    private Long deptReviewBy;

    @Column(name = "dept_review_time")
    private LocalDateTime deptReviewTime;

    @Column(name = "dept_review_opinion", columnDefinition = "text")
    private String deptReviewOpinion;

    @Column(name = "petition_review_status", length = 20)
    private String petitionReviewStatus;

    @Column(name = "petition_review_by")
    private Long petitionReviewBy;

    @Column(name = "petition_review_time")
    private LocalDateTime petitionReviewTime;

    @Column(name = "petition_review_opinion", columnDefinition = "text")
    private String petitionReviewOpinion;

    @Column(name = "leader_approve_status", length = 20)
    private String leaderApproveStatus;

    @Column(name = "leader_approve_by")
    private Long leaderApproveBy;

    @Column(name = "leader_approve_time")
    private LocalDateTime leaderApproveTime;

    @Column(name = "leader_approve_opinion", columnDefinition = "text")
    private String leaderApproveOpinion;

    @Column(name = "assessment_by", nullable = false)
    private Long assessmentBy;

    @Column(name = "assessment_date", nullable = false)
    private LocalDate assessmentDate;

    @Column(name = "status", nullable = false, length = 30)
    private String status;

    @CreationTimestamp
    @Column(name = "create_time", nullable = false, updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time", nullable = false)
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel;
}

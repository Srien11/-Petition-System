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
@Table(name = "petition_dispatch")
public class PetitionDispatch {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "petition_id", nullable = false)
    private Long petitionId;
    @Column(name = "dispatch_type", nullable = false, length = 20)
    private String dispatchType;
    @Column(name = "from_org_id", nullable = false)
    private Long fromOrgId;
    @Column(name = "from_user_id", nullable = false)
    private Long fromUserId;
    @Column(name = "to_org_id", nullable = false)
    private Long toOrgId;
    @Column(name = "to_org_name", nullable = false, length = 100)
    private String toOrgName;
    @Column(name = "dispatch_opinion", nullable = false, columnDefinition = "text")
    private String dispatchOpinion;
    @Column(name = "report_leader_name", length = 50)
    private String reportLeaderName;
    @Column(name = "report_leader_opinion", columnDefinition = "text")
    private String reportLeaderOpinion;
    @Column(name = "report_leader_date")
    private LocalDateTime reportLeaderDate;
    @Column(name = "deadline_days", nullable = false)
    private Integer deadlineDays;
    @Column(name = "deadline_date", nullable = false)
    private LocalDateTime deadlineDate;
    @Column(name = "is_received", nullable = false)
    private Integer isReceived;
    @Column(name = "received_by")
    private Long receivedBy;
    @Column(name = "received_time")
    private LocalDateTime receivedTime;
    @Column(name = "is_returned", nullable = false)
    private Integer isReturned;
    @Column(name = "return_reason", length = 500)
    private String returnReason;
    @Column(name = "return_apply_time")
    private LocalDateTime returnApplyTime;
    @Column(name = "return_approve_by")
    private Long returnApproveBy;
    @Column(name = "return_approve_time")
    private LocalDateTime returnApproveTime;
    @Column(name = "return_approve_opinion", length = 500)
    private String returnApproveOpinion;
    @Column(name = "is_extended", nullable = false)
    private Integer isExtended;
    @Column(name = "extension_apply_reason", length = 500)
    private String extensionApplyReason;
    @Column(name = "extension_days")
    private Integer extensionDays;
    @Column(name = "extension_apply_time")
    private LocalDateTime extensionApplyTime;
    @Column(name = "extension_approve_by")
    private Long extensionApproveBy;
    @Column(name = "extension_approve_time")
    private LocalDateTime extensionApproveTime;
    @Column(name = "extension_approve_opinion", length = 500)
    private String extensionApproveOpinion;
    @Column(name = "new_deadline_date")
    private LocalDateTime newDeadlineDate;
    @Column(name = "assist_org_names", length = 500)
    private String assistOrgNames;
    @Column(name = "status", nullable = false, length = 30)
    private String status;
    @Column(name = "is_del", nullable = false)
    private Integer isDel;
    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
}

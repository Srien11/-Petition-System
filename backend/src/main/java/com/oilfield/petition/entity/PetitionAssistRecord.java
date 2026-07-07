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
@Table(name = "petition_assist_record")
public class PetitionAssistRecord {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "dispatch_id", nullable = false)
    private Long dispatchId;
    @Column(name = "petition_id", nullable = false)
    private Long petitionId;
    @Column(name = "assist_org_id", nullable = false)
    private Long assistOrgId;
    @Column(name = "assist_org_name", nullable = false, length = 100)
    private String assistOrgName;
    @Column(name = "assist_requirement", nullable = false, columnDefinition = "text")
    private String assistRequirement;
    @Column(name = "deadline_days", nullable = false)
    private Integer deadlineDays;
    @Column(name = "deadline_date", nullable = false)
    private LocalDateTime deadlineDate;
    @Column(name = "reply_content", columnDefinition = "text")
    private String replyContent;
    @Column(name = "reply_time")
    private LocalDateTime replyTime;
    @Column(name = "reply_by")
    private Long replyBy;
    @Column(name = "is_overtime", nullable = false)
    private Integer isOvertime;
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

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
@Table(name = "petition_extension_return")
public class PetitionExtensionReturn {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "petition_id", nullable = false)
    private Long petitionId;
    @Column(name = "dispatch_id")
    private Long dispatchId;
    @Column(name = "record_type", nullable = false, length = 20)
    private String recordType;
    @Column(name = "apply_reason", nullable = false, columnDefinition = "text")
    private String applyReason;
    @Column(name = "apply_days")
    private Integer applyDays;
    @Column(name = "apply_by", nullable = false)
    private Long applyBy;
    @Column(name = "apply_time", nullable = false)
    private LocalDateTime applyTime;
    @Column(name = "approve_status", nullable = false, length = 20)
    private String approveStatus;
    @Column(name = "approve_by")
    private Long approveBy;
    @Column(name = "approve_time")
    private LocalDateTime approveTime;
    @Column(name = "approve_opinion", length = 500)
    private String approveOpinion;
    @Column(name = "new_deadline_date")
    private LocalDateTime newDeadlineDate;
    @Column(name = "is_del", nullable = false)
    private Integer isDel;
    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
}

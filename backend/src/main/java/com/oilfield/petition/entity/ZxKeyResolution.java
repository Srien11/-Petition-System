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
@Table(name = "zx_key_resolution")
public class ZxKeyResolution {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "resolution_code", nullable = false, length = 30)
    private String resolutionCode;

    @Column(name = "case_name", nullable = false, length = 200)
    private String caseName;

    @Column(name = "related_petition_ids", length = 500)
    private String relatedPetitionIds;

    @Column(name = "package_leader", nullable = false, length = 50)
    private String packageLeader;

    @Column(name = "package_leader_title", length = 100)
    private String packageLeaderTitle;

    @Column(name = "responsible_org_ids", nullable = false, length = 500)
    private String responsibleOrgIds;

    @Column(name = "responsible_org_names", nullable = false, length = 500)
    private String responsibleOrgNames;

    @Column(name = "resolution_plan", nullable = false, columnDefinition = "text")
    private String resolutionPlan;

    @Column(name = "progress_percent")
    private Integer progressPercent;

    @Column(name = "estimated_resolution_date")
    private LocalDate estimatedResolutionDate;

    @Column(name = "actual_resolution_date")
    private LocalDate actualResolutionDate;

    @Column(name = "resolution_result", length = 20)
    private String resolutionResult;

    @Column(name = "follow_up_measure", columnDefinition = "text")
    private String followUpMeasure;

    @Column(name = "timeline_log", columnDefinition = "text")
    private String timelineLog;

    @Column(name = "current_status", nullable = false, length = 30)
    private String currentStatus;

    @Column(name = "create_by", nullable = false)
    private Long createBy;

    @CreationTimestamp
    @Column(name = "create_time", nullable = false, updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time", nullable = false)
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel;
}

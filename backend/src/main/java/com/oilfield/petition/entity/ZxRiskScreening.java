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
@Table(name = "zx_risk_screening")
public class ZxRiskScreening {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "screening_code", nullable = false, length = 30)
    private String screeningCode;

    @Column(name = "screening_date", nullable = false)
    private LocalDate screeningDate;

    @Column(name = "screening_org_id", nullable = false)
    private Long screeningOrgId;

    @Column(name = "screening_org_name", nullable = false, length = 100)
    private String screeningOrgName;

    @Column(name = "risk_type_level1", nullable = false, length = 50)
    private String riskTypeLevel1;

    @Column(name = "risk_type_level2", length = 50)
    private String riskTypeLevel2;

    @Column(name = "risk_type_level3", length = 50)
    private String riskTypeLevel3;

    @Column(name = "involved_persons", nullable = false, length = 500)
    private String involvedPersons;

    @Column(name = "involved_count")
    private Integer involvedCount;

    @Column(name = "risk_description", nullable = false, columnDefinition = "text")
    private String riskDescription;

    @Column(name = "risk_level", nullable = false, length = 10)
    private String riskLevel;

    @Column(name = "control_person", nullable = false, length = 50)
    private String controlPerson;

    @Column(name = "control_measure", nullable = false, columnDefinition = "text")
    private String controlMeasure;

    @Column(name = "resolution_deadline")
    private LocalDate resolutionDeadline;

    @Column(name = "current_status", nullable = false, length = 20)
    private String currentStatus;

    @Column(name = "status_update_time")
    private LocalDateTime statusUpdateTime;

    @Column(name = "register_by", nullable = false)
    private Long registerBy;

    @CreationTimestamp
    @Column(name = "create_time", nullable = false, updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time", nullable = false)
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel;
}

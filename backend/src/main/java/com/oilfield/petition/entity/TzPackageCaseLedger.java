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
@Table(name = "tz_package_case_ledger")
public class TzPackageCaseLedger {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "case_name", nullable = false, length = 200)
    private String caseName;

    @Column(name = "case_type", nullable = false, length = 50)
    private String caseType;

    @Column(name = "package_year", nullable = false, length = 4)
    private String packageYear;

    @Column(name = "package_level", nullable = false, length = 20)
    private String packageLevel;

    @Column(name = "package_leader", nullable = false, length = 50)
    private String packageLeader;

    @Column(name = "package_leader_title", nullable = false, length = 100)
    private String packageLeaderTitle;

    @Column(name = "responsible_org", nullable = false, length = 200)
    private String responsibleOrg;

    @Column(name = "contact_person", length = 50)
    private String contactPerson;

    @Column(name = "contact_phone", length = 100)
    private String contactPhone;

    @Column(name = "main_issue", nullable = false, columnDefinition = "text")
    private String mainIssue;

    @Column(name = "resolution_plan", nullable = false, columnDefinition = "text")
    private String resolutionPlan;

    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @Column(name = "end_date")
    private LocalDate endDate;

    @Column(name = "progress_description", columnDefinition = "text")
    private String progressDescription;

    @Column(name = "status", nullable = false, length = 20)
    private String status;

    @Column(name = "register_by", nullable = false)
    private Long registerBy;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel;
}

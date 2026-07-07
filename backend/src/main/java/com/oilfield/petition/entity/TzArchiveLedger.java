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
@Table(name = "tz_archive_ledger")
public class TzArchiveLedger {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "archive_code", nullable = false, length = 30)
    private String archiveCode;

    @Column(name = "petition_id")
    private Long petitionId;

    @Column(name = "petition_code", length = 30)
    private String petitionCode;

    @Column(name = "archive_type", nullable = false, length = 50)
    private String archiveType;

    @Column(name = "archive_box_no", length = 50)
    private String archiveBoxNo;

    @Column(name = "archive_location", length = 200)
    private String archiveLocation;

    @Column(name = "archive_date", nullable = false)
    private LocalDate archiveDate;

    @Column(name = "retention_period", nullable = false, length = 20)
    private String retentionPeriod;

    @Column(name = "destroy_date")
    private LocalDate destroyDate;

    @Column(name = "archive_summary", columnDefinition = "text")
    private String archiveSummary;

    @Column(name = "electronic_path", length = 500)
    private String electronicPath;

    @Column(name = "is_electronic", nullable = false)
    private Integer isElectronic;

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

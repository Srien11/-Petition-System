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
@Table(name = "tz_historical_migration_record")
public class TzHistoricalMigrationRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "migration_batch", nullable = false, length = 50)
    private String migrationBatch;

    @Column(name = "migration_type", nullable = false, length = 50)
    private String migrationType;

    @Column(name = "source_file_path", length = 500)
    private String sourceFilePath;

    @Column(name = "source_description", columnDefinition = "text")
    private String sourceDescription;

    @Column(name = "total_rows", nullable = false)
    private Integer totalRows;

    @Column(name = "success_rows", nullable = false)
    private Integer successRows;

    @Column(name = "failed_rows", nullable = false)
    private Integer failedRows;

    @Column(name = "error_report_path", length = 500)
    private String errorReportPath;

    @Column(name = "target_table", nullable = false, length = 100)
    private String targetTable;

    @Column(name = "migration_start_time", nullable = false)
    private LocalDateTime migrationStartTime;

    @Column(name = "migration_end_time")
    private LocalDateTime migrationEndTime;

    @Column(name = "migration_status", nullable = false, length = 20)
    private String migrationStatus;

    @Column(name = "verify_result", columnDefinition = "text")
    private String verifyResult;

    @Column(name = "migration_by", nullable = false)
    private Long migrationBy;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel;
}

package com.oilfield.petition.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tj_statistics_indicator")
public class TjStatisticsIndicator {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "stat_date", nullable = false)
    private LocalDate statDate;

    @Column(name = "stat_dimension", nullable = false, length = 50)
    private String statDimension;

    @Column(name = "dimension_value", nullable = false, length = 100)
    private String dimensionValue;

    @Column(name = "total_count", nullable = false)
    private Integer totalCount = 0;

    @Column(name = "new_count", nullable = false)
    private Integer newCount = 0;

    @Column(name = "completed_count", nullable = false)
    private Integer completedCount = 0;

    @Column(name = "in_progress_count", nullable = false)
    private Integer inProgressCount = 0;

    @Column(name = "overdue_count", nullable = false)
    private Integer overdueCount = 0;

    @Column(name = "collective_count", nullable = false)
    private Integer collectiveCount = 0;

    @Column(name = "duplicate_count", nullable = false)
    private Integer duplicateCount = 0;

    @Column(name = "avg_process_days", precision = 6, scale = 2)
    private BigDecimal avgProcessDays;

    @Column(name = "satisfaction_avg", precision = 3, scale = 2)
    private BigDecimal satisfactionAvg;

    @Column(name = "last_year_count")
    private Integer lastYearCount;

    @Column(name = "yoy_change_pct", precision = 6, scale = 2)
    private BigDecimal yoyChangePct;

    @Column(name = "last_period_count")
    private Integer lastPeriodCount;

    @Column(name = "qoq_change_pct", precision = 6, scale = 2)
    private BigDecimal qoqChangePct;

    @Column(name = "stat_level", nullable = false, length = 20)
    private String statLevel = "DAILY";

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
}

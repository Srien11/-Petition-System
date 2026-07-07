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
@Table(name = "tz_historical_data_ledger")
public class TzHistoricalDataLedger {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "data_title", nullable = false, length = 200)
    private String dataTitle;

    @Column(name = "data_type", nullable = false, length = 50)
    private String dataType;

    @Column(name = "data_period_start")
    private LocalDate dataPeriodStart;

    @Column(name = "data_period_end")
    private LocalDate dataPeriodEnd;

    @Column(name = "data_description", columnDefinition = "text")
    private String dataDescription;

    @Column(name = "original_format", length = 50)
    private String originalFormat;

    @Column(name = "electronic_path", length = 500)
    private String electronicPath;

    @Column(name = "physical_location", length = 200)
    private String physicalLocation;

    @Column(name = "record_count")
    private Integer recordCount;

    @Column(name = "is_digitized", nullable = false)
    private Integer isDigitized;

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

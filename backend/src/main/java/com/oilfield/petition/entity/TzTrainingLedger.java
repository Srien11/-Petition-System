package com.oilfield.petition.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tz_training_ledger")
public class TzTrainingLedger {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "training_title", nullable = false, length = 200)
    private String trainingTitle;

    @Column(name = "training_type", nullable = false, length = 50)
    private String trainingType;

    @Column(name = "training_date", nullable = false)
    private LocalDate trainingDate;

    @Column(name = "training_duration", precision = 4, scale = 1)
    private BigDecimal trainingDuration;

    @Column(name = "training_location", length = 200)
    private String trainingLocation;

    @Column(name = "trainer_name", nullable = false, length = 50)
    private String trainerName;

    @Column(name = "trainer_title", length = 100)
    private String trainerTitle;

    @Column(name = "trainee_count")
    private Integer traineeCount;

    @Column(name = "trainee_scope", length = 200)
    private String traineeScope;

    @Column(name = "training_content", columnDefinition = "text")
    private String trainingContent;

    @Column(name = "training_material_path", length = 500)
    private String trainingMaterialPath;

    @Column(name = "assessment_result", length = 100)
    private String assessmentResult;

    @Column(name = "satisfaction_score", precision = 3, scale = 1)
    private BigDecimal satisfactionScore;

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

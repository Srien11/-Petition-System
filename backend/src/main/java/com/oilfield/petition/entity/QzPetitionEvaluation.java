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
@Table(name = "qz_petition_evaluation")
public class QzPetitionEvaluation {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "petition_id", nullable = false)
    private Long petitionId;

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "satisfaction_score", nullable = false)
    private Integer satisfactionScore;

    @Column(name = "is_timely_satisfied", nullable = false)
    private Integer isTimelySatisfied;

    @Column(name = "problem_resolved", nullable = false, length = 20)
    private String problemResolved;

    @Column(name = "suggestion", length = 500)
    private String suggestion;

    @Column(name = "evaluate_time", nullable = false)
    private LocalDateTime evaluateTime;

    @Column(name = "evaluation_source", length = 20)
    private String evaluationSource = "WEB";

    @Column(name = "is_low_score", nullable = false)
    private Integer isLowScore = 0;

    @Column(name = "follow_up_note", columnDefinition = "text")
    private String followUpNote;

    @Column(name = "follow_up_time")
    private LocalDateTime followUpTime;

    @Column(name = "is_valid", nullable = false)
    private Integer isValid = 1;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel = 0;
}

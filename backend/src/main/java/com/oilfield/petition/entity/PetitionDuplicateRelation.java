package com.oilfield.petition.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "petition_duplicate_relation")
public class PetitionDuplicateRelation {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "petition_id", nullable = false)
    private Long petitionId;
    @Column(name = "original_petition_id", nullable = false)
    private Long originalPetitionId;
    @Column(name = "match_rule", nullable = false, length = 50)
    private String matchRule;
    @Column(name = "match_score", nullable = false, precision = 5, scale = 2)
    private BigDecimal matchScore;
    @Column(name = "confirm_by")
    private Long confirmBy;
    @Column(name = "confirm_time")
    private LocalDateTime confirmTime;
    @Column(name = "confirm_status", length = 20)
    private String confirmStatus;
    @Column(name = "is_del", nullable = false)
    private Integer isDel;
    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
}

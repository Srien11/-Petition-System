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
@Table(name = "zx_special_group_control")
public class ZxSpecialGroupControl {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "group_name", nullable = false, length = 100)
    private String groupName;

    @Column(name = "group_type", nullable = false, length = 50)
    private String groupType;

    @Column(name = "group_size")
    private Integer groupSize;

    @Column(name = "key_person_name", nullable = false, length = 50)
    private String keyPersonName;

    @Column(name = "key_person_id_card", length = 100)
    private String keyPersonIdCard;

    @Column(name = "key_person_phone", length = 100)
    private String keyPersonPhone;

    @Column(name = "key_person_address", length = 200)
    private String keyPersonAddress;

    @Column(name = "core_demand", nullable = false, columnDefinition = "text")
    private String coreDemand;

    @Column(name = "risk_assessment", nullable = false, length = 10)
    private String riskAssessment;

    @Column(name = "control_measure", nullable = false, columnDefinition = "text")
    private String controlMeasure;

    @Column(name = "control_person", nullable = false, length = 50)
    private String controlPerson;

    @Column(name = "control_person_phone", length = 100)
    private String controlPersonPhone;

    @Column(name = "recent_activity", columnDefinition = "text")
    private String recentActivity;

    @Column(name = "psychological_note", columnDefinition = "text")
    private String psychologicalNote;

    @Column(name = "last_update_time", nullable = false)
    private LocalDateTime lastUpdateTime;

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

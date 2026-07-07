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
@Table(name = "zx_leader_reception")
public class ZxLeaderReception {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "reception_code", nullable = false, length = 30)
    private String receptionCode;

    @Column(name = "leader_name", nullable = false, length = 50)
    private String leaderName;

    @Column(name = "leader_title", nullable = false, length = 100)
    private String leaderTitle;

    @Column(name = "reception_type", nullable = false, length = 20)
    private String receptionType;

    @Column(name = "reception_date", nullable = false)
    private LocalDateTime receptionDate;

    @Column(name = "reception_location", nullable = false, length = 200)
    private String receptionLocation;

    @Column(name = "visitor_name", nullable = false, length = 50)
    private String visitorName;

    @Column(name = "visitor_count")
    private Integer visitorCount;

    @Column(name = "visitor_contact", length = 100)
    private String visitorContact;

    @Column(name = "visit_subject", nullable = false, length = 200)
    private String visitSubject;

    @Column(name = "visit_detail", columnDefinition = "text")
    private String visitDetail;

    @Column(name = "leader_opinion", nullable = false, columnDefinition = "text")
    private String leaderOpinion;

    @Column(name = "assigned_dept", length = 200)
    private String assignedDept;

    @Column(name = "assigned_deadline")
    private LocalDate assignedDeadline;

    @Column(name = "process_result", columnDefinition = "text")
    private String processResult;

    @Column(name = "process_date")
    private LocalDate processDate;

    @Column(name = "petitioner_satisfaction", length = 20)
    private String petitionerSatisfaction;

    @Column(name = "related_petition_id")
    private Long relatedPetitionId;

    @Column(name = "accompany_persons", length = 200)
    private String accompanyPersons;

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

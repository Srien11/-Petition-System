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
@Table(name = "tz_personnel_ledger")
public class TzPersonnelLedger {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "person_name", nullable = false, length = 50)
    private String personName;

    @Column(name = "employee_no", length = 32)
    private String employeeNo;

    @Column(name = "id_card", length = 100)
    private String idCard;

    @Column(name = "phone", length = 100)
    private String phone;

    @Column(name = "org_name", nullable = false, length = 100)
    private String orgName;

    @Column(name = "position", length = 100)
    private String position;

    @Column(name = "personnel_type", nullable = false, length = 50)
    private String personnelType;

    @Column(name = "duty_description", columnDefinition = "text")
    private String dutyDescription;

    @Column(name = "training_records", columnDefinition = "text")
    private String trainingRecords;

    @Column(name = "certificate_info", length = 200)
    private String certificateInfo;

    @Column(name = "contact_phone", length = 100)
    private String contactPhone;

    @Column(name = "contact_email", length = 100)
    private String contactEmail;

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

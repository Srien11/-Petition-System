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
@Table(name = "sys_organization")
public class SysOrganization {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "org_code", nullable = false, length = 32)
    private String orgCode;

    @Column(name = "org_name", nullable = false, length = 100)
    private String orgName;

    @Column(name = "org_level", nullable = false)
    private Integer orgLevel;

    @Column(name = "parent_id")
    private Long parentId;

    @Column(name = "org_path", length = 500)
    private String orgPath;

    @Column(name = "manager_name", length = 50)
    private String managerName;

    @Column(name = "contact_phone", length = 20)
    private String contactPhone;

    @Column(name = "sort_order")
    private Integer sortOrder;

    @Column(name = "status")
    private Integer status;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel;
}

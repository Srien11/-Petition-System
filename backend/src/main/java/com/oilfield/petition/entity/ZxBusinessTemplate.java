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
@Table(name = "zx_business_template")
public class ZxBusinessTemplate {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "template_name", nullable = false, length = 200)
    private String templateName;

    @Column(name = "template_type", nullable = false, length = 50)
    private String templateType;

    @Column(name = "template_content", nullable = false, columnDefinition = "text")
    private String templateContent;

    @Column(name = "usage_count")
    private Integer usageCount;

    @Column(name = "is_default", nullable = false)
    private Integer isDefault;

    @Column(name = "upload_by")
    private Long uploadBy;

    @CreationTimestamp
    @Column(name = "create_time", nullable = false, updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time", nullable = false)
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel;
}

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
@Table(name = "qz_policy_document")
public class QzPolicyDocument {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "doc_title", nullable = false, length = 200)
    private String docTitle;

    @Column(name = "doc_type", nullable = false, length = 50)
    private String docType;

    @Column(name = "doc_content", nullable = false, columnDefinition = "text")
    private String docContent;

    @Column(name = "doc_summary", length = 500)
    private String docSummary;

    @Column(name = "keywords", length = 500)
    private String keywords;

    @Column(name = "is_published", nullable = false)
    private Integer isPublished = 0;

    @Column(name = "publish_date")
    private LocalDateTime publishDate;

    @Column(name = "view_count")
    private Integer viewCount = 0;

    @Column(name = "sort_order")
    private Integer sortOrder = 0;

    @Column(name = "publish_by")
    private Long publishBy;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel = 0;
}

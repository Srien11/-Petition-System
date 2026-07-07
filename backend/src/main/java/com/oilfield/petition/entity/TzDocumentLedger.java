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
@Table(name = "tz_document_ledger")
public class TzDocumentLedger {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "doc_title", nullable = false, length = 200)
    private String docTitle;

    @Column(name = "doc_type", nullable = false, length = 50)
    private String docType;

    @Column(name = "doc_number", length = 100)
    private String docNumber;

    @Column(name = "issue_date", nullable = false)
    private LocalDate issueDate;

    @Column(name = "issue_org", length = 200)
    private String issueOrg;

    @Column(name = "effective_date")
    private LocalDate effectiveDate;

    @Column(name = "expire_date")
    private LocalDate expireDate;

    @Column(name = "doc_summary", columnDefinition = "text")
    private String docSummary;

    @Column(name = "keywords", length = 500)
    private String keywords;

    @Column(name = "attachment_ids", length = 500)
    private String attachmentIds;

    @Column(name = "archive_location", length = 200)
    private String archiveLocation;

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

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
@Table(name = "tz_report_letter_ledger")
public class TzReportLetterLedger {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "letter_title", nullable = false, length = 200)
    private String letterTitle;

    @Column(name = "letter_type", nullable = false, length = 50)
    private String letterType;

    @Column(name = "letter_number", length = 100)
    private String letterNumber;

    @Column(name = "send_date", nullable = false)
    private LocalDate sendDate;

    @Column(name = "sender_org", nullable = false, length = 200)
    private String senderOrg;

    @Column(name = "receiver_org", nullable = false, length = 200)
    private String receiverOrg;

    @Column(name = "related_petition_id")
    private Long relatedPetitionId;

    @Column(name = "letter_summary", columnDefinition = "text")
    private String letterSummary;

    @Column(name = "attachment_ids", length = 500)
    private String attachmentIds;

    @Column(name = "is_replied", nullable = false)
    private Integer isReplied;

    @Column(name = "reply_date")
    private LocalDate replyDate;

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

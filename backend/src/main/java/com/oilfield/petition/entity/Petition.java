package com.oilfield.petition.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "petition")
public class Petition {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "petition_code", nullable = false, length = 30)
    private String petitionCode;
    @Column(name = "petitioner_name", nullable = false, length = 50)
    private String petitionerName;
    @Column(name = "petitioner_id_card", length = 100)
    private String petitionerIdCard;
    @Column(name = "petitioner_phone", length = 100)
    private String petitionerPhone;
    @Column(name = "petitioner_address", length = 200)
    private String petitionerAddress;
    @Column(name = "petitioner_employee_no", length = 32)
    private String petitionerEmployeeNo;
    @Column(name = "channel_code", nullable = false, length = 10)
    private String channelCode;
    @Column(name = "visitor_count")
    private Integer visitorCount;
    @Column(name = "is_collective", nullable = false)
    private Integer isCollective;
    @Column(name = "receptionist", length = 50)
    private String receptionist;
    @Column(name = "visit_date")
    private LocalDateTime visitDate;
    @Column(name = "letter_receive_date")
    private LocalDateTime letterReceiveDate;
    @Column(name = "letter_post_code", length = 20)
    private String letterPostCode;
    @Column(name = "call_date")
    private LocalDateTime callDate;
    @Column(name = "caller_number", length = 100)
    private String callerNumber;
    @Column(name = "superior_org", length = 200)
    private String superiorOrg;
    @Column(name = "superior_doc_no", length = 100)
    private String superiorDocNo;
    @Column(name = "superior_date")
    private LocalDateTime superiorDate;
    @Column(name = "leader_name", length = 50)
    private String leaderName;
    @Column(name = "leader_opinion", columnDefinition = "text")
    private String leaderOpinion;
    @Column(name = "leader_date")
    private LocalDateTime leaderDate;
    @Column(name = "appeal_category_level1", length = 50)
    private String appealCategoryLevel1;
    @Column(name = "appeal_category_level2", length = 50)
    private String appealCategoryLevel2;
    @Column(name = "appeal_category_level3", length = 50)
    private String appealCategoryLevel3;
    @Column(name = "involved_org_ids", length = 500)
    private String involvedOrgIds;
    @Column(name = "appeal_content", nullable = false, columnDefinition = "text")
    private String appealContent;
    @Column(name = "keyword_tags", length = 500)
    private String keywordTags;
    @Column(name = "attachment_count")
    private Integer attachmentCount;
    @Column(name = "is_duplicate", nullable = false)
    private Integer isDuplicate;
    @Column(name = "duplicate_petition_id")
    private Long duplicatePetitionId;
    @Column(name = "dup_similarity_name", precision = 5, scale = 2)
    private BigDecimal dupSimilarityName;
    @Column(name = "dup_similarity_id_card", precision = 5, scale = 2)
    private BigDecimal dupSimilarityIdCard;
    @Column(name = "dup_similarity_phone", precision = 5, scale = 2)
    private BigDecimal dupSimilarityPhone;
    @Column(name = "dup_similarity_keyword", precision = 5, scale = 2)
    private BigDecimal dupSimilarityKeyword;
    @Column(name = "dup_check_detail", columnDefinition = "text")
    private String dupCheckDetail;
    @Column(name = "disposal_type", length = 20)
    private String disposalType;
    @Column(name = "disposal_opinion", columnDefinition = "text")
    private String disposalOpinion;
    @Column(name = "disposal_time")
    private LocalDateTime disposalTime;
    @Column(name = "disposal_by")
    private Long disposalBy;
    @Column(name = "status", nullable = false, length = 30)
    private String status;
    @Column(name = "status_history", columnDefinition = "text")
    private String statusHistory;
    @Column(name = "deadline_date")
    private LocalDateTime deadlineDate;
    @Column(name = "is_overtime", nullable = false)
    private Integer isOvertime;
    @Column(name = "archive_date")
    private LocalDateTime archiveDate;
    @Column(name = "archive_retention", length = 20)
    private String archiveRetention;
    @Column(name = "archive_remind_date")
    private LocalDateTime archiveRemindDate;
    @Column(name = "complete_date")
    private LocalDateTime completeDate;
    @Column(name = "source_flag", length = 20)
    private String sourceFlag;
    @Column(name = "register_by")
    private Long registerBy;
    @Column(name = "register_time", nullable = false)
    private LocalDateTime registerTime;
    @Column(name = "register_org_id")
    private Long registerOrgId;
    @Column(name = "is_del", nullable = false)
    private Integer isDel;
    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
}

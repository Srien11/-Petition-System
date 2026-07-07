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
@Table(name = "petition_process_record")
public class PetitionProcessRecord {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "petition_id", nullable = false)
    private Long petitionId;
    @Column(name = "dispatch_id")
    private Long dispatchId;
    @Column(name = "record_type", nullable = false, length = 30)
    private String recordType;
    @Column(name = "record_content", nullable = false, columnDefinition = "text")
    private String recordContent;
    @Column(name = "record_time", nullable = false)
    private LocalDateTime recordTime;
    @Column(name = "record_by", nullable = false)
    private Long recordBy;
    @Column(name = "record_by_name", nullable = false, length = 50)
    private String recordByName;
    @Column(name = "attachment_ids", length = 500)
    private String attachmentIds;
    @Column(name = "sort_order")
    private Integer sortOrder;
    @Column(name = "is_del", nullable = false)
    private Integer isDel;
    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
}

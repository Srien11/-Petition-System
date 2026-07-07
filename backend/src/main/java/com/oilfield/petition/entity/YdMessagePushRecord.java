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
@Table(name = "yd_message_push_record")
public class YdMessagePushRecord {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "push_type", nullable = false, length = 50)
    private String pushType;

    @Column(name = "push_title", nullable = false, length = 200)
    private String pushTitle;

    @Column(name = "push_content", nullable = false, length = 1000)
    private String pushContent;

    @Column(name = "push_channel", nullable = false, length = 50)
    private String pushChannel;

    @Column(name = "target_user_id", nullable = false)
    private Long targetUserId;

    @Column(name = "target_user_name", length = 50)
    private String targetUserName;

    @Column(name = "related_type", length = 50)
    private String relatedType;

    @Column(name = "related_id")
    private Long relatedId;

    @Column(name = "jump_url", length = 500)
    private String jumpUrl;

    @Column(name = "push_status", nullable = false, length = 20)
    private String pushStatus = "PENDING";

    @Column(name = "push_time")
    private LocalDateTime pushTime;

    @Column(name = "retry_count")
    private Integer retryCount = 0;

    @Column(name = "fail_reason", length = 500)
    private String failReason;

    @Column(name = "is_read", nullable = false)
    private Integer isRead = 0;

    @Column(name = "read_time")
    private LocalDateTime readTime;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel = 0;
}

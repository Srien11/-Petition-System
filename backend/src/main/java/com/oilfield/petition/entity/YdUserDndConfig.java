package com.oilfield.petition.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "yd_user_dnd_config")
public class YdUserDndConfig {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "dnd_enabled", nullable = false)
    private Integer dndEnabled = 0;

    @Column(name = "dnd_start_time")
    private LocalTime dndStartTime;

    @Column(name = "dnd_end_time")
    private LocalTime dndEndTime;

    @Column(name = "dnd_push_types", length = 500)
    private String dndPushTypes;

    @Column(name = "allow_urgent", nullable = false)
    private Integer allowUrgent = 1;

    @Column(name = "preferred_channel", length = 50)
    private String preferredChannel = "ZHANGXINYOU";

    @Column(name = "quiet_weekend", nullable = false)
    private Integer quietWeekend = 0;

    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @Column(name = "is_del", nullable = false)
    private Integer isDel = 0;
}

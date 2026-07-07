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
@Table(name = "attachment")
public class Attachment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "business_type", nullable = false, length = 50)
    private String businessType;
    @Column(name = "business_id", nullable = false)
    private Long businessId;
    @Column(name = "file_name", nullable = false, length = 255)
    private String fileName;
    @Column(name = "file_path", nullable = false, length = 500)
    private String filePath;
    @Column(name = "file_size")
    private Long fileSize;
    @Column(name = "file_type", length = 50)
    private String fileType;
    @Column(name = "file_ext", length = 20)
    private String fileExt;
    @Column(name = "file_md5", length = 64)
    private String fileMd5;
    @Column(name = "upload_by", nullable = false)
    private Long uploadBy;
    @Column(name = "upload_time", nullable = false)
    private LocalDateTime uploadTime;
    @Column(name = "download_count")
    private Integer downloadCount;
    @Column(name = "is_del", nullable = false)
    private Integer isDel;
    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
}

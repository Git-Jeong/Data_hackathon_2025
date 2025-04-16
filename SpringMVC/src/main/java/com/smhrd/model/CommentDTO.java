package com.smhrd.model;

import java.sql.Timestamp;
import lombok.Data;
import lombok.ToString;

@Data // getter, setter
@ToString
public class CommentDTO {
    private int cmt_idx;
    private int cpl_idx;
    private String admin_id;
    private String admin_name;
    private String cmt_content;
    private Timestamp cmt_dt;
    private String cmtfile;
}

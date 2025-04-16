package com.smhrd.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data // getter, setter
@ToString
@NoArgsConstructor
public class ComplainDTO {
    // 필드 선언 (private)
    private int cpl_idx;
    private String title;
    private String content;
    private String indate;
    private String nick;
    private String pw;
    private String location;
    private String picture; 
    private int state;
}

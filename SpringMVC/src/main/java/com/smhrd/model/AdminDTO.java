package com.smhrd.model;

import lombok.Data;
import lombok.ToString;

@Data // getter, setter
@ToString
public class AdminDTO {
	   private String admin_id;	//admin id
	   private String admin_pw;	//admin pw
	   private String admin_name;	//admin name
}

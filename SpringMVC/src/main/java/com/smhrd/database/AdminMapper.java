package com.smhrd.database;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.smhrd.model.AdminDTO;

@Mapper
public interface AdminMapper { 
   
   @Select("SELECT * FROM ADMIN_TABLE  WHERE ADMIN_ID=#{admin_id} and ADMIN_PW=#{admin_pw}")
   public AdminDTO adminLogin(AdminDTO vo);

   @Select("SELECT COUNT(*) FROM ADMIN_TABLE  WHERE ADMIN_ID=#{admin_id} and ADMIN_NAME=#{admin_name}")
   public boolean findById(AdminDTO vo);
   
}

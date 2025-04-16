package com.smhrd.database;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.smhrd.model.CommentDTO; 

@Mapper
public interface CommentMapper {
	@Select("SELECT * FROM COMMENT_TABLE WHERE CPL_IDX=#{cpl_idx}")
	public CommentDTO BoardCommentPage(int cpl_idx);
	
	@Select("SELECT CMT_FILE FROM COMMENT_TABLE WHERE CPL_IDX = #{cpl_idx}")
	public String selectCommentImg(int cpl_idx);

	@Insert("INSERT INTO COMMENT_TABLE (CPL_IDX, CMT_CONTENT, CMT_FILE, ADMIN_ID, ADMIN_NAME) " +
	        "VALUES (#{cpl_idx}, #{cmt_content}, #{cmtfile}, #{admin_id}, #{admin_name})")
	public boolean insertComment(CommentDTO comment);

}

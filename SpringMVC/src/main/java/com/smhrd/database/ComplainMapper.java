package com.smhrd.database;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import com.smhrd.model.ComplainDTO;

@Mapper
public interface ComplainMapper { 
   
	@Select("SELECT * FROM COMPLAIN_TABLE ORDER BY CPL_IDX DESC LIMIT 10 OFFSET #{offset}")
	public List<ComplainDTO> selectComplainList(@Param("offset") int offset);

	@Select("SELECT * FROM COMPLAIN_TABLE WHERE TITLE LIKE CONCAT('%', #{searchTitle}, '%') ORDER BY CPL_IDX DESC LIMIT 10 OFFSET #{offset}")
	public List<ComplainDTO> searchComplainTitleWithPaging(@Param("searchTitle") String title, @Param("offset") int offset);

	@Insert("INSERT INTO COMPLAIN_TABLE(TITLE, CONTENT, LOCATION, PICTURE, NICK, PW) " +
	        "VALUES (#{title}, #{content}, #{location}, #{picture, jdbcType=BLOB}, #{nick}, #{pw})")
	public int BoardInsertPage(ComplainDTO vo);

	@Select("SELECT * FROM COMPLAIN_TABLE WHERE CPL_IDX=#{cpl_idx}")
	public ComplainDTO BoardContentPage(int cpl_idx);

	@Select("SELECT COUNT(*) FROM COMPLAIN_TABLE")
	public int countComplain();

	@Select("SELECT COUNT(*) FROM COMPLAIN_TABLE WHERE TITLE LIKE CONCAT('%', #{searchTitle}, '%')")
	public int countTitleComplain(String searchTitle);
	
	@Select("SELECT COUNT(*) FROM COMPLAIN_TABLE WHERE CPL_IDX=#{cpl_idx} and  PW=#{pw}")
	public int PwAuth(ComplainDTO vo);
	
	
	@Update("UPDATE COMPLAIN_TABLE " +
	        "SET TITLE = #{title}, " +
	        "CONTENT = #{content}, " +
	        "NICK = #{nick}, " +
	        "PICTURE = #{picture}, " +
	        "LOCATION = #{location} " +
	        "WHERE CPL_IDX = #{cpl_idx} and STATE = 0")
	public int BoardUpdatePage(ComplainDTO vo);
	
	@Delete("DELETE FROM COMPLAIN_TABLE WHERE CPL_IDX=#{cpl_idx} and PW=#{pw} and STATE = 0")
	public void BoardDelete(ComplainDTO vo);

	@Delete("DELETE FROM COMPLAIN_TABLE WHERE CPL_IDX=#{cpl_idx} and STATE = 0")
	public void BoardDeleteAdmin(ComplainDTO vo);
	
	@Select("SELECT COUNT(*) FROM COMPLAIN_TABLE WHERE STATE=1")
	public int countClearComplain(); 

	@Select("SELECT COUNT(*) FROM COMPLAIN_TABLE WHERE indate >= NOW() - INTERVAL 7 DAY")
	public int countWeekDayComplain(); 
	
	@Select("SELECT COUNT(*) FROM COMPLAIN_TABLE WHERE indate >= NOW() - INTERVAL 7 DAY AND STATE=1")
	public int countWeekDayClearComplain();

	@Select("SELECT STATE FROM COMPLAIN_TABLE WHERE CPL_IDX=#{cpl_idx}")
	public int getState(int cpl_idx);

	@Update("UPDATE COMPLAIN_TABLE SET STATE=1 WHERE CPL_IDX=#{cpl_idx}")
	public void changeState(int cpl_idx);

	@Select("SELECT PICTURE FROM COMPLAIN_TABLE WHERE CPL_IDX=#{cpl_idx} AND STATE=0")
	public String selectPicture(int cpl_idx);

	@Select("SELECT CPL_IDX FROM COMPLAIN_TABLE " +
	        "WHERE TITLE = #{title} " +
	        "AND CONTENT = #{content} " +
	        "AND NICK = #{nick} " +
	        "AND LOCATION = #{location} " +
	        "AND PW = #{pw} " +
	        "AND STATE = 0 " +
	        "ORDER BY INDATE DESC " +
	        "LIMIT 1")
	public int findNowComplain(ComplainDTO boardContent);
	
}

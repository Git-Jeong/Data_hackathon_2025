package com.smhrd.database;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.smhrd.model.HeatRoadDTO;
import com.smhrd.model.HeatRoad_DTO;

@Mapper
public interface HeatRoadMapper {
	@Select("SELECT * FROM HEAT_LOC")
	public ArrayList<HeatRoadDTO>  selecAllHeatRoad();
} 
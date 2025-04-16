package com.smhrd.model;

import java.math.BigDecimal;

import lombok.Data;
import lombok.ToString;

@Data // getter, setter
@ToString
public class HeatRoadDTO {
	private int loc_idx;
	private String road_name;
	private BigDecimal start_lat;
	private BigDecimal start_lon;
	private BigDecimal end_lat;
	private BigDecimal end_lon;
	private BigDecimal score;
	private BigDecimal acc_angle;
	private String admin_id;
}

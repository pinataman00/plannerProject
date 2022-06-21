package com.planner.model.vo;

import java.sql.Date;

import lombok.Builder;
import lombok.Data;


@Data
@Builder
public class Planner {


	private String plannerNo;
	private String userId;
	private String plannerTitle;
	private int travelDays;
	private Date writtenDate;
	private String images;
	private String theme;
	private int areacode;
	private int sigungucode;
	private int score;
	
	
	
}

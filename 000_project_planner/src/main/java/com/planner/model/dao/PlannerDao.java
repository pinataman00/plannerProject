package com.planner.model.dao;

import static com.common.JDBCTemplate.close;

import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import com.planner.model.vo.Planner;
import com.planner.model.vo.PlannerLog;

public class PlannerDao {
	
	private Properties prop = new Properties();
	
	public PlannerDao(){
		
		String path = PlannerDao.class.getResource("/sql/planner_sql.properties").getPath();
		
		try {
			
			prop.load(new FileReader(path));
			
		} catch (IOException e){
			e.printStackTrace();
		}
		
	}

	
	public int savePlanner(Planner planner, Connection conn) { //PLANNER테이블 저장
		
		PreparedStatement pstmt = null;
		int res = 0;
		
		
		try {
			
			pstmt = conn.prepareStatement(prop.getProperty("savePlanner"));
			
			pstmt.setString(1, planner.getUserId());
			pstmt.setString(2, planner.getPlannerTitle());
			pstmt.setInt(3, planner.getTravelDays());
			pstmt.setString(4, planner.getImages());
			pstmt.setString(5,planner.getTheme());
			pstmt.setInt(6, planner.getAreacode());
			pstmt.setInt(7, planner.getSigungucode());
			pstmt.setInt(8, planner.getScore());
			
			res = pstmt.executeUpdate();
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(pstmt);
		}
		
		return res;
	}
	
	
	public int savePlan(PlannerLog p, Connection conn, int plannerNo) { //PLAN테이블 저장 메소드

		PreparedStatement pstmt = null;
		int res = 0;
		
		try {
			
			pstmt = conn.prepareStatement(prop.getProperty("savePlan"));
			pstmt.setString(1, "PLAN"+plannerNo);
			pstmt.setString(2, p.getDay());
			pstmt.setString(3, p.getLatitude());
			pstmt.setString(4, p.getLongitude());
			pstmt.setString(5, p.getMemo());
			pstmt.setString(6, p.getPlaceName());
			
			res = pstmt.executeUpdate();
			
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(pstmt);
		}
		
		
		return res;
	}


	public int selectPlannerNo(Connection conn) {

		int plannerNo=0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
		
			pstmt = conn.prepareStatement(prop.getProperty("selectPlannerNo"));
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				plannerNo = rs.getInt(1);
			}
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(pstmt);
		}
		
		return plannerNo;
	}


}

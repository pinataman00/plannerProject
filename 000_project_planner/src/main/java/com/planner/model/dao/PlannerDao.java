package com.planner.model.dao;

import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Properties;

import com.planner.model.vo.PlannerLog;
import static com.common.JDBCTemplate.close;

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

	public int savePlan(PlannerLog p, Connection conn) {

		PreparedStatement pstmt = null;
		int res = 0;
		
		try {
			
			pstmt = conn.prepareStatement(prop.getProperty("savePlan"));
			pstmt.setString(1, null);
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

}

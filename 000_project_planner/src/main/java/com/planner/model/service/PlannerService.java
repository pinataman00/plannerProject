package com.planner.model.service;

import java.sql.Connection;
import java.util.List;

import org.apache.jasper.tagplugins.jstl.core.ForEach;

import com.planner.model.dao.PlannerDao;
import com.planner.model.vo.PlannerLog;

import static com.common.JDBCTemplate.getConnection;
import static com.common.JDBCTemplate.*;

public class PlannerService {

	private PlannerDao dao = new PlannerDao();
	
	
	//1. DB에 플랜 저장하기
	public int savePlan(PlannerLog[] plannerLogs) {
		
		Connection conn = getConnection();

		int res = 0;
		
		/*
		 * for (PlannerLog p : plannerLogs2) {
		 * 
		 * res = dao.savePlan(p, conn);
		 * 
		 * if(res>0) { commit(conn); } else { rollback(conn); }
		 */
			
		//}

		for(int i=0;i<plannerLogs.length;i++) {
			
			res = dao.savePlan(plannerLogs[i], conn);
		
		}
	
		close(conn);
		return res;
	}

}

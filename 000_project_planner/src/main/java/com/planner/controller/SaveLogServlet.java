package com.planner.controller;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.jasper.tagplugins.jstl.core.ForEach;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.planner.model.service.PlannerService;
import com.planner.model.vo.PlannerLog;

@WebServlet("/planner/saveLog.do")
public class SaveLogServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private List<PlannerLog> list = new ArrayList();

	public SaveLogServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// TODO DB에 플랜 저장 後, 플랜 저장 완료 페이지로 이동함
		// DB에서 리스트를 가져올지, localStorage를 다시 사용할지 고민 중

		// 1. 플래너 정보 저장하기
		// ------------------------------------------------------------------------------

		// 2. 플랜 작성 정보 저장하기
		// ------------------------------------------------------------------------------
		// 플랜 작성 정보 불러오기

		String jsonStr = request.getParameter("planPerDay");
		Gson gson = new Gson();
		PlannerLog[][] planners = gson.fromJson(jsonStr, PlannerLog[][].class);

		int res = 0;

		for (PlannerLog[] plannerLogs : planners) {
			
			for (PlannerLog plannerLogs2 : plannerLogs) {
				System.out.println("저장된 플랜 확인"+plannerLogs2);
			}
			
			res = new PlannerService().savePlan(plannerLogs);

		}

		/*
		 * PlannerLog plan = gson.fromJson(jsonStr, PlannerLog.class);
		 * //System.out.println(plan);
		 * 
		 * list.add(plan); //list에 추가하기
		 * 
		 * for (PlannerLog plannerLog : list) {
		 * 
		 * System.out.println("잘 넘어왔나 확인 : "+plannerLog); }
		 * 
		 * System.out.println(list.size());
		 * 
		 * //plan을 DB에 INSERT하기 > 한 번 넘어올 때마다 해당 서블릿을 호출하고, savePlan()메소드도 실행해서 안 됨! int
		 * res = new PlannerService().savePlan(list);
		 * 
		 */
		  
		  String msg,loc=""; //TODO msg, loc부분 만들어야 함 if(res>0) { msg = "플랜 저장 성공!";
		   
		  if(res>0) {
			  
			  loc = "/"; //플랜 페이지로 돌아가기
			  System.out.println("저장 성공!");
		  
		  } else { msg = "플랜 저장에 실패했습니다. 다시 시도해주세요!"; loc = "/";
		  
		  		System.out.println("저장 실패!");
		  
		  }
		 

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}

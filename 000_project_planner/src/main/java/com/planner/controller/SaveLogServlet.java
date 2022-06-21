package com.planner.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.planner.model.service.PlannerService;
import com.planner.model.vo.Planner;
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
		
		int days=0;
		String theme = "";
		String title = "";
		int area = 0;
		int sigungu = 0;
		
		Cookie[]cookies = request.getCookies();
		
		if(cookies!=null){ //플래너 페이지에서 입력했던 정보 가져오기
			
			for(Cookie c : cookies){
				
				if(c.getName().equals("forOption")){ //여행 일자
					days = Integer.parseInt(c.getValue());				
				}
				
				if(c.getName().equals("forTheme")){ //여행 테마
					theme = c.getValue();
				}
				
				if(c.getName().equals("forTitle")){ //플랜 제목
					title = c.getValue();
				}
				
				if(c.getName().equals("forArea")){ //지역코드 > 대분류
					area = Integer.parseInt(c.getValue());				
				}
				
				if(c.getName().equals("forSigungu")){ //지역코드 > 소분류
					sigungu = Integer.parseInt(c.getValue());			
				}
				
			}		
		}
		
		//잘 받아왔나 확인
//		System.out.println("여행 일자 : "+days);
//		System.out.println("여행 테마 : "+theme);
//		System.out.println("플래너 제목 : "+title);
//		System.out.println("지역 코드 > 대분류 : "+area);
//		System.out.println("지역 코드 > 소분류 : "+sigungu);
		
		Planner planner = Planner.builder()
					      .userId("plannerTest")
					      .plannerTitle(title)
					      .travelDays(days)
					      .theme(theme)
					      .areacode(area)
					      .sigungucode(sigungu)
					      //.plannerNo("난수 활용해 고유번호 만들기")
					      .build();
		
		int result = new PlannerService().savePlanner(planner);
		if (result<0) {
			System.out.println("플래너 저장 실패!");
		} else {
			System.out.println("플래너 저장 성공!");
		}
		
		//1-2. "플래너"로부터 방금 생성된 "플래너 코드"가져오기... 
		//방금 생성된 플래너코드를 어떤 기준으로 가져올까?
		//DAO의 플래너 저장 메소드에서, 저장과 동시에 "플래너"정보를 반환해도 되는가?
		//-> DB에서 SEQUENCE를 사용하기보다는, 본 서블릿에서 "난수"를 생성하면 활용 가능할듯!
		//-> 안 될듯...
		String plannerCode = "";
		
		
		
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
				//plannerLogs2.setPlannerNo(plannerCode); //플래너에, "플래너 코드"일괄 할당하기
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

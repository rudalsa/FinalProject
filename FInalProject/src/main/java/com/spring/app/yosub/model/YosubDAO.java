package com.spring.app.yosub.model;


import java.util.List;
import java.util.Map;

import com.spring.app.domain.Calendar_schedule_VO;
import com.spring.app.domain.EmployeesVO;

public interface YosubDAO {

	///////////////////////////////////////////////////////////////


	EmployeesVO getLoginMember(Map<String, String> paraMap);

	int updateIdle(String string);

	int getRequestedDraftCnt(Map<String, Object> paraMap);

	List<Calendar_schedule_VO> scheduleselect(Map<String, Object> paraMap);

	
	
	
	
	
	
	
}

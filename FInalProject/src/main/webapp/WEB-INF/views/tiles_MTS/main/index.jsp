<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
%>
    <style>
         /* 전역 스타일 */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        /* 컨테이너 스타일 */
        .container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(330px, 3fr));
            gap: 30px;
            padding: 20px;
        }

        /* 위젯 컨테이너 스타일 */
        .widget-container {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 8px 12px 0 rgba(0, 0, 0, 0.1);
            height: 200px; /* 모든 위젯의 높이를 200px로 설정 */
            
        }

        /* 위젯 헤더 스타일 */
        .widget-header {
            font-weight: bold;
            margin-bottom: 15px;
        }

        /* 특정 위젯 스타일 */
        .widget-todo {
            min-height: 633px; /* todo 위젯의 높이를 최소 633px로 설정 */
        }
        
        .highcharts-figure,
	.highcharts-data-table table {
	    min-width: 320px;
	    max-width: 800px;
	    margin: 1em auto;
	}
	
	.highcharts-data-table table {
	    font-family: Verdana, sans-serif;
	    border-collapse: collapse;
	    border: 1px solid #ebebeb;
	    margin: 10px auto;
	    text-align: center;
	    width: 100%;
	    max-width: 500px;
	}
	
	.highcharts-data-table caption {
	    padding: 1em 0;
	    font-size: 1.2em;
	    color: #555;
	}
	
	.highcharts-data-table th {
	    font-weight: 600;
	    padding: 0.5em;
	}
	
	.highcharts-data-table td,
	.highcharts-data-table th,
	.highcharts-data-table caption {
	    padding: 0.5em;
	}
	
	.highcharts-data-table thead tr,
	.highcharts-data-table tr:nth-child(even) {
	    background: #f8f8f8;
	}
	
	.highcharts-data-table tr:hover {
	    background: #f1f7ff;
	}

    </style>
    
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/highcharts.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/resources/Highcharts-10.3.3/code/modules/accessibility.js"></script>
    
<script>

$(document).ready(function(){
	
	showWeather();
	   // AJAX 요청
    $.ajax({
        url: "<%= ctxPath%>/scheduleselect.gw",
        type: "get",
        dataType: "json",
        success: function (json) {
        	// console.log(JSON.stringify(json));
        	
        	
        	console.log(json.length);
        	$("span#scheduleCnt").html(json.length);
        	
        	let s_html = "";
        	
		      if(json.length > 0) {
		    	  $.each(json, function(index, item){
		    		  
		    		  s_html += "<tr class='scheduleinfo'>";
		    		  s_html +=    "<td style='font-size:7pt;'>"+ item.enddate +"</td>";
		    		  s_html +=    "<td>"+ item.subject +"</td>"; 
		    		  s_html +=  "</tr>"; 
		    	  });
		      }
		      
		      else {
		    	  s_html +=  "<tr>";
		    	  s_html +=  "<td colspan='3'>일정 없음</td>";
		    	  s_html +=  "</tr>";
		      }
		      
		        
		      $("tbody#scheduleinfo").html(s_html);
         		 	
        },
        error: function (request, status, error) {
            alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
        }
    }); // end of ajax

}); // end of $(document).ready(function(){})-----------------

// ------ 기상청 날씨정보 공공API XML 데이터 호출하기 ------ //
function showWeather(){
	
	$.ajax({
		url:"<%= ctxPath%>/opendata/weatherXML.gw",
		type:"get",
		dataType:"xml",
		success:function(xml){
			const rootElement = $(xml).find(":root"); 
		//	console.log("확인용 : " + $(rootElement).prop("tagName") );
			// 확인용 : current
			
			const weather = rootElement.find("weather"); 
			const updateTime = $(weather).attr("year")+"년 "+$(weather).attr("month")+"월 "+$(weather).attr("day")+"일 "+$(weather).attr("hour")+"시"; 
		//	console.log(updateTime);
			// 2023년 12월 19일 10시
			
			const localArr = rootElement.find("local");
		//	console.log("지역개수 : " + localArr.length);
			// 지역개수 : 97
			
			let html = "날씨정보 발표시각 : <span style='font-weight:bold;'>"+updateTime+"</span>&nbsp;";
	            html += "<span style='color:blue; cursor:pointer; font-size:9pt;' onclick='javascript:showWeather();'>업데이트</span><br/><br/>";
	            html += "<table class='table table-hover' align='center'>";
		        html += "<tr>";
		        html += "<th>지역</th>";
		        html += "<th>날씨</th>";
		        html += "<th>기온</th>";
		        html += "</tr>";
		    
		     // ====== XML 을 JSON 으로 변경하기  시작 ====== //
				var jsonObjArr = [];
			 // ====== XML 을 JSON 으로 변경하기  끝 ====== //    
		        
		    for(let i=0; i<localArr.length; i++){
		    	
		    	let local = $(localArr).eq(i);
				/* .eq(index) 는 선택된 요소들을 인덱스 번호로 찾을 수 있는 선택자이다. 
				      마치 배열의 인덱스(index)로 값(value)를 찾는 것과 같은 효과를 낸다.
				*/
				
		    //	console.log( $(local).text() + " stn_id:" + $(local).attr("stn_id") + " icon:" + $(local).attr("icon") + " desc:" + $(local).attr("desc") + " ta:" + $(local).attr("ta") ); 
		      //	속초 stn_id:90 icon:03 desc:구름많음 ta:-2.5
		      //	북춘천 stn_id:93 icon:03 desc:구름많음 ta:-7.0
		    	
		        let icon = $(local).attr("icon");  
		        if(icon == "") {
		        	icon = "없음";
		        }
		      
		        html += "<tr>";
				html += "<td>"+$(local).text()+"</td><td><img src='<%= ctxPath%>/resources/images/weather/"+icon+".png' />"+$(local).attr("desc")+"</td><td>"+$(local).attr("ta")+"</td>";
				html += "</tr>";
		        
				
				// ====== XML 을 JSON 으로 변경하기  시작 ====== //
				   var jsonObj = {"locationName":$(local).text(), "ta":$(local).attr("ta")};
				   
				   jsonObjArr.push(jsonObj);
				// ====== XML 을 JSON 으로 변경하기  끝 ====== //
				
		    }// end of for------------------------ 
		    
		    html += "</table>";
		    
		    $("div#displayWeather").html(html);
		    
		    
		 // ====== XML 을 JSON 으로 변경된 데이터를 가지고 차트그리기 시작  ====== //
			var str_jsonObjArr = JSON.stringify(jsonObjArr); 
			                  // JSON객체인 jsonObjArr를 String(문자열) 타입으로 변경해주는 것 
			                  
			$.ajax({
				url:"<%= ctxPath%>/opendata/weatherXMLtoJSON.gw",
				type:"POST",
				data:{"str_jsonObjArr":str_jsonObjArr},
				dataType:"JSON",
				success:function(json){
					
				//	alert(json.length);
					
					// ======== chart 그리기 ========= // 
					var dataArr = [];
					$.each(json, function(index, item){
						dataArr.push([item.locationName, 
							          Number(item.ta)]);
					});// end of $.each(json, function(index, item){})------------
					
					
					Highcharts.chart('weather_chart_container', {
					    chart: {
					        type: 'column'
					    },
					    title: {
					        text: '오늘의 전국 기온(℃)'   // 'ㄹ' 을 누르면 ℃ 가 나옴.
					    },
					    subtitle: {
					    //    text: 'Source: <a href="http://en.wikipedia.org/wiki/List_of_cities_proper_by_population">Wikipedia</a>'
					    },
					    xAxis: {
					        type: 'category',
					        labels: {
					            rotation: -45,
					            style: {
					                fontSize: '10px',
					                fontFamily: 'Verdana, sans-serif'
					            }
					        }
					    },
					    yAxis: {
					        min: -10,
					        title: {
					            text: '온도 (℃)'
					        }
					    },
					    legend: {
					        enabled: false
					    },
					    tooltip: {
					        pointFormat: '현재기온: <b>{point.y:.1f} ℃</b>'
					    },
					    series: [{
					        name: '지역',
					        data: dataArr, // **** 위에서 만든것을 대입시킨다. **** 
					        dataLabels: {
					            enabled: true,
					            rotation: -90,
					            color: '#FFFFFF',
					            align: 'right',
					            format: '{point.y:.1f}', // one decimal
					            y: 10, // 10 pixels down from the top
					            style: {
					                fontSize: '10px',
					                fontFamily: 'Verdana, sans-serif'
					            }
					        }
					    }]
					});
					// ====== XML 을 JSON 으로 변경된 데이터를 가지고 차트그리기 끝  ====== //
				},
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			});                  
			///////////////////////////////////////////////////
			
		},// end of success: function(xml){ }------------------
		
		error: function(request, status, error){
			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		}
	});
	
}// end of function showWeather()--------------------


</script>
	
    
    
    
    
<body>
   <div class="container flex">
	    <!-- todo -->
	    <div class="widget-container widget-todo  my-3">
	        <div class="widget-header">To-Do</div>
		        <div class="listContainer">
					<h5 class="mb-3">결재 대기 문서</h5>
					<h6 class="mb-3">결재해야 할 문서가 <span style="color:#086BDE" id="draftCnt">${requestedDraftCnt}</span>건 있습니다.</h6>
					
						<div class="text-right mr-2 more">
						<a href="<%= ctxPath%>/approval/requested.gw"><i class="fas fa-angle-double-right"></i> 더보기</a>
					</div>
				</div>
				 <div class="listContainer">
					<h5 class="my-3">오늘의 일정 <span id="scheduleCnt"></span>건</h5> 
					
					<div class="today_work_schedule">
						<table>
						<thead>
							<tr>
								
					            <th>종료일</th>
					            <th style='text-align:center;'>내용</th>
				            </tr>
			            </thead>
			            <tbody id="scheduleinfo">
			            </tbody>
			            
			            </table>
					</div>
						<div class="text-right mr-2 more">
						<a href="<%= ctxPath%>/schedule/scheduleManagement.gw"><i class="fas fa-angle-double-right"></i> 더보기</a>
					</div>
				</div>
	        <!-- To-Do 컨텐츠 -->
	        <!-- ... -->
	    </div>
	
	    <!-- 나머지 위젯을 옆으로 배치하기 위한 div 추가 -->
	    <div class="flex">
	        <!-- 프로필 조직도 -->
	        <div class="widget-container widget-profile my-3">
	            <div class="widget-header">프로필</div>
	            <div style="display: flex; justify-content: center;">
			
			<div id="photo" class="mx-2">
				<img src="<%= ctxPath%>/resources/images/${requestScope.loginuser.photo}" style="width: 100px; height: 100px; border-radius: 50%;" />
			</div>
				
			<table id="table1" class="myinfo_tbl">
				<tr>
					<th width="50%;">성명</th>
					<td>${requestScope.loginuser.name}</td>
				</tr>
				<tr>	
					<th>이메일</th>
					<td>${requestScope.loginuser.email}</td>
				</tr>
				<tr>
					<th>입사일자</th>
					<td>${requestScope.loginuser.hire_date}</td>
				</tr>
			</table>
			
		</div>
	        </div>
	
	        <!-- 웹메일 -->
	        <div class="widget-container widget-mail my-3">
	            <div class="widget-header">웹메일</div>
	            <!-- 웹메일 컨텐츠 -->
	            <!-- ... -->
	        </div>
	        
	        <!-- 공지사항 -->
	        <div class="widget-container widget-notice my-3">
	            <div class="widget-header">공지사항</div>
	            <!-- 공지사항 컨텐츠 -->
	            <!-- ... -->
	        </div>
	    </div>
	    
	    
			<%-- 차트그리기 --%>
			<figure class="highcharts-figure">
			    <div id="weather_chart_container" class="widget-container"></div>
			</figure> 
		
		
</div>

    
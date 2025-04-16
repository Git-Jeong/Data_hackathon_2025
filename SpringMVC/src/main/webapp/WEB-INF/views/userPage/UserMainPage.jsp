<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결빙 신문고</title>

<!-- 네비바를 위해서 필수로 넣어야 되는 부분 -->
<!-- src/main/webapp/resources/js 폴더로 가면 헤더, 푸터 파일이 있음 -->
<!-- Bootstrap 5.3.3 CSS & JS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/Common.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/resources/css/userPage/UserMainPage.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/UserPageHeader.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/PageFooter.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>
	<%
		Integer totalAttr = (Integer) request.getAttribute("total_count");
		Integer clearAttr = (Integer) request.getAttribute("clear_count");
		Integer weekyAttr = (Integer) request.getAttribute("week_count");
		Integer weekClaerAttr = (Integer) request.getAttribute("week_clear_count");
	    int total = (totalAttr != null) ? totalAttr : 0;
	    int clear = (clearAttr != null) ? clearAttr : 0;
	    int weekTotal = (weekyAttr != null) ? weekyAttr : 0;
	    int weekClear = (weekClaerAttr != null) ? weekClaerAttr : 0;
	    
	    int remain = total - clear;
	    int percent = 0;
	    if(clear != 0){
	    	percent = (int) ((clear / (double) total) * 100);
	    } 

	    // 시스템 시간 가져오기
	    SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");  // 년-월-일
	    SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm:ss");     // 시간:분:초
	    String currentDate = sdfDate.format(new Date());
	    String currentTime = sdfTime.format(new Date());
	%>
	<div class="page-wrapper">
		<!-- 유저 페이지의 네비바가 들어갈 s자리 -->
		<div id="user_header"></div>

		<div class="main_content_container">

			<!-- 각각의 섹션 -->
			<div id="section1" class="mainPageSection">
				<div class="mainPageUpperContainer">
					<div class="mainPageUpperTitle">결빙 신문고</div>
					<div class="mainPageUpperDetail">도로결빙을 신고해주세요!</div>
				</div>
				<br>

				<div class="mainPageContainerWideBox">

					<div class="mainPageContainerWideBoxElement"
						onclick="location.href='BoardInsertPage.do'">
						<div class="mainPageContainerImg">
							<img alt="img"
								src="${pageContext.request.contextPath}/resources/img/민원신청.png">
						</div>

						<div class="mainPageContainerDetail">민원접수</div>
					</div>

					<div class="mainPageContainerWideBoxElement"
						onclick="location.href='BoardListPage.do'">
						<div class="mainPageContainerImg">
							<img alt="img"
								src="${pageContext.request.contextPath}/resources/img/민원목록.png">
						</div>

						<div class="mainPageContainerDetail">민원목록</div>
					</div>

					<div class="mainPageContainerWideBoxElement"
						onclick="location.href='HeatRoadListPage.do'">
						<div class="mainPageContainerImg">
							<img alt="img"
								src="${pageContext.request.contextPath}/resources/img/위험도로목록.png">
						</div>

						<div class="mainPageContainerDetail">위험도로</div>
					</div>

				</div>
			</div>

			<div id="section2" class="mainPageSection">
				<div class="mainPageChartContainer">
					<div class="mainPageChartElement">
						<div class="mainPageChatBox">
							<div class="mainPageCharImg">
								<canvas id="donutChart" ></canvas>
							</div>
							<div class="mainPageChartDetail">
								역대 민원의 통계입니다.
							</div>
						</div>
					</div>
					
					<div class="mainPageChartElement">
						<div class="mainPageChatBox"> 
							<div class="mainPageChartDetail">
							   기준일<br><br>
							    <span class="date-time"><%= currentDate.substring(0, 4) %>년 <%= currentDate.substring(5, 7) %>월 <%= currentDate.substring(8, 10) %>일</span><br>
							    <span class="date-time"><%= currentTime.substring(0, 2) %>시 <%= currentTime.substring(3, 5) %>분 <%= currentTime.substring(6, 8) %>초</span>
							</div>
						</div>
					</div>
					<div class="mainPageChartElement">
						<div class="mainPageChatBox">
							<div class="mainPageCharImg">
								<canvas id="barChart"></canvas>
							</div>
							<div class="mainPageChartDetail">
								최근 168시간(=7일)의 통계입니다.
							</div>
						</div>
					</div>
					
				</div>
			</div>

			<div id="section3" class="mainPageSection">
				<div class="roadDescriptionContainer">
					<div class="roadImgBox">
						<img alt="img"
							src="${pageContext.request.contextPath}/resources/img/연합뉴스_도로결빙.jpg">
						<a class="roadImgBoxDetail"
							href="https://www.yna.co.kr/view/AKR20121230015200065"
							target="_blank">출처 : 연합뉴스</a>
					</div>

					<div class="roadDescriptionDetail">
						<div class="roadDescriptionDetail">
							<h3>도로 열선 설치의 필요성</h3>
							<p>한정된 예산을 고려하여 데이터 기반의 선별적 설치가 중요.</p>

							<table class="userMainPage-heatRoadTable">
								<thead>
									<tr>
										<th>문제점</th>
										<th>개선방안</th>
										<th>서비스 필요성</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>- 겨울철 도로 결빙 사고<br> - 제설작업의 수동성 및 지연<br> -
											제설제의 부작용 (포트홀, 부식)<br> - 인력 및 자원의 낭비
										</td>
										<td>- 도로 열선 설치로 사전 예방<br> - 제설제 사용 감소 및 인력 부담 완화<br>
											- 포트홀 및 차량 부식 문제 해결
										</td>
										<td>- 교통·보행 안전성 향상<br> - 제설 및 사고 처리 비용 절감<br> -
											친환경적이고 지속 가능한 도시 관리
										</td>
									</tr>
								</tbody>
							</table>

							<br>

							<table class="userMainPage-heatRoadTable">
								<thead>
									<tr>
										<th>열선 설치의 필요성</th>
										<th>설치 전략</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>- 결빙 사고 예방을 통한 인명 보호<br> - 제설제 부작용(도로 손상, 차량 부식)
											방지<br> - 수동 제설작업의 한계 보완
										</td>
										<td>- 한정된 예산 고려<br> - 빅데이터 기반 사고 발생 예측<br> -
											머신러닝을 활용한 결빙 취약지역 분석<br> - 학교·병원 등 주요 취약시설 중심 선별적 설치
										</td>
									</tr>
								</tbody>
							</table>
						</div>

					</div>
				</div>
			</div>

			<div id="section4" class="mainPageSection" style="display: none;">
				<!-- 현재로는 미구현  구간으로 Display none 걸어둠.(=추후 추가시 옵션을 지울것) -->

			</div>
		</div>

		<!-- 푸터 자리 -->
		<div class="page_footer" id="page_footer"></div>
	</div>
	
<script>
  const ctx = document.getElementById('donutChart').getContext('2d');

  const centerText = {
    id: 'centerText',
    beforeDraw(chart, args, options) {
      const {width, height} = chart;
      const ctx = chart.ctx;
      ctx.restore();
      ctx.font = (height / 10).toFixed(2) + "px sans-serif";
      ctx.textBaseline = "middle";
      ctx.textAlign = "center";
      ctx.fillStyle = "#000";
      ctx.fillText("<%= percent %>%", width / 2, height / 2);
      ctx.save();
    }
  };

  new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: ['완료', '미완료'],
      datasets: [{
        data: [<%= clear %>, <%= remain %>],
        backgroundColor: ['#4CAF50', '#E0E0E0'],
        borderWidth: 1
      }]
    },
    options: { 
      responsive: false,
      plugins: {
        legend: {
          position: 'bottom'
        },
        title: {
          display: true,
          text: '전체 민원처리 현황',
          font: {
            size: 18
          },
          padding: {
            top: 10,
            bottom: 10
          }
        }
      }
    },
    plugins: [centerText]
  }); 
  
  const weekTotal = <%= weekTotal %>;
  const weekClear = <%= weekClear %>;

  // 조건 연산을 클라이언트에서 처리
  const min = 0;
  const max = weekTotal * 1.2;
  
  const barCtx = document.getElementById('barChart').getContext('2d');

  new Chart(barCtx, {
    type: 'bar',
    data: {
      labels: ['접수', '처리완료'],
      datasets: [{
        label: '민원 수',
        data: [weekTotal, weekClear],
        backgroundColor: ['#42A5F5', '#66BB6A']
      }]
    },
    options: {
      maintainAspectRatio: false,
      responsive: true,
      plugins: {
        legend: {
          display: false
        },
        title: {
          display: true,
          text: '이번 주 민원처리 현황',
          font: {
            size: 16
          }
        },
        // 숫자 표시 플러그인
        datalabels: {
          anchor: 'end',
          align: 'top',
          color: '#000',
          font: {
            weight: 'bold',
            size: 14
          },
          formatter: function(value) {
            return value;
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,  
          ticks: {
            min: 0,  
            max: max,  
            stepSize: 10
          }
        }
      }
    }
  });
</script>
</body>
</html>

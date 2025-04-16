<%@page import="com.smhrd.model.HeatRoadDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위험 도로</title>

<!-- 네비바를 위해서 필수로 넣어야 되는 부분 -->
<!-- src/main/webapp/resources/js 폴더로 가면 헤더, 푸터 파일이 있음 -->
<!-- Bootstrap 5.3.3 CSS & JS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link 
	href="${pageContext.request.contextPath}/resources/css/Common.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/resources/css/heatRoadPage/HeatRoadListPage.css"
	rel="stylesheet">
<script
	src="${pageContext.request.contextPath}/resources/js/UserPageHeader.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/PageFooter.js"></script>

<style type="text/css">


</style>
</head>

<body>
	<%
	String kakaoMapAPI = (String) request.getAttribute("kakaoMapAPI");
	ArrayList<HeatRoadDTO> roadList = (ArrayList<HeatRoadDTO>) request.getAttribute("roadList");
	%>
	<div class="page-wrapper">
		<!-- 유저 페이지의 네비바가 들어갈 자리 -->
		<div id="user_header"></div>

		<div class="main_content_container" align="center">
			
			<div class="heatRoadListPageContainer">	 	
				<h3 >위험도로 조회</h3>
				
				<div class="heatRoadListPageForm">
					<div style="display: flex;">
						<!-- 왼쪽 도로 목록 -->
						<div class="heatRoadListContainer">
							<div class="heatRoadNameListTitle">
								<h3>도로 목록</h3>
							</div>
							<div class="heatRoadNameList">
								<ul id="roadList">
									<%
									for (HeatRoadDTO road : roadList) {
									%>
									<li data-index="<%=road.getLoc_idx()%>"
										data-lat="<%=road.getStart_lat()%>"
										data-lon="<%=road.getStart_lon()%>"><%=road.getRoad_name()%>
									</li>
									<%
									}
									%>
								</ul>
							</div> 
						</div>
					</div>

					<!-- 지도 영역 -->
					<div id="map" style="width: 100%; height: 500px;"></div>
				</div>
				
				
			</div>
		</div>
		<!-- 푸터 자리 -->
		<div class="page_footer" id="page_footer"></div>
	</div>
	<script type="text/javascript"
		src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=<%=kakaoMapAPI%>"></script>


<script>
    const mapContainer = document.getElementById('map');
    const mapOption = {
      center: new kakao.maps.LatLng(37.5591859, 127.0926917), // 초기 중심
      level: 4
    };
    const map = new kakao.maps.Map(mapContainer, mapOption);

    const roadList = [
      <%for (HeatRoadDTO road : roadList) {%>
        {
          locIdx: <%=road.getLoc_idx()%>,
          name: "<%=road.getRoad_name()%>",
          startLat: <%=road.getStart_lat()%>,
          startLon: <%=road.getStart_lon()%>,
          endLat: <%=road.getEnd_lat()%>,
          endLon: <%=road.getEnd_lon()%>,
          score: <%=road.getScore()%>,
          accAngle: <%=road.getAcc_angle()%>
        },
      <%}%>
    ];

    let currentPolyline = null; // 현재 클릭된 도로의 polyline을 저장할 변수
    let currentMarker = null; // 현재 표시된 마커를 저장할 변수
    let currentInfoWindow = null; // 현재 열린 InfoWindow를 저장할 변수

    // 도로 목록 클릭 시 해당 도로로 지도 이동 및 선 그리기
    document.querySelectorAll('#roadList li').forEach(function (item) {
      item.addEventListener('click', function () {
        const roadData = roadList.find(function (road) {
          return road.locIdx === parseInt(item.getAttribute('data-index'));
        });

        if (roadData) {
          const centerLatLng = new kakao.maps.LatLng(roadData.startLat, roadData.startLon);
          map.panTo(centerLatLng);  // 해당 위치로 이동

          // 기존 Polyline 삭제
          if (currentPolyline) {
            currentPolyline.setMap(null);
          }

          // 새로운 도로 구간의 선 그리기
          const linePath = [
            new kakao.maps.LatLng(roadData.startLat, roadData.startLon),
            new kakao.maps.LatLng(roadData.endLat, roadData.endLon)
          ];

          currentPolyline = new kakao.maps.Polyline({
            map: map,
            path: linePath,
            strokeWeight: 5,
            strokeColor: getColorByScore(roadData.score),
            strokeOpacity: 0.8,
            strokeStyle: 'solid'
          });

          // 기존 마커 삭제
          if (currentMarker) {
            currentMarker.setMap(null);
          }
          
          const markerImage = new kakao.maps.MarkerImage(
       		  "${pageContext.request.contextPath}/resources/img/열선마커.png",
       		  new kakao.maps.Size(70, 70) // 이미지 크기
        	);
          
          // 새로운 마커 표시
          currentMarker = new kakao.maps.Marker({
            position: centerLatLng,
            image: markerImage,
            map: map
          });

          // 기존 InfoWindow 삭제
          if (currentInfoWindow) {
            currentInfoWindow.close();
          }

          let scorePrint = roadData.score ? roadData.score.toFixed(3) : '정보 없음';
          let roadNamePrint = roadData.name || '정보 없음';
          let accAnglePrint = roadData.accAngle ? roadData.accAngle.toFixed(2) : '정보 없음';

          console.log(scorePrint, roadNamePrint, accAnglePrint); // 변수 값 확인

          // InfoWindow를 위한 새로운 객체 생성
			currentInfoWindow = new kakao.maps.InfoWindow({
			  content:
			    '<div style="padding:5px; font-size:13px;">' +
			    '<strong>도로명:</strong> ' + roadNamePrint + '<br/>' +
			    '<strong>위험지수:</strong> ' + scorePrint + '<br/>' +
			    '<strong>경사각:</strong> ' + accAnglePrint + '°<br/>' +
			    '</div>'
			});

          // InfoWindow를 지도에 띄우기
          currentInfoWindow.open(map, currentMarker); 
        }
      });
    });

    // 위험지수에 따른 선 색상 지정
    function getColorByScore(score) {
      if (score >= 0.5) return '#FF0000';  // 빨간색 (위험)
      if (score >= 0.48) return '#FFA500';  // 주황색 (주의)
      if (score >= 0.46) return '#FFFF00';  // 노란색 (보통)
      return '#00FF00';  // 초록색 (안전)
    }
	</script>
</body>
</html>

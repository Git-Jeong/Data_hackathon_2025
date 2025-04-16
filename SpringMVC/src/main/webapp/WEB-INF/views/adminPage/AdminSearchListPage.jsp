<%@page import="com.smhrd.model.ComplainDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 민원 목록</title>

<!-- Bootstrap 5.3.3 CSS & JS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/Common.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/BoardListTable.css">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/UserPageHeader.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/PageFooter.js"></script>
</head>

<body>
	<div class="page-wrapper">
		<!-- 유저 페이지의 네비바가 들어갈 자리 -->
		<div id="admin_header"></div>

		<%
		ArrayList<ComplainDTO> complainList = (ArrayList<ComplainDTO>) request.getAttribute("searchComplainList");
		String searchTitle = (String)session.getAttribute("searchTitle");
		// 만약 complainList가 null이라면 빈 리스트로 초기화
		if (complainList == null) {
			complainList = new ArrayList<ComplainDTO>();
		}
		%>
		<%
			Integer searchPageIdxObj = (Integer) session.getAttribute("searchPageIdx");
			int searchPageIdx = (searchPageIdxObj != null) ? searchPageIdxObj : 12;
		%> 

		<div class="main_content_container" align="center">
			<h3 class="text-center my-4">민원 검색 결과</h3>
				<div class="boardContainer">
					<div class="boardBottomBox">
						<div class="boardSearchBox">
							<form action="AdminBoardSearchPage.do" method="get"
								class="boardSearchForm"> 
								<input type="text" class="boardSearchInput" name="searchTitle"
									placeholder="민원 검색" required="required"> <input type="submit"
									class="boardSearchButton" value="검색" >
							</form>
							<button class="boardSearchButton" onclick="location.href='AdminBoardListPage.do'">전체조회</button>
						</div>
						<div class="boardInsertBox">
							<button onclick="l#" style="visibility: hidden;"
								class="boardInsertButton"></button>
						</div>
					</div>
				</div>
			<div class="boardListContainer">
				<div class="boardListTable">
					<div class="boardListTableHeader">
						<div class="boardListTableCell">민원번호</div>
						<div class="boardListTableCell">제목</div>
						<div class="boardListTableCell">작성자</div>
						<div class="boardListTableCell">작성일</div>
						<div class="boardListTableCell">시간</div>
						<div class="boardListTableCell">현황</div>
					</div>
				</div> 

				<%-- complainList를 순회하며 각 항목을 출력 --%>
				<%
				for (int i = 0; i < complainList.size(); i++) {
					ComplainDTO complain = complainList.get(i);

					String indate = complain.getIndate(); // 예시: "2025-04-11 07:50:49"

					// 날짜와 시간을 분리
					String date = indate.split(" ")[0]; // 날짜 부분 "2025-04-11"

					// 날짜에서 월과 일 추출
					String[] dateParts = date.split("-"); // ["2025", "04", "11"]
					int month = Integer.parseInt(dateParts[1]); // 월 "04" -> 4
					int day = Integer.parseInt(dateParts[2]); // 일 "11" -> 11

					// 월과 일 부분을 글자로 변환
					String monthDayText = month + "월 " + day + "일"; // "4월 11일"

					// 시간에서 앞의 0을 제거
					String time = indate.split(" ")[1]; // 시간 부분 "07:50:49"
					String[] timeParts = time.split(":");
					if (timeParts[0].startsWith("0")) {
						timeParts[0] = timeParts[0].substring(1); // 시간에서 앞의 0 제거
					}

					// "HH:mm" 형식으로 초를 제거하고 합침
					String formattedTime = String.join(":", timeParts[0], timeParts[1]); // "HH:mm" 형식
				%>
				<div class="boardListTableRow">
					<div class="boardListTableCell"><%=complain.getCpl_idx()%></div>
					<div class="boardListTableCell">
						<span class="link-text"
							onclick="window.location.href='AdminBoardContentPage.do?cpl_Idx=<%=complain.getCpl_idx()%>'"> 
							<%=complain.getTitle()%>
						</span>
					</div>
					<div class="boardListTableCell"><%=complain.getNick()%></div>
					<div class="boardListTableCell"><%=monthDayText%></div>
					<div class="boardListTableCell"><%=formattedTime%></div>
					<div class="boardListTableCell">
						<%=complain.getState() == 1 ? "처리완료" : "대기중"%>
					</div>
				</div>
				<%
				}
				%>

				<% 
				Object searchTotalPagesObj = session.getAttribute("searchTotalPages");

				
				int searchTotalPages = 1; 
				if (searchTotalPagesObj != null && searchTotalPagesObj instanceof Integer) {
					searchTotalPages = (Integer) searchTotalPagesObj;
				}

				int prevPage = searchPageIdx - 1;
				int nextPage = searchPageIdx + 1;
				%>

				<div class="pageMoveBox">

					<%-- 첫 페이지 버튼 --%>
					<a href="AdminBoardSearchPage.do?searchPageIdx=1&searchTitle=<%=searchTitle%>"
						class="pageMoveButton <%=(searchPageIdx > 1 ? "" : "invisible")%>">&lt;&lt;</a>

					<%-- 이전 페이지 버튼 --%>
					<a href="AdminBoardSearchPage.do?searchPageIdx=<%=prevPage%>&searchTitle=<%=searchTitle%>"
						class="pageMoveButton <%=(searchPageIdx > 1 ? "" : "invisible")%>">&lt;</a>

					<%-- 숫자 버튼 (±2 범위) --%>
					<%
					for (int i = Math.max(1, searchPageIdx - 2); i <= Math.min(searchTotalPages, searchPageIdx + 2); i++) {
						%>
						<%
						if (i == searchPageIdx) { %>
							<span class="pageMoveButton nowPageNumber"><%=i%></span>
							<% 
						} else {%>
							<a href="AdminBoardSearchPage.do?searchPageIdx=<%=i%>&searchTitle=<%=searchTitle%>" class="pageMoveButton"><%=i%></a>
							<%
						}%><%
					}%>

					<%-- 다음 페이지 버튼 --%>
					<a href="AdminBoardSearchPage.do?searchPageIdx=<%=nextPage%>&searchTitle=<%=searchTitle%>"
						class="pageMoveButton <%=(searchPageIdx < searchTotalPages ? "" : "invisible")%>">&gt;</a>

					<%-- 마지막 페이지 버튼 --%>
					<a href="AdminBoardSearchPage.do?searchPageIdx=<%=searchTotalPages%>&searchTitle=<%=searchTitle%>"
						class="pageMoveButton <%=(searchPageIdx < searchTotalPages ? "" : "invisible")%>">&gt;&gt;</a>

				</div> 
			</div> 
			
			<!-- 푸터 자리 -->
			<div class="page_footer" id="page_footer"></div>
		</div>
	</div>
</body>
</html>

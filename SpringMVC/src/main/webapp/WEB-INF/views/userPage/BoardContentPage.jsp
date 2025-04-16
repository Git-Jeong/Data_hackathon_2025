<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%> 
<%@page import="com.smhrd.model.CommentDTO"%>
<%@page import="com.smhrd.model.ComplainDTO"%>
<%@ page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>민원 내용</title>

<!-- 네비바를 위해서 필수로 넣어야 되는 부분 -->
<!-- src/main/webapp/resources/js 폴더로 가면 헤더, 푸터 파일이 있음 -->
<!-- Bootstrap 5.3.3 CSS & JS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/Common.css"
	rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/BoardContentComemt.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/UserPageHeader.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/PageFooter.js"></script>

	
</head>

<body>
	<%
	ComplainDTO boardContent = (ComplainDTO) request.getAttribute("boardContent");
	CommentDTO boardComment = (CommentDTO)request.getAttribute("boardComment");
	
	String action = request.getParameter("action"); // 수정 or 삭제 판단
	
	String CommentDayText = "";
	String CommentTime = "";
	
	if (boardContent == null) {
		 response.sendRedirect("BoardListPage.do");
	     return; // 이후 코드 실행 방지
	}
	
	String indate = boardContent.getIndate(); // 예시: "2025-04-11 07:50:49"

	// 날짜와 시간을 분리
	String date = indate.split(" ")[0]; // 날짜 부분 "2025-04-11"

	// 날짜에서 월과 일 추출
	String[] dateParts = date.split("-"); // ["2025", "04", "11"]
	int month = Integer.parseInt(dateParts[1]); // 월 "04" -> 4
	int day = Integer.parseInt(dateParts[2]); // 일 "11" -> 11

	// 월과 일 부분을 글자로 변환
	String ComplainDayText = month + "월 " + day + "일"; // "4월 11일"

	// 시간에서 앞의 0을 제거
	String time = indate.split(" ")[1]; // 시간 부분 "07:50:49"
	String[] timeParts = time.split(":");
	if (timeParts[0].startsWith("0")) {
		timeParts[0] = timeParts[0].substring(1); // 시간에서 앞의 0 제거
	}

	// "HH:mm" 형식으로 초를 제거하고 합침
	String ComplainTime = String.join(":", timeParts[0], timeParts[1]); // "HH:mm" 형식
	%>
	
	<div class="page-wrapper">

		<!-- 유저 페이지의 네비바가 들어갈 자리 -->
		<div id="user_header"></div>

		<div class="main_content_container" align="center">
			<h3 class="text-center my-4">민원 조회</h3>
	
		<div class="boardContent-btns">
		    <!-- 왼쪽: 뒤로가기 버튼 -->
		    <div class="boardContent-left-btns">
		        <div class="back-btn-container">
		            <button class="boardContent-back-btn" onclick="goBack()">뒤로가기</button>
		        </div>
		    </div>
		
			<%if(boardContent.getState() == 0) {%>
		    <!-- 오른쪽: 수정, 삭제 버튼 -->
		    <div class="boardContent-right-btns">
		        <!-- 수정 버튼 -->
		        <form method="get" action="BoardContentPage.do" class="boardContent-btn-form">
		            <input type="hidden" name="cpl_idx" value="<%=boardContent.getCpl_idx()%>">
		            <input type="hidden" name="action" value="update">
		            <input type="submit" value="수정" class="boardContent-update-btn" onclick="showPasswordForm(event, 'update')">
		        </form>
		
		        <!-- 삭제 버튼 -->
		        <form method="get" action="BoardContentPage.do" class="boardContent-btn-form">
		            <input type="hidden" name="cpl_idx" value="<%=boardContent.getCpl_idx()%>">
		            <input type="hidden" name="action" value="delete">
		            <input type="submit" value="삭제" class="boardContent-delete-btn" onclick="showPasswordForm(event, 'delete')">
		        </form>
		    </div>
		    <%} %>
		</div>
		
		<div class="boardContent-check-btn">
		    <!-- 비밀번호 입력창 표시 (처음부터 오른쪽에 고정, 시각적으로 숨김 처리) -->
		    <form action="PwAuth.do" method="post" class="boardContent-btn-assword-form" style="visibility: hidden;" id="passwordForm">
		        <input type="hidden" name="cpl_idx" value="<%=boardContent.getCpl_idx()%>">
		        <input type="hidden" name="nextAction" value="">
		        <input type="password" name="password" placeholder="비밀번호 입력" class="boardContent-password-input">
		        
		        <input type="submit" class="boardContent-btn-submit" value="확인">
		        <button type="button" class="boardContent-btn-cancel" onclick="hidePasswordForm()">취소</button>
		    </form>
		</div>
	
			<!-- 민원 내용 -->
			<div class="boardContent-container-complain"> 
				<div class="boardContent-row">
					<div class="boardContent-td-3space-1">
						<div class="boardContent-title">제목</div>
						<div class="boardContent-header-value"><%=boardContent.getTitle()%></div> 
					</div>
					<div class="boardContent-td-3space-2">
						<div class="boardContent-title">작성자</div>
						<div class="boardContent-subtitle-value"><%=boardContent.getNick()%></div>
					</div>
					<div class="boardContent-td-3space-3">
						<div class="boardContent-title">처리상태</div>
						<div class="boardContent-subtitle-value"><%=boardContent.getState() == 1 ? "처리완료" : "대기중"%></div>
					</div>
				</div>
				<div class="boardContent-row">
					<div class="boardContent-td-3space-1">
						<div class="boardContent-title">장소</div>
						<div class="boardContent-header-value"><%=boardContent.getLocation()%></div> 
					</div> 
						
					<div class="boardContent-td-3space-2">
						<div class="boardContent-title">작성일</div> 
						<div class="boardContent-subtitle-value">
							<span class="ComplainDayText"><%=ComplainDayText%></span> 
						</div>
					</div> 
					<div class="boardContent-td-3space-3">
						<div class="boardContent-title">시간</div> 
						<div class="boardContent-subtitle-value"> 
							<span class="ComplainTime"><%=ComplainTime%></span>
						</div>
					</div> 
				</div> 
				<div class="boardContent-row">
					<div class="boardContent-td-2space-1">
						<div class="boardContent-title">내용</div>
						<div class="boardContent-value-content"><%=boardContent.getContent().replaceAll("\r\n", "<br>")%></div> 
					</div>
					<div class="boardContent-td-2space-2">
						<div class="boardContent-title">사진</div>
						<div class="boardContent-value-img">
						   <img class="boardContent-img" alt="이미지 없음" src="<%=boardContent.getPicture()%>"
						     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/resources/img/no_img.png'">
						</div>
					</div>
				</div> 
			</div>

			<% if(boardComment == null){ %>
			
			<%} else{ 
				Timestamp timestamp = boardComment.getCmt_dt();
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String temp_indate = formatter.format(timestamp); // 포맷된 문자열 반환
		
				// 날짜와 시간을 분리
				String temp_date = temp_indate.split(" ")[0]; // 날짜 부분 "2025-04-11"
		
				// 날짜에서 월과 일 추출
				String[] temp_dateParts = temp_date.split("-"); // ["2025", "04", "11"]
				int temp_month = Integer.parseInt(temp_dateParts[1]); // 월 "04" -> 4
				int temp_day = Integer.parseInt(temp_dateParts[2]); // 일 "11" -> 11
		
				// 월과 일 부분을 글자로 변환
				CommentDayText = temp_month + "월 " + temp_day + "일"; // "4월 11일"
		
				// 시간에서 앞의 0을 제거
				String temp_time = temp_indate.split(" ")[1]; // 시간 부분 "07:50:49"
				String[] temp_timeParts = temp_time.split(":");
				if (temp_timeParts[0].startsWith("0")) {
					temp_timeParts[0] = temp_timeParts[0].substring(1); // 시간에서 앞의 0 제거
				}
		
				// "HH:mm" 형식으로 초를 제거하고 합침
				CommentTime = String.join(":", temp_timeParts[0], temp_timeParts[1]); // "HH:mm" 형식
				%>
				<hr class="complain-comment-line">
				<!-- 민원 답변 -->
				<div class="boardContent-container-comment"> 
					<div class="boardContent-row">
						<div class="boardContent-td-3space-1">
							<div class="boardContent-title">담당자</div>
							<div class="boardContent-header-value"><%=boardComment.getAdmin_name()%></div> 
						</div> 
							
						<div class="boardContent-td-3space-2">
							<div class="boardContent-title">답변일</div>
							<div class="boardContent-subtitle-value">
								<span class="CommentDayText"><%=CommentDayText%></span> 
							</div>
						</div> 
						
						<div class="boardContent-td-3space-3">
							<div class="boardContent-title">시간</div>
							<div class="boardContent-subtitle-value"> 
								<span class="CommentTime"><%=CommentTime%></span>
							</div> 
						</div> 
					</div> 
					
					<div class="boardContent-row">
						<div class="boardContent-td-2space-1">
							<div class="boardContent-title">내용</div>
							<div class="boardContent-value-content"><%=boardComment.getCmt_content().replaceAll("\r\n", "<br>")%></div> 
						</div> 
						<div class="boardContent-td-2space-2">
							<div class="boardContent-title">사진</div>
							<div class="boardContent-value-img">
							   <img class="boardContent-img" alt="이미지 없음" src="<%=boardComment.getCmtfile()%>"
							     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/resources/img/no_img.png'">
							</div>
						</div> 
					</div> 
				</div> 
			<%} %>
		</div> 
		<!-- 푸터 자리 -->
		<div class="page_footer" id="page_footer"></div>
	</div>


<script type="text/javascript">
	//삭제 버튼 클릭 시 확인 메시지 추가
	document.querySelector('.boardContent-btn-form .boardContent-delete-btn').addEventListener('click', function(event) {
	    const passwordForm = document.getElementById('passwordForm');
	    const action = passwordForm.querySelector('input[name="nextAction"]').value;
	
	    // 삭제 요청이 있을 때만 확인 메시지 표시
	    if (action === 'delete') {
	        if (!confirm("정말 삭제하시겠습니까?")) {
	            event.preventDefault();  // 삭제 취소
	        }
	    }
	});

	
    // 비밀번호 입력창 보이기
    function showPasswordForm(event, actionType) {
        event.preventDefault(); // 폼 제출 방지
        document.getElementById('passwordForm').style.visibility = 'visible';
        // 비밀번호 입력 폼에 대한 액션을 설정
        document.querySelector('input[name="nextAction"]').value = actionType;
    }

    // 비밀번호 입력창 숨기기
    function hidePasswordForm() {
        document.getElementById('passwordForm').style.visibility = 'hidden';
    }
    
    function goBack() {
    	// 추후 알고리즘 수정 
    	window.location.href = 'BoardListPage.do';
    }
</script>
	
</body>
</html>

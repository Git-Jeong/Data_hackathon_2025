<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>민원 작성</title>

<!-- Bootstrap 5.3.3 CSS & JS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/Common.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/resources/css/AdressSearch.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/resources/css/userPage/BoardInputForm.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- 헤더/푸터 스크립트 -->
<script
	src="${pageContext.request.contextPath}/resources/js/UserPageHeader.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/PageFooter.js"></script>


<%
String kakaoMapApiKey = (String) request.getAttribute("kakaoMapApiKey");
/*String kakaoMapApiKey = "YOUR_API_KEY";*/
%>
<script type="text/javascript"
	src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=<%=kakaoMapApiKey%>&libraries=services"></script>

</head>

<body>
	<div class="page-wrapper">
		<!-- 유저 페이지 네비바 -->
		<div id="user_header"></div>

		<div class="main_content_container" align="center">

			<h3>민원 접수</h3>

			<form action="BoardInsertPage.do" method="post" enctype="multipart/form-data">
				<div class="boardInsertForm" align="left">
					<label>제목</label> 
						<input type="text" placeholder = "민원 제목을 입력해 주세요. " name="title" required maxlength="25">
					<label>내용</label>
					<textarea  placeholder="내용을 입력해 주세요. " name="content" required maxlength="1000"></textarea>

					<label>민원 발생 장소 </label> 
					<div class="location_input_box">
						<input type="text" id="location" placeholder="장소를 입력해 주세요." name="location" required maxlength="20">
						<button class="location_input_box_button" type="button" onclick="searchPlace()">검색</button>
					</div>
					<ul id="placeList"></ul>
					<div id="detailedAddress"></div>
			
					<label>사진</label> 
					<input type="file" name="input_picture_file"
						accept="image/*" onchange="previewImages(event)">
					<div id="preview"
						style="display:  flex; flex-wrap: wrap; gap: 10px; margin-top: 10px;"></div>


					<label>작성자</label> 
						<input type="text" placeholder="게시글에 표시될 이름을 입력해 주세요." name="nick" required maxlength="20">
					<label>비밀번호</label> 
						<input type="password" placeholder = "글의 수정이나 삭제에 필요합니다. (4~20자리의 비밀번호)"  name="pw" maxlength="20" required  pattern=".{4,20}">
				</div>

				<div align="center">
					<a type="button" class="btn-insert-cancel" href="BoardListPage.do">뒤로가기</a>
					<input type="reset" class="btn-insert-reset" value="초기화"> <input
						type="submit" class="btn-insert-submit" value="작성">
				</div>
			</form>

		</div>

		<!-- 푸터 -->
		<div class="page_footer" id="page_footer"></div>
	</div>
	
	<script
		src="${pageContext.request.contextPath}/resources/js/AddressSearch.js"></script>
		
	<script type="text/javascript">
// 뒤로가기 버튼 클릭 시 확인 창
document.querySelector('.btn-insert-cancel').addEventListener('click', function(event) {
    if (!confirm("정말 뒤로 가시겠습니까?")) {
        event.preventDefault();  // 뒤로가기 버튼 클릭 시 페이지 이동 방지
    }
});

// 되돌리기 버튼 클릭 시 확인 창
document.querySelector('.btn-insert-reset').addEventListener('click', function(event) {
    if (!confirm("정말 되돌리시겠습니까? 입력한 내용이  초기화됩니다.")) {
        event.preventDefault();  // 되돌리기 버튼 클릭 시 동작 방지
    }
});

// 작성 버튼 클릭 시 확인 창
document.querySelector('.btn-insert-submit').addEventListener('click', function(event) {
    if (!confirm("작성된 내용을 등록하시겠습니까?")) {
        event.preventDefault();  // 작성 버튼 클릭 시 폼 제출 방지
    }
});
</script>


<script>
	function previewImages(event) {
	const files = event.target.files;
	const previewContainer = document.getElementById('preview');
	previewContainer.innerHTML = ''; // 기존 썸네일 제거

	Array.from(files).forEach((file, index) => {
		if (!file.type.startsWith('image/')) return;

		const reader = new FileReader();
		reader.onload = function(e) {
			const container = document.createElement('div');
			container.style.position = 'relative';
			
			const img = document.createElement('img');
			img.src = e.target.result;
			img.style.maxWidth = '200px';
			img.style.maxHeight = '200px';
			img.style.objectFit = 'cover';
			
			container.appendChild(img);
			previewContainer.appendChild(container);
		};
		reader.readAsDataURL(file);
	});
}

// 미리보기 갱신 함수
function updatePreview() {
	const previewContainer = document.getElementById('preview');
	previewContainer.innerHTML = '';
	// 삭제 후 업데이트된 이미지 미리보기
	const files = document.querySelector('input[type="file"]').files;
	previewImages({ target: { files } });
}
</script>
</body>
</html>

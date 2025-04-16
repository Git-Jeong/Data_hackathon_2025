<%@page import="com.smhrd.model.ComplainDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>민원 수정</title>

<!-- Bootstrap 5.3.3 CSS & JS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
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
ComplainDTO boardContent = (ComplainDTO) request.getAttribute("boardContent");
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

		<div class="main_content_container">

			<div align="center">
				<h3>민원 수정</h3>
			</div>

			<form action="BoardUpdatePage.do" method="post" id="updateForm" enctype="multipart/form-data">
				<div class="boardInsertForm">
					<input type="hidden" name="cpl_idx"
						value="<%=boardContent.getCpl_idx()%>"> 
						<label>제목</label>
					<input type="text" name="title"
						value="<%=boardContent.getTitle()%>" required maxlength="25"> 
						<label>내용</label>
					<textarea name="content" required maxlength="1000"><%=boardContent.getContent()%></textarea>

					<label>민원 발생 장소 </label> 
					<div class="location_input_box">
						<input type="text" id="location"
							name="location" required value="<%=boardContent.getLocation()%>" maxlength="20">
						<button class="location_input_box_button" type="button" onclick="searchPlace()">검색</button>
					</div>
					<ul id="placeList"></ul>
					<div id="detailedAddress"></div>

					<label>사진</label> <input type="file" name="input_picture_file"
						value="<%=boardContent.getPicture()%>" accept="image/*"
						onchange="previewImages(event)">
					<img id="imagePreview" src="<%=boardContent.getPicture()%>" alt="불러온 이미지" style="width: 200px;" />
						
					<div id="preview"
						style="display: flex; flex-wrap: wrap; gap: 10px; margin-top: 10px;"></div>

					

					<label>작성자</label> <input type="text" name="nick"
						value="<%=boardContent.getNick()%>" required maxlength="20">
				</div>

				<div align="center">
					<a class="btn-update-cancel"
						href="BoardUpdatCancel.do?cpl_idx=<%=boardContent.getCpl_idx()%>">뒤로가기</a>
					<input class="btn-update-reset" type="reset" value="되돌리기">
					<input class="btn-update-submit" type="submit" value="작성">
				</div>
			</form>

		</div>

		<!-- 푸터 -->
		<div class="page_footer" id="page_footer"></div>
	</div>


	<!-- 카카오 지도 API -->
	<script
		src="${pageContext.request.contextPath}/resources/js/AddressSearch.js"></script>
		
	<!-- 사용자 겸험을 위한 기 -->
	<script>
    // 뒤로가기 버튼 클릭 시 확인 창
    document.querySelector('.btn-update-cancel').addEventListener('click', function(event) {
        if (!confirm("정말 뒤로 가시겠습니까? 변경사항이 저장되지 않습니다.")) {
            event.preventDefault();  // 뒤로가기 버튼 클릭 시 페이지 이동 방지
        }
    });

    // 되돌리기 버튼 클릭 시 확인 창
    document.querySelector('.btn-update-reset').addEventListener('click', function(event) {
        if (!confirm("정말 되돌리시겠습니까? 변경사항이 초기화됩니다.")) {
            event.preventDefault();  // 되돌리기 버튼 클릭 시 동작 방지
        }
    });

    // 작성 버튼 클릭 시 확인 창
    document.querySelector('.btn-update-submit').addEventListener('click', function(event) {
        if (!confirm("작성된 내용을 저장하시겠습니까?")) {
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

//이미지가 있을 경우에만 미리보기가 작동하도록 하는 함수
function previewImages(event) {
  const file = event.target.files[0];
  const image = document.getElementById('imagePreview');
  
  if (file) {
    const reader = new FileReader();
    reader.onload = function(e) {
      image.src = e.target.result;  // 파일을 읽어 미리보기 이미지에 표시
    };
    reader.readAsDataURL(file); // 파일을 데이터 URL로 읽기
  }
}

// 페이지 로드 시, 이미지가 이미 있는 경우에는 미리보기 이미지를 표시
window.onload = function() {
  const image = document.getElementById('imagePreview');
  const currentSrc = image.src;
  
  if (currentSrc && currentSrc !== '') {
    image.style.display = 'block';  // 이미지가 있으면 표시
  } else {
    image.style.display = 'none';  // 이미지가 없으면 숨김
  }
}
</script>
	
</body>
</html>

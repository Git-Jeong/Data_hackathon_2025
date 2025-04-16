<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<head>
<meta charset="UTF-8">
<title>결빙 신문고</title>
<link href="${pageContext.request.contextPath}/resources/css/MainPage.css"
	rel="stylesheet">
</head>

<body>
	<div class="snow-container"></div>
	<div class="page-wrapper ">

		<div class="LodingPage_Container">
			<div class="LodingPage_ImgBox">
				<img alt="img"
					src="${pageContext.request.contextPath}/resources/img/메인페이지_이미지_1.png">
			</div>
			
			<div class="LodingPage_TextBox">
				<div class="admin-login-form">
					<h3 class="LodingPage_title">결빙 민원 위험도로 분석 시스템</h3> 
					<h4 class="LodingPage_subtitle">
						결빙 신문고<br> 민원 데이터를 수집<br> 결빙 위험도로를 분석<br>
					</h4>
					<a class="LodingPage_button" href="UserMainPage.do">서비스 시작하기</a>
				</div>
			</div>
		</div>
	</div>

	<script>
	const snowContainer = document.querySelector(".snow-container");

	function createSnowflake() {
		const snowflake = document.createElement("div");
		snowflake.classList.add("snowflake");

		// 랜덤 위치, 크기, 속도
		snowflake.style.left = Math.random() * 100 + "vw";
		snowflake.style.animationDuration = 3 + Math.random() * 5 + "s";
		snowflake.style.opacity = Math.random();
		snowflake.style.width = snowflake.style.height = Math.random() * 8 + 2 + "px";

		snowContainer.appendChild(snowflake, 20);
 
		setTimeout(() => {
			snowflake.remove();
		}, 8000);
	}

	setInterval(createSnowflake, 100);
</script>

</body>


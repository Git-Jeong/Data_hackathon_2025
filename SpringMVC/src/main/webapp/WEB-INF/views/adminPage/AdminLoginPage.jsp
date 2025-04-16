<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link
	href="${pageContext.request.contextPath}/resources/css/MainPage.css"
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
				<form action="AdminLogin.do" method="post" class="admin-login-form">
				  <div class="login-row">
				    <label class="login-label" for="admin_id">ID</label>
				    <input type="text" class="login-input" id="admin_id" name="admin_id" placeholder="아이디 입력" required>
				  </div>
				  <div class="login-row">
				    <label class="login-label" for="admin_pw">PW</label>
				    <input type="password" class="login-input" id="admin_pw" name="admin_pw" placeholder="비밀번호 입력" required>
				  </div>
				  <div class="login-row login-submit-row">
				    <input type="submit" class="login-submit" value="로그인">
				  </div>
				</form>
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


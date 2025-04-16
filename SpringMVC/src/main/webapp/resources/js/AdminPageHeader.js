const headerHTML = `
  <nav class="header navbar navbar-expand-lg navbar-light py-2">
    <div class="container-fluid">
      <a class="header-navbar-brand navbar-brand" href="Admin.do">결빙 신문고(관리자)</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
        aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
          <li class="header-nav-item nav-item px-2">
            <a class="header-nav-link nav-link" href="AdminBoardListPage.do">민원 관리</a>
          </li> 
          <li class="header-nav-item nav-item px-2">
            <a class="header-nav-link nav-link" href="AdminLogout.do">로그아웃</a>
          </li> 
        </ul>
      </div>
    </div>
  </nav>
`;


document.addEventListener("DOMContentLoaded", () => {
  const header = document.getElementById("admin_header");
  if (header) {
    header.innerHTML = headerHTML;
  }
});

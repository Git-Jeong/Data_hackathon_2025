const headerHTML = `
  <nav class="header navbar navbar-expand-lg navbar-light py-2">
    <div class="container-fluid">
      <a class="header-navbar-brand navbar-brand" href="UserMainPage.do">결빙 신문고</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
        aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
          <li class="header-nav-item nav-item dropdown px-2">
            <a class="header-nav-link header-nav-link dropdown-toggle nav-link" id="complaintDropdown" role="button"
              data-bs-toggle="dropdown" aria-expanded="false">
              민원
            </a>
            <ul class="header-dropdown-menu dropdown-menu" aria-labelledby="complaintDropdown">
              <li><a class="header-dropdown-item dropdown-item" href="BoardInsertPage.do">민원접수</a></li>
              <li><a class="header-dropdown-item dropdown-item" href="BoardListPage.do">민원조회</a></li>
            </ul>
          </li>
          <li class="header-nav-item nav-item px-2">
            <a class="header-nav-link nav-link" href="HeatRoadListPage.do">위험도로</a>
          </li> 
        </ul>
      </div>
    </div>
  </nav>
`;


document.addEventListener("DOMContentLoaded", () => {
  const header = document.getElementById("user_header");
  if (header) {
    header.innerHTML = headerHTML;
  }
});

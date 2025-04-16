const footerHTML = `
  <div class="all-page-footer">
    <div class="all-page-footer-container">
      <small class="all-page-footer-text">&copy; 2025 MyCompany. All rights reserved.</small>
    </div>
  </div>
`;

document.addEventListener("DOMContentLoaded", () => {
  const footer = document.getElementById("page_footer");
  if (footer) {
    footer.innerHTML = footerHTML;
  }
});

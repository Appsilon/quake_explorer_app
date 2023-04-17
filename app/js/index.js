export function sentQuakeId(ns, elementId) {
  Shiny.setInputValue(ns.concat('-quake_id'), elementId);
}

export function headerExpand() {
  document.getElementById('app_header').classList.remove('mobile-collapsed');
  document.getElementById('app_header').classList.add('mobile-expanded');
}

export function headerCollapse() {
  document.getElementById('app_header').classList.add('mobile-collapsed');
  document.getElementById('app_header').classList.remove('mobile-expanded');
}

window.onload = () => {
  const toggleButton = document.getElementById('app-btn_tog');
  const appsilonLogo = document.getElementById('app-logo');
  toggleButton.addEventListener('click', () => {
    document.body.classList.toggle('dark-theme');
    if (appsilonLogo.getAttribute('src') === 'static/appsilon-logo.png') {
      appsilonLogo.src = 'static/appsilon-logo-darkmode.png';
    } else {
      appsilonLogo.src = 'static/appsilon-logo.png';
    }
  });
};

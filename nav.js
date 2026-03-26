// nav.js — Gemeinsame Navigation UHC Jonschwil Vipers
// Wird von allen Seiten eingebunden

const NAV_ITEMS = [
  { section: 'Übersicht' },
  { label: 'Dashboard',        href: 'index.html',      icon: '<rect x="2" y="2" width="5" height="5" rx="1" stroke="currentColor" stroke-width="1.3"/><rect x="9" y="2" width="5" height="5" rx="1" stroke="currentColor" stroke-width="1.3"/><rect x="2" y="9" width="5" height="5" rx="1" stroke="currentColor" stroke-width="1.3"/><rect x="9" y="9" width="5" height="5" rx="1" stroke="currentColor" stroke-width="1.3"/>', id: 'dashboard' },
  { label: 'Kalender',         href: 'kalender.html',   icon: '<rect x="2" y="3" width="12" height="11" rx="1.5" stroke="currentColor" stroke-width="1.3"/><line x1="5" y1="1.5" x2="5" y2="4.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><line x1="11" y1="1.5" x2="11" y2="4.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><line x1="2" y1="7" x2="14" y2="7" stroke="currentColor" stroke-width="1.3"/>', id: 'kalender' },
  { section: 'Spielbetrieb' },
  { label: 'Social Media',     href: 'index.html',      icon: '<path d="M2 12L5 7L8 10L11 5L14 9" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/>', id: 'social' },
  { label: 'Spielplan & Teams',href: 'spielplan.html',  icon: '<circle cx="8" cy="8" r="5.5" stroke="currentColor" stroke-width="1.3"/><path d="M8 5.5V8L10 9.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'spielplan' },
  { label: 'Scorer',           href: 'scorer.html',     icon: '<path d="M4 12V6M8 12V4M12 12V8" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'scorer' },
  { section: 'Verein' },
  { label: 'Events',           href: 'events.html',     icon: '<rect x="2" y="2" width="12" height="12" rx="1.5" stroke="currentColor" stroke-width="1.3"/><path d="M5 8H11M5 5.5H11M5 10.5H8.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'events' },
  { label: 'Finanzen',         href: 'finanzen.html',   icon: '<path d="M2 12V4l6-2 6 2v8l-6 2-6-2Z" stroke="currentColor" stroke-width="1.3"/><path d="M8 6v4M6 8h4" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'finanzen' },
  { label: 'Training',         href: 'training.html',   icon: '<circle cx="8" cy="5" r="2.5" stroke="currentColor" stroke-width="1.3"/><path d="M3 14c0-2.76 2.24-5 5-5s5 2.24 5 5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'training' },
  { label: 'Videoanalyse',     href: 'video.html',      icon: '<rect x="2" y="3" width="12" height="9" rx="1" stroke="currentColor" stroke-width="1.3"/><path d="M7 6.5L10.5 8.5L7 10.5V6.5Z" fill="currentColor"/>', id: 'video' },
];

function renderNav(activeId) {
  const currentPage = window.location.pathname.split('/').pop() || 'index.html';

  let html = `
  <aside class="sidebar">
    <div class="logo">
      <div class="logo-mark">
        <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
          <path d="M9 2L16 6V12L9 16L2 12V6L9 2Z" fill="#0c0d0f"/>
          <path d="M6 9L8.5 11.5L12.5 7" stroke="#0c0d0f" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
      <div>
        <div class="logo-name">UHC Jonschwil</div>
        <div class="logo-sub">VIPERS</div>
      </div>
    </div>
    <nav class="nav">`;

  NAV_ITEMS.forEach(item => {
    if (item.section) {
      html += `<div class="nav-sec">${item.section}</div>`;
    } else {
      const isActive = activeId ? item.id === activeId : (currentPage === item.href);
      html += `
      <a class="nav-item${isActive ? ' active' : ''}" href="${item.href}">
        <svg viewBox="0 0 16 16" fill="none">${item.icon}</svg>
        ${item.label}
      </a>`;
    }
  });

  html += `</nav>

    <div style="padding:0 8px 12px">
      <div style="background:var(--bg3);border-radius:8px;border:1px solid var(--border);padding:10px 12px">
        <div style="display:flex;align-items:center;margin-bottom:5px">
          <span style="width:6px;height:6px;border-radius:50%;background:var(--green);margin-right:6px;box-shadow:0 0 6px var(--green)"></span>
          <span style="font-size:11px;color:var(--text2)">Google Calendar</span>
        </div>
        <div style="display:flex;align-items:center;margin-bottom:5px">
          <span style="width:6px;height:6px;border-radius:50%;background:var(--green);margin-right:6px;box-shadow:0 0 6px var(--green)"></span>
          <span style="font-size:11px;color:var(--text2)">Supabase DB</span>
        </div>
        <div style="display:flex;align-items:center">
          <span style="width:6px;height:6px;border-radius:50%;background:var(--amber);margin-right:6px"></span>
          <span style="font-size:11px;color:var(--text2)">Swiss UH API <span style="color:var(--amber);font-size:10px">(ausstehend)</span></span>
        </div>
      </div>
    </div>
  </aside>`;

  document.getElementById('nav-placeholder').outerHTML = html;
}

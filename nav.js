// nav.js — Multi-Verein Navigation

const NAV_ITEMS = [
  { section: 'Übersicht' },
  { label: 'Dashboard',           href: 'dashboard.html',   icon: '<rect x="2" y="2" width="5" height="5" rx="1" stroke="currentColor" stroke-width="1.3"/><rect x="9" y="2" width="5" height="5" rx="1" stroke="currentColor" stroke-width="1.3"/><rect x="2" y="9" width="5" height="5" rx="1" stroke="currentColor" stroke-width="1.3"/><rect x="9" y="9" width="5" height="5" rx="1" stroke="currentColor" stroke-width="1.3"/>', id: 'dashboard' },
  { label: 'Kalender',            href: 'kalender.html',    icon: '<rect x="2" y="3" width="12" height="11" rx="1.5" stroke="currentColor" stroke-width="1.3"/><line x1="5" y1="1.5" x2="5" y2="4.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><line x1="11" y1="1.5" x2="11" y2="4.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><line x1="2" y1="7" x2="14" y2="7" stroke="currentColor" stroke-width="1.3"/>', id: 'kalender' },
  { label: 'Newsfeed',            href: 'news.html',        icon: '<rect x="2" y="3" width="12" height="2" fill="currentColor" opacity=".7"/><rect x="2" y="7" width="9" height="2" fill="currentColor" opacity=".7"/><rect x="2" y="11" width="6" height="2" fill="currentColor" opacity=".7"/>', id: 'news' },
  { section: 'Spielbetrieb' },
  { label: 'Social Media',        href: 'index.html',       icon: '<polyline points="2,12 5,7 8,10 11,5 14,9" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/>', id: 'social' },
  { label: 'Spielplan',           href: 'spielplan.html',   icon: '<circle cx="8" cy="8" r="5.5" stroke="currentColor" stroke-width="1.3"/><polyline points="8,5.5 8,8 10,9.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'spielplan' },
  { label: 'Teams',               href: 'teams.html',        icon: '<circle cx="5" cy="6" r="2.5" stroke="currentColor" stroke-width="1.3"/><circle cx="11" cy="6" r="2.5" stroke="currentColor" stroke-width="1.3"/><path d="M1 13c0-2 1.8-3.5 4-3.5s4 1.5 4 3.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><path d="M9 13c0-2 1.8-3.5 4-3.5s2 1 2 2.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'teams' },
  { label: 'Scorer',              href: 'scorer.html',      icon: '<line x1="4" y1="12" x2="4" y2="6" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><line x1="8" y1="12" x2="8" y2="4" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><line x1="12" y1="12" x2="12" y2="8" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'scorer' },
  { label: 'Kameraplanung',       href: 'kamera.html',      icon: '<rect x="1" y="5" width="10" height="8" rx="1" stroke="currentColor" stroke-width="1.3"/><polyline points="11,7.5 15,5.5 15,12.5 11,10.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/>', id: 'camera' },
  { section: 'Team & Training' },
  { label: 'Training & Video',    href: 'training.html',    icon: '<rect x="2" y="3" width="12" height="9" rx="1" stroke="currentColor" stroke-width="1.3"/><polygon points="7,6.5 10.5,8.5 7,10.5" fill="currentColor"/>', id: 'training' },
  { label: 'Anwesenheit',         href: 'anwesenheit.html', icon: '<rect x="2" y="2" width="12" height="12" rx="1.5" stroke="currentColor" stroke-width="1.3"/><polyline points="5,8 7,10 11,6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>', id: 'anwesenheit' },
  { label: 'Events',              href: 'events.html',      icon: '<rect x="2" y="2" width="12" height="12" rx="1.5" stroke="currentColor" stroke-width="1.3"/><line x1="5" y1="8" x2="11" y2="8" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><line x1="5" y1="5.5" x2="11" y2="5.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><line x1="5" y1="10.5" x2="8.5" y2="10.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'events' },
  { section: 'Finanzen & Verein' },
  { label: 'Finanzen',            href: 'finanzen.html',    icon: '<path d="M2 12V4l6-2 6 2v8l-6 2-6-2z" stroke="currentColor" stroke-width="1.3" fill="none"/><line x1="8" y1="6" x2="8" y2="10" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><line x1="6" y1="8" x2="10" y2="8" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'finanzen' },
  { label: 'Sponsoring',          href: 'sponsoring.html',  icon: '<polygon points="8,2 9.5,5 13,5.5 10.5,8 11,11.5 8,10 5,11.5 5.5,8 3,5.5 6.5,5" stroke="currentColor" stroke-width="1.3" stroke-linejoin="round" fill="none"/>', id: 'sponsoring' },
  { label: 'Inventar',            href: 'inventar.html',    icon: '<rect x="2" y="3" width="12" height="11" rx="1" stroke="currentColor" stroke-width="1.3"/><line x1="5" y1="7" x2="11" y2="7" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><line x1="5" y1="10" x2="9" y2="10" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'inventar' },
  { section: 'Mitglieder' },
  { label: 'Mitglieder & Rollen', href: 'mitglieder.html',  icon: '<circle cx="6" cy="5" r="2.5" stroke="currentColor" stroke-width="1.3"/><path d="M1.5 13c0-2.2 2-4 4.5-4s4.5 1.8 4.5 4" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/><circle cx="11.5" cy="5.5" r="2" stroke="currentColor" stroke-width="1.3"/><path d="M11 9c2 .3 3.5 1.6 3.5 4" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/>', id: 'mitglieder' },
];

const ROLE_HIDDEN = {
  admin:   [],
  trainer: ['finanzen','sponsoring','mitglieder','inventar'],
  spieler: ['finanzen','sponsoring','mitglieder','inventar','camera','anwesenheit','training'],
  eltern:  ['finanzen','sponsoring','mitglieder','inventar','camera','anwesenheit','training','scorer','social']};

// Aktiver Verein — liest aus localStorage, Fallback auf ersten Verein
function getActiveClub() {
  if (typeof APP_CONFIG === 'undefined') return { name:'UHC Jonschwil Vipers', short:'Vipers', primaryColor:'#d4f04a' };
  return APP_CONFIG.ACTIVE_CLUB;
}
function setActiveClub(clubId) {
  localStorage.setItem('vipers_active_club', clubId);
  window.location.reload();
}

function renderNav(activeId) {
  var placeholder = document.getElementById('nav-placeholder');
  if (!placeholder) { console.error('nav-placeholder fehlt'); return; }

  var user = null;
  try { user = JSON.parse(localStorage.getItem('vipers_user') || 'null'); } catch(e) {}
  var club = getActiveClub();
  var rolle = (user && user.role) ? user.role : 'admin';
  var hidden = ROLE_HIDDEN[rolle] || [];
  var clubs = (typeof APP_CONFIG !== 'undefined') ? APP_CONFIG.CLUBS : [];

  // CSS
  if (!document.getElementById('nav-css')) {
    var s = document.createElement('style');
    s.id = 'nav-css';
    s.textContent = [
      '.sidebar{width:230px;flex-shrink:0;background:var(--bg2);border-right:1px solid var(--border);display:flex;flex-direction:column;position:sticky;top:0;height:100vh;overflow-y:auto;z-index:100}',
      '.logo{padding:16px 14px 12px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:9px;flex-shrink:0}',
      '.logo-mark{width:30px;height:30px;border-radius:7px;display:grid;place-items:center;flex-shrink:0}',
      '.logo-name{font-family:"Syne",sans-serif;font-size:12px;font-weight:700;line-height:1.25;flex:1;min-width:0}',
      '.logo-sub{font-size:9px;color:var(--text3);font-family:"DM Mono",monospace;letter-spacing:.1em}',
      /* Club-Switcher */
      '.club-switcher{padding:8px 10px;border-bottom:1px solid var(--border);position:relative}',
      '.club-switcher-btn{width:100%;display:flex;align-items:center;gap:8px;background:var(--bg3);border:1px solid var(--border2);border-radius:8px;padding:7px 10px;cursor:pointer;font-family:"DM Sans",sans-serif;font-size:12px;color:var(--text2);transition:all .15s;text-align:left}',
      '.club-switcher-btn:hover{border-color:var(--border);color:var(--text)}',
      '.club-dot{width:8px;height:8px;border-radius:50%;flex-shrink:0}',
      '.club-name{flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-weight:500}',
      '.club-chevron{color:var(--text3);flex-shrink:0;transition:transform .15s}',
      '.club-dropdown{display:none;position:absolute;top:100%;left:8px;right:8px;background:var(--bg2);border:1px solid var(--border2);border-radius:10px;overflow:hidden;z-index:200;box-shadow:0 8px 24px rgba(0,0,0,.4)}',
      '.club-dropdown.open{display:block}',
      '.club-option{display:flex;align-items:center;gap:10px;padding:10px 14px;cursor:pointer;font-size:13px;color:var(--text2);transition:background .12s;border:none;background:transparent;width:100%;font-family:"DM Sans",sans-serif;text-align:left}',
      '.club-option:hover{background:var(--bg3);color:var(--text)}',
      '.club-option.active{color:var(--text);font-weight:500}',
      '.club-option-check{width:14px;height:14px;margin-left:auto;opacity:0;color:var(--accent)}',
      '.club-option.active .club-option-check{opacity:1}',
      /* Nav */
      '.nav{padding:8px 8px;flex:1;overflow-y:auto}',
      '.nav-sec{font-size:10px;font-weight:600;color:var(--text3);letter-spacing:.1em;text-transform:uppercase;padding:12px 10px 4px}',
      '.nav-item{display:flex;align-items:center;gap:9px;padding:8px 10px;border-radius:8px;font-size:13px;color:var(--text2);cursor:pointer;transition:all .12s;text-decoration:none;font-family:"DM Sans",sans-serif}',
      '.nav-item:hover{background:var(--bg3);color:var(--text)}',
      '.nav-item.active{background:rgba(212,240,74,.1);color:var(--accent);font-weight:500}',
      '.nav-item svg{width:15px;height:15px;flex-shrink:0;opacity:.7}',
      '.nav-item.active svg{opacity:1}',
      /* Footer */
      '.nav-footer{padding:0 8px 10px;display:flex;flex-direction:column;gap:6px}',
      '.nav-user-box{background:var(--bg3);border:1px solid var(--border);border-radius:8px;padding:9px 10px}',
      '.nav-user-row{display:flex;align-items:center;gap:8px;margin-bottom:8px}',
      '.nav-avatar{width:27px;height:27px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:10px;font-weight:700;flex-shrink:0}',
      '.nav-uname{font-size:12px;font-weight:500;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}',
      '.nav-urole{font-size:10px;font-weight:600;text-transform:uppercase;letter-spacing:.06em;margin-top:1px}',
      '.nav-btns{display:flex;gap:5px}',
      '.nav-btn{flex:1;background:transparent;border:1px solid var(--border2);border-radius:6px;padding:5px;font-size:11px;color:var(--text2);cursor:pointer;font-family:"DM Sans",sans-serif;transition:all .12s;text-align:center;text-decoration:none;display:block}',
      '.nav-btn:hover{color:var(--text)}',
      '.nav-btn.red:hover{color:var(--red);border-color:rgba(255,107,107,.3)}',
      '.nav-login{display:block;text-align:center;background:rgba(212,240,74,.1);border:1px solid rgba(212,240,74,.3);border-radius:8px;padding:9px;font-size:12px;color:var(--accent);font-weight:500;text-decoration:none}',
      '.nav-login:hover{background:rgba(212,240,74,.18)}',
      '.nav-status{background:var(--bg3);border:1px solid var(--border);border-radius:8px;padding:7px 11px;display:flex;flex-direction:column;gap:4px}',
      '.nav-status-row{display:flex;align-items:center;gap:6px;font-size:11px;color:var(--text2)}',
      '.ndot{width:6px;height:6px;border-radius:50%;flex-shrink:0}',
      /* Mobile topbar */
      '.nav-topbar{display:none;position:fixed;top:0;left:0;right:0;height:56px;background:var(--bg2);border-bottom:1px solid var(--border);z-index:299;padding:0 16px;align-items:center;justify-content:space-between}',
      '.nav-topbar-logo{display:flex;align-items:center;gap:9px;font-family:"Syne",sans-serif;font-size:14px;font-weight:600;color:var(--text)}',
      '.nav-topbar-logomark{width:28px;height:28px;border-radius:6px;display:grid;place-items:center;flex-shrink:0}',
      '.nav-hamburger{background:transparent;border:1px solid var(--border2);border-radius:7px;padding:5px 7px;cursor:pointer;color:var(--text2);display:flex;align-items:center;transition:all .15s}',
      '.nav-hamburger:hover{color:var(--text);border-color:var(--border)}',
      '.nav-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.65);z-index:298}',
      '.nav-close{display:none;background:transparent;border:none;cursor:pointer;color:var(--text3);padding:4px;border-radius:6px;margin-left:auto}',
      '.nav-close:hover{color:var(--text)}',
      /* Responsive */
      '@media(max-width:768px){',
        '.nav-topbar{display:flex !important}',
        '.shell{flex-direction:column}',
        '.sidebar{position:fixed;top:0;left:0;bottom:0;width:260px;transform:translateX(-100%);transition:transform .25s cubic-bezier(.4,0,.2,1);z-index:300;height:100%}',
        '.sidebar.nav-open{transform:translateX(0)}',
        '.nav-overlay.nav-open{display:block}',
        '.nav-close{display:flex !important}',
        '.main{padding-top:56px !important;width:100%}',
        '.topbar{padding:12px 14px !important}',
        '.page-title{font-size:18px !important}',
        '.content{padding:14px !important}',
        '.stat-grid{grid-template-columns:repeat(2,1fr) !important}',
        '.two-col{grid-template-columns:1fr !important}',
        '.three-col{grid-template-columns:1fr !important}',
        '.form-row-2{grid-template-columns:1fr !important}',
        '.form-row-3{grid-template-columns:1fr !important}',
        '.events-grid{grid-template-columns:1fr !important}',
        '.inv-grid{grid-template-columns:1fr !important}',
        '.modal{margin:10px;width:calc(100% - 20px) !important;max-width:none !important;max-height:92vh}',
      '}',
      '@media(max-width:480px){',
        '.stat-grid{grid-template-columns:1fr 1fr !important}',
        '.btn{font-size:12px;padding:7px 12px}',
        'th,td{padding:8px 10px !important}',
      '}',
    ].join('');
    document.head.appendChild(s);
  }

  // Verein-Farbe dynamisch anwenden
  document.documentElement.style.setProperty('--accent', club.primaryColor || '#d4f04a');
  document.documentElement.style.setProperty('--accent2', (club.primaryColor || '#d4f04a'));

  var roleColor  = {admin: club.primaryColor||'#d4f04a', trainer:'#9b8fff', spieler:'#5bbfff', eltern:'#4dd68c'}[rolle] || '#888';
  var roleLabel  = {admin:'Admin', trainer:'Trainer', spieler:'Spieler', eltern:'Eltern'}[rolle] || rolle;
  var initials   = user ? ((user.first_name||'?')[0]+(user.last_name||'?')[0]).toUpperCase() : '??';

  // Nav Items
  var navHtml = '';
  NAV_ITEMS.forEach(function(item) {
    if (item.section) { navHtml += '<div class="nav-sec">'+item.section+'</div>'; return; }
    if (hidden.indexOf(item.id) >= 0) return;
    var active = activeId === item.id;
    navHtml += '<a class="nav-item'+(active?' active':'')+'" href="'+item.href+'">'
      +'<svg viewBox="0 0 16 16" fill="none">'+item.icon+'</svg>'
      +item.label+'</a>';
  });

  // Club Switcher
  var switcherHtml = '';
  if (clubs.length > 1) {
    switcherHtml = '<div class="club-switcher">'
      +'<button class="club-switcher-btn" onclick="toggleClubDropdown(event)">'
      +'<span class="club-dot" style="background:'+club.primaryColor+'"></span>'
      +'<span class="club-name">'+club.short+'</span>'
      +'<svg class="club-chevron" viewBox="0 0 16 16" width="12" height="12" fill="none"><path d="M4 6l4 4 4-4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>'
      +'</button>'
      +'<div class="club-dropdown" id="club-dropdown">'
      +clubs.map(function(c) {
        var isActive = c.club_id === club.club_id;
        return '<button class="club-option'+(isActive?' active':'')+'" onclick="setActiveClub(\''+c.club_id+'\')">'
          +'<span class="club-dot" style="background:'+c.primaryColor+'"></span>'
          +'<span style="flex:1;text-align:left">'+c.name+'</span>'
          +'<svg class="club-option-check" viewBox="0 0 12 12" width="12" height="12" fill="none"><path d="M2 6l3 3 5-5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>'
          +'</button>';
      }).join('')
      +'</div></div>';
  }

  // Footer
  var footerHtml = '';
  if (user) {
    footerHtml = '<div class="nav-user-box">'
      +'<div class="nav-user-row">'
      +'<div class="nav-avatar" style="background:'+roleColor+'22;color:'+roleColor+'">'+initials+'</div>'
      +'<div style="flex:1;min-width:0"><div class="nav-uname">'+user.first_name+' '+user.last_name+'</div>'
      +'<div class="nav-urole" style="color:'+roleColor+'">'+roleLabel+'</div></div></div>'
      +'<div class="nav-btns">'
      +'<a href="profil.html" class="nav-btn">Profil</a>'
      +'<button class="nav-btn red" onclick="navLogout()">Abmelden</button>'
      +'</div></div>';
  } else {
    footerHtml = '<a href="login.html" class="nav-login">Anmelden</a>';
  }
  footerHtml += '<div class="nav-status">'
    +'<div class="nav-status-row"><span class="ndot" style="background:#4dd68c;box-shadow:0 0 5px #4dd68c"></span>Supabase DB</div>'
    +'<div class="nav-status-row"><span class="ndot" style="background:'+(club.gcal_id?'#4dd68c':'#ffbe47')+';'+(club.gcal_id?'box-shadow:0 0 5px #4dd68c':'')+'"></span>Google Calendar'+(club.gcal_id?'':'<span style="color:#ffbe47;font-size:10px;margin-left:4px">(konfigurieren)</span>')+'</div>'
    +'</div>';

  var html = ''
    +'<div class="nav-topbar">'
    +'<div class="nav-topbar-logo">'
    +'<div class="nav-topbar-logomark" style="background:'+club.primaryColor+'">'
    +'<svg viewBox="0 0 18 18" fill="none" width="16" height="16"><path d="M9 2L16 6V12L9 16L2 12V6Z" fill="#0c0d0f"/><path d="M6 9L8.5 11.5L12.5 7" stroke="#0c0d0f" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>'
    +'</div>'+club.short+'</div>'
    +'<button class="nav-hamburger" onclick="navToggle()" aria-label="Menü">'
    +'<svg viewBox="0 0 22 22" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">'
    +'<line x1="3" y1="6" x2="19" y2="6"/><line x1="3" y1="11" x2="19" y2="11"/><line x1="3" y1="16" x2="19" y2="16"/>'
    +'</svg></button></div>'
    +'<div class="nav-overlay" id="nav-overlay" onclick="navClose()"></div>'
    +'<aside class="sidebar" id="sidebar">'
    +'<div class="logo">'
    +'<div class="logo-mark" style="background:'+club.primaryColor+'">'
    +'<svg viewBox="0 0 18 18" fill="none" width="16" height="16"><path d="M9 2L16 6V12L9 16L2 12V6Z" fill="#0c0d0f"/><path d="M6 9L8.5 11.5L12.5 7" stroke="#0c0d0f" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>'
    +'</div>'
    +'<div style="flex:1;min-width:0"><div class="logo-name">'+club.name+'</div><div class="logo-sub">VEREINSPLATTFORM</div></div>'
    +'<button class="nav-close" onclick="navClose()"><svg viewBox="0 0 16 16" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"><line x1="3" y1="3" x2="13" y2="13"/><line x1="13" y1="3" x2="3" y2="13"/></svg></button>'
    +'</div>'
    +switcherHtml
    +'<nav class="nav">'+navHtml+'</nav>'
    +'<div class="nav-footer">'+footerHtml+'</div>'
    +'</aside>';

  placeholder.outerHTML = html;

  // Nav-Links mobile schliessen
  document.querySelectorAll('.nav-item').forEach(function(a) {
    a.addEventListener('click', function() { if (window.innerWidth <= 768) navClose(); });
  });

  // Dropdown schliessen bei Klick ausserhalb
  document.addEventListener('click', function(e) {
    if (!e.target.closest('.club-switcher')) {
      var dd = document.getElementById('club-dropdown');
      if (dd) dd.classList.remove('open');
    }
  }, { capture: true, once: false });
}

function toggleClubDropdown(e) {
  e.stopPropagation();
  var dd = document.getElementById('club-dropdown');
  if (dd) dd.classList.toggle('open');
}
function navToggle() {
  var sb = document.getElementById('sidebar');
  var ov = document.getElementById('nav-overlay');
  if (!sb) return;
  sb.classList.toggle('nav-open');
  ov.classList.toggle('nav-open');
  document.body.style.overflow = sb.classList.contains('nav-open') ? 'hidden' : '';
}
function navClose() {
  var sb = document.getElementById('sidebar');
  var ov = document.getElementById('nav-overlay');
  if (!sb) return;
  sb.classList.remove('nav-open');
  ov.classList.remove('nav-open');
  document.body.style.overflow = '';
}
function navLogout() {
  localStorage.removeItem('vipers_user');
  window.location.href = 'login.html';
}

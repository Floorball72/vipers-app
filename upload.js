// upload.js — Stackflow Upload Modul (Supabase Storage)
const UPLOAD = {
  modes: {
    belege:   { allowed: ['image/jpeg','image/png','image/webp','application/pdf'], label: 'JPG, PNG oder PDF', accept: '.jpg,.jpeg,.png,.webp,.pdf', maxMB: 10 },
    videos:   { allowed: ['video/mp4','video/quicktime','video/webm'], label: 'MP4, MOV oder WebM', accept: '.mp4,.mov,.webm', maxMB: 500 },
    inventar: { allowed: ['image/jpeg','image/png','image/webp'], label: 'JPG oder PNG', accept: '.jpg,.jpeg,.png,.webp', maxMB: 5 },
    logos:    { allowed: ['image/jpeg','image/png','image/webp','image/svg+xml'], label: 'JPG, PNG oder SVG', accept: '.jpg,.jpeg,.png,.webp,.svg', maxMB: 5 },
    default:  { allowed: ['image/jpeg','image/png','image/webp','application/pdf','video/mp4','video/quicktime'], label: 'Bild, PDF oder Video', accept: '.jpg,.jpeg,.png,.webp,.pdf,.mp4,.mov', maxMB: 50 }
  },
  BUCKET: 'stackflow',
  _client: null,
  async client() {
    if (this._client) return this._client;
    const mod = await import('https://esm.sh/@supabase/supabase-js@2.39.0');
    this._client = mod.createClient(APP_CONFIG.SUPABASE_URL, APP_CONFIG.SUPABASE_ANON_KEY);
    return this._client;
  },

  render(container, opts = {}) {
    const el = typeof container === 'string' ? document.getElementById(container) : container;
    if (!el) return;
    const folder = opts.folder || 'belege';
    const mode = this.modes[folder] || this.modes.default;
    const id = 'upw-' + Math.random().toString(36).slice(2,8);
    const label = opts.label || 'Datei hochladen';
    const optsJson = JSON.stringify(opts).replace(/"/g,'&quot;');

    el.innerHTML = opts.existingUrl
      ? `<div style="display:flex;align-items:center;justify-content:space-between;padding:8px 12px;background:var(--bg3);border:1px solid var(--border2);border-radius:8px">
           <a href="${opts.existingUrl}" target="_blank" style="font-size:12px;color:var(--blue)">Datei ansehen →</a>
           <button onclick="UPLOAD._clear('${id}')" style="background:none;border:none;color:var(--text3);cursor:pointer;font-size:18px;line-height:1;padding:0 4px">×</button>
         </div>`
      : `<div id="${id}" style="font-family:'DM Sans',sans-serif">
           <label id="${id}-zone" style="display:flex;flex-direction:column;align-items:center;gap:8px;padding:16px;border:1px dashed var(--border2);border-radius:8px;cursor:pointer;text-align:center"
             for="${id}-input"
             ondragover="event.preventDefault();this.style.borderColor='var(--accent)'"
             ondragleave="this.style.borderColor=''"
             ondrop="event.preventDefault();this.style.borderColor='';UPLOAD._drop('${id}',event,${optsJson})">
             <input type="file" id="${id}-input" accept="${mode.accept}" style="display:none"
               onchange="UPLOAD._pick('${id}',this,${optsJson})">
             <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--text3)" stroke-width="1.5" stroke-linecap="round"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4M17 8l-5-5-5 5M12 3v12"/></svg>
             <span style="font-size:12px;color:var(--text3)">${label}</span>
             <span style="font-size:11px;color:var(--text3)">${mode.label} &middot; max. ${mode.maxMB} MB</span>
           </label>
           <div id="${id}-prog" style="display:none;margin-top:8px">
             <div style="background:var(--bg3);border-radius:4px;height:4px;overflow:hidden"><div id="${id}-bar" style="height:100%;background:var(--accent);width:0%;transition:width .3s"></div></div>
             <span id="${id}-lbl" style="font-size:11px;color:var(--text3);margin-top:4px;display:block">Hochladen...</span>
           </div>
           <div id="${id}-err" style="display:none;font-size:12px;color:var(--red);margin-top:6px"></div>
         </div>`;
  },

  _clear(id) {
    const w = document.getElementById(id); if (w) w.innerHTML = '';
  },
  _drop(id, event, opts) {
    const f = event.dataTransfer?.files?.[0]; if (f) this._go(id, f, opts);
  },
  _pick(id, input, opts) {
    const f = input.files?.[0]; if (f) this._go(id, f, opts);
  },

  async _go(id, file, opts) {
    const folder = opts.folder || 'belege';
    const mode = this.modes[folder] || this.modes.default;
    const err = document.getElementById(id+'-err');
    const prog = document.getElementById(id+'-prog');
    const bar = document.getElementById(id+'-bar');
    const lbl = document.getElementById(id+'-lbl');
    const zone = document.getElementById(id+'-zone');

    // Validierung
    const typeOk = mode.allowed.some(t => file.type === t || file.type.startsWith(t.split('/')[0]+'/') && t.endsWith('*'));
    if (!mode.allowed.includes(file.type)) {
      // Prüfe Dateiendung als Fallback
      const ext = '.'+file.name.split('.').pop().toLowerCase();
      if (!mode.accept.split(',').includes(ext)) {
        if (err) { err.textContent = 'Dateityp nicht erlaubt.'; err.style.display='block'; } return;
      }
    }
    if (file.size > mode.maxMB*1024*1024) {
      if (err) { err.textContent = 'Datei zu gross (max '+mode.maxMB+' MB)'; err.style.display='block'; } return;
    }

    if (err) err.style.display='none';
    if (zone) zone.style.display='none';
    if (prog) prog.style.display='block';
    if (bar) bar.style.width='20%';
    if (lbl) lbl.textContent='Verbinde...';

    try {
      const sb = await this.client();
      if (bar) bar.style.width='50%';
      if (lbl) lbl.textContent='Hochladen...';

      const ext = file.name.split('.').pop();
      const path = folder+'/'+Date.now()+'_'+Math.random().toString(36).slice(2,8)+'.'+ext;

      const { error: upErr } = await sb.storage.from(this.BUCKET).upload(path, file, { cacheControl:'3600', upsert:false });
      if (upErr) throw upErr;

      if (bar) bar.style.width='90%';
      const { data: { publicUrl } } = sb.storage.from(this.BUCKET).getPublicUrl(path);
      if (bar) bar.style.width='100%';
      if (prog) setTimeout(()=>{ prog.style.display='none'; },600);

      // Erfolg-Anzeige
      const w = document.getElementById(id);
      if (w) w.innerHTML = `<div style="display:flex;align-items:center;justify-content:space-between;padding:8px 12px;background:rgba(77,214,140,.07);border:1px solid rgba(77,214,140,.2);border-radius:8px">
        <span style="font-size:12px;color:var(--green)">&#10003; ${file.name}</span>
        <a href="${publicUrl}" target="_blank" style="font-size:11px;color:var(--blue)">Ansehen</a>
      </div>`;

      if (opts.onSuccess) opts.onSuccess(publicUrl, file.name);
    } catch(e) {
      if (prog) prog.style.display='none';
      if (zone) zone.style.display='flex';
      const msg = e.message?.includes('row-level') || e.message?.includes('Bucket')
        ? 'Storage-Bucket "stackflow" fehlt. Bitte in Supabase erstellen.'
        : (e.message||'Upload fehlgeschlagen');
      if (err) { err.textContent=msg; err.style.display='block'; }
      if (opts.onError) opts.onError(msg);
      console.error('Upload:', e);
    }
  }
};

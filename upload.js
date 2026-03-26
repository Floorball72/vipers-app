// upload.js — Supabase Storage Upload Modul
// Einbinden: <script src="upload.js"></script>
// Voraussetzung: config.js muss vorher geladen sein
//
// Supabase Storage Setup (einmalig im Dashboard):
//   Storage → New bucket → Name: "belege" → Public: OFF
//   Policies → New policy → "Authenticated users can upload/read"

const UPLOAD = {
  bucket: 'belege',
  maxSizeMB: 10,
  allowed: ['image/jpeg','image/png','image/webp','application/pdf'],
  allowedLabel: 'JPG, PNG, WebP oder PDF',

  // Gibt einen Supabase-Client zurück (nutzt den bereits initialisierten oder erstellt einen)
  _client: null,
  async client() {
    if (this._client) return this._client;
    const mod = await import('https://esm.sh/@supabase/supabase-js@2');
    this._client = mod.createClient(APP_CONFIG.SUPABASE_URL, APP_CONFIG.SUPABASE_ANON_KEY);
    return this._client;
  },

  // Rendert ein Upload-Widget in ein Element
  // container: DOM-Element oder ID-String
  // opts: { label, onSuccess(url, name), onError(msg), existingUrl }
  render(container, opts = {}) {
    const el = typeof container === 'string' ? document.getElementById(container) : container;
    if (!el) return;
    const id = 'upw-' + Math.random().toString(36).slice(2, 8);
    el.innerHTML = `
      <div class="upload-widget" id="${id}">
        ${opts.existingUrl ? `
          <div class="upload-existing" id="${id}-existing">
            <div class="upload-existing-info">
              <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
                <path d="M4 2h6l4 4v8H4V2z" stroke="currentColor" stroke-width="1.3" stroke-linejoin="round"/>
                <path d="M10 2v4h4" stroke="currentColor" stroke-width="1.3" stroke-linejoin="round"/>
              </svg>
              <a href="${opts.existingUrl}" target="_blank" class="upload-existing-link">Beleg ansehen</a>
            </div>
            <button class="upload-remove-btn" onclick="UPLOAD._clear('${id}', ${JSON.stringify(opts).replace(/"/g, '&quot;')})">Entfernen</button>
          </div>
        ` : `
          <label class="upload-dropzone" id="${id}-zone" for="${id}-input">
            <input type="file" id="${id}-input" accept=".jpg,.jpeg,.png,.webp,.pdf" style="display:none"
              onchange="UPLOAD._onFile('${id}', this, ${JSON.stringify(opts.label||'').replace(/"/g, '&quot;')})">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
              <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4M17 8l-5-5-5 5M12 3v12"/>
            </svg>
            <div class="upload-hint">
              <span>${opts.label || 'Beleg hochladen'}</span>
              <span class="upload-hint-sub">${this.allowedLabel} · max. ${this.maxSizeMB} MB</span>
            </div>
          </label>
        `}
        <div class="upload-progress" id="${id}-prog" style="display:none">
          <div class="upload-progress-bar" id="${id}-bar"></div>
          <span class="upload-progress-label" id="${id}-label">Hochladen...</span>
        </div>
        <div class="upload-error" id="${id}-err" style="display:none"></div>
      </div>`;

    // Drag & Drop
    const zone = document.getElementById(id + '-zone');
    if (zone) {
      zone.addEventListener('dragover', e => { e.preventDefault(); zone.classList.add('dragover'); });
      zone.addEventListener('dragleave', () => zone.classList.remove('dragover'));
      zone.addEventListener('drop', e => {
        e.preventDefault(); zone.classList.remove('dragover');
        const file = e.dataTransfer.files[0];
        if (file) UPLOAD._upload(id, file, opts);
      });
    }

    // Callbacks auf Widget speichern
    UPLOAD._callbacks = UPLOAD._callbacks || {};
    UPLOAD._callbacks[id] = opts;
  },

  _onFile(id, input, label) {
    const file = input.files[0];
    if (!file) return;
    const opts = (UPLOAD._callbacks || {})[id] || {};
    UPLOAD._upload(id, file, opts);
  },

  async _upload(id, file, opts) {
    // Validierung
    if (!this.allowed.includes(file.type)) {
      this._showErr(id, `Nicht erlaubter Dateityp. Erlaubt: ${this.allowedLabel}`);
      return;
    }
    if (file.size > this.maxSizeMB * 1024 * 1024) {
      this._showErr(id, `Datei zu gross. Maximum: ${this.maxSizeMB} MB`);
      return;
    }

    this._showProgress(id, 0);

    try {
      const supabase = await this.client();
      const ext = file.name.split('.').pop().toLowerCase();
      const folder = opts.folder || 'allgemein';
      const filename = `${folder}/${Date.now()}-${Math.random().toString(36).slice(2,8)}.${ext}`;

      // Upload mit Progress-Simulation (Supabase SDK hat kein Progress-Event)
      let prog = 10;
      const ticker = setInterval(() => {
        prog = Math.min(prog + 15, 85);
        this._showProgress(id, prog);
      }, 200);

      const { data, error } = await supabase.storage
        .from(this.bucket)
        .upload(filename, file, { cacheControl: '3600', upsert: false });

      clearInterval(ticker);

      if (error) {
        this._showErr(id, this._friendlyError(error.message));
        return;
      }

      // Public URL holen
      const { data: { publicUrl } } = supabase.storage.from(this.bucket).getPublicUrl(filename);

      this._showProgress(id, 100);
      setTimeout(() => {
        this._showSuccess(id, publicUrl, file.name);
        if (opts.onSuccess) opts.onSuccess(publicUrl, file.name);
      }, 300);

    } catch (e) {
      this._showErr(id, 'Upload fehlgeschlagen: ' + (e.message || 'Unbekannter Fehler'));
    }
  },

  _showProgress(id, pct) {
    const prog = document.getElementById(id + '-prog');
    const bar  = document.getElementById(id + '-bar');
    const lbl  = document.getElementById(id + '-label');
    const zone = document.getElementById(id + '-zone');
    if (zone) zone.style.display = 'none';
    if (prog) prog.style.display = 'flex';
    if (bar)  bar.style.width = pct + '%';
    if (lbl)  lbl.textContent = pct < 100 ? `Hochladen... ${pct}%` : 'Fertig!';
  },

  _showSuccess(id, url, name) {
    const widget = document.getElementById(id);
    if (!widget) return;
    widget.innerHTML = `
      <div class="upload-existing">
        <div class="upload-existing-info">
          <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
            <path d="M4 2h6l4 4v8H4V2z" stroke="currentColor" stroke-width="1.3" stroke-linejoin="round"/>
            <path d="M10 2v4h4" stroke="currentColor" stroke-width="1.3" stroke-linejoin="round"/>
          </svg>
          <a href="${url}" target="_blank" class="upload-existing-link">${name}</a>
          <span style="font-size:10px;color:var(--green);margin-left:4px">✓ Hochgeladen</span>
        </div>
        <button class="upload-remove-btn" onclick="UPLOAD._resetWidget('${id}')">Entfernen</button>
      </div>`;
  },

  _showErr(id, msg) {
    const prog = document.getElementById(id + '-prog');
    const zone = document.getElementById(id + '-zone');
    const err  = document.getElementById(id + '-err');
    if (prog) prog.style.display = 'none';
    if (zone) zone.style.display = '';
    if (err)  { err.textContent = msg; err.style.display = 'block'; }
    setTimeout(() => { if (err) err.style.display = 'none'; }, 5000);
  },

  _clear(id, opts) {
    const widget = document.getElementById(id);
    if (!widget) return;
    if (opts.onSuccess) opts.onSuccess(null, null);
    UPLOAD.render(widget, {...opts, existingUrl: null});
  },

  _resetWidget(id) {
    const opts = (UPLOAD._callbacks || {})[id] || {};
    const widget = document.getElementById(id);
    if (!widget) return;
    UPLOAD.render(widget, {...opts, existingUrl: null});
    if (opts.onSuccess) opts.onSuccess(null, null);
  },

  _friendlyError(msg) {
    if (msg.includes('Bucket not found'))    return 'Storage-Bucket "belege" nicht gefunden. Bitte in Supabase erstellen (siehe README).';
    if (msg.includes('not authorized'))      return 'Nicht autorisiert. Bitte einloggen.';
    if (msg.includes('Payload too large'))   return `Datei zu gross (max. ${this.maxSizeMB} MB).`;
    if (msg.includes('duplicate'))           return 'Diese Datei existiert bereits.';
    return msg;
  },

  // CSS einmalig einfügen
  injectCSS() {
    if (document.getElementById('upload-css')) return;
    const s = document.createElement('style');
    s.id = 'upload-css';
    s.textContent = `
      .upload-widget{width:100%}
      .upload-dropzone{display:flex;align-items:center;gap:12px;padding:14px 16px;border:1px dashed var(--border2);border-radius:8px;cursor:pointer;transition:all .15s;color:var(--text3)}
      .upload-dropzone:hover,.upload-dropzone.dragover{border-color:var(--accent);color:var(--accent);background:rgba(212,240,74,.04)}
      .upload-dropzone.dragover{border-style:solid}
      .upload-hint{display:flex;flex-direction:column;gap:2px}
      .upload-hint span:first-child{font-size:13px;font-weight:500;color:var(--text2)}
      .upload-hint-sub{font-size:11px;color:var(--text3)}
      .upload-progress{display:flex;align-items:center;gap:10px;padding:12px 0}
      .upload-progress-bar-bg{flex:1;height:4px;background:var(--border);border-radius:2px;overflow:hidden}
      .upload-progress-bar{height:4px;background:var(--accent);border-radius:2px;transition:width .2s;width:0%}
      .upload-progress-label{font-size:12px;color:var(--text2);white-space:nowrap}
      .upload-error{font-size:12px;color:var(--red);padding:8px 12px;background:rgba(255,107,107,.08);border:1px solid rgba(255,107,107,.2);border-radius:7px;margin-top:6px}
      .upload-existing{display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:rgba(77,214,140,.06);border:1px solid rgba(77,214,140,.2);border-radius:8px}
      .upload-existing-info{display:flex;align-items:center;gap:8px;color:var(--green)}
      .upload-existing-link{font-size:13px;color:var(--green);font-weight:500;text-decoration:none;max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
      .upload-existing-link:hover{text-decoration:underline}
      .upload-remove-btn{background:transparent;border:1px solid var(--border2);border-radius:6px;padding:4px 10px;font-size:11px;color:var(--text3);cursor:pointer;font-family:"DM Sans",sans-serif;transition:all .12s}
      .upload-remove-btn:hover{color:var(--red);border-color:rgba(255,107,107,.3)}
    `;
    document.head.appendChild(s);
  }
};

// CSS sofort einbinden
UPLOAD.injectCSS();

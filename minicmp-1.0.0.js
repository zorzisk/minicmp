/*!
 * MiniCMP v1.0.0
 * A small, dependency-free cookie consent banner and preference centre.
 * It stores the visitor's choice in a first-party cookie and pushes events to the dataLayer.
 * It does not set Google Consent Mode itself: read the cookie and the events in Google Tag Manager.
 *
 * Configure by defining window.MiniCMPConfig before this script runs. Every setting is optional.
 * Written in ES5 so it runs anywhere, including a GTM Custom HTML tag.
 */
(function (window, document) {
  'use strict';

  if (window.MiniCMP && window.MiniCMP._initialised) { return; }

  // ---------------------------------------------------------------------------
  // Defaults (every value can be overridden in window.MiniCMPConfig)
  // ---------------------------------------------------------------------------
  var DEFAULTS = {
    cookieName: 'site_consent',
    cookieDomain: '',            // e.g. '.example.com' to share across subdomains; '' = current host
    version: 1,                  // raise it to ask every visitor again
    expiryDays: 180,
    dataLayerName: 'dataLayer',
    openSelector: '[data-cmp-open], a[href="#cookie-settings"]',
    zIndex: 2147483000,
    cookieListSelector: '[data-cmp-cookie-list]',
    cookies: [],                 // [{ name, provider, category, purpose, expiry }] rendered into cookieListSelector elements
    cookieListHeaders: { name: 'Cookie', provider: 'Provider', purpose: 'Purpose', expiry: 'Expiry' },
    cookieListCss: '',           // CSS added to the page for the cookie list, e.g. '.cmp-cookie-table td{padding:8px}'
    floatingButton: {
      enabled: false,            // true shows a small "Cookie settings" button after a choice is made
      text: 'Cookie settings',
      position: 'left',          // 'left' or 'right' (bottom corner)
      css: ''                    // extra CSS for the button, applied inside the banner's Shadow DOM; select it with .reopen
    },
    categories: [
      { key: 'analytics', title: 'Analytics', description: 'Helps us understand how the site is used.' },
      { key: 'advertising', title: 'Advertising', description: 'Measures advertising and lets ad platforms attribute conversions.' }
    ],
    essential: {
      title: 'Essential',
      description: 'Needed for the site to work, including remembering your cookie choices.',
      label: 'Always on'
    },
    text: {
      bannerLabel: 'Cookie consent',
      bannerText: "We use cookies to make this site work and, with your agreement, to understand how it's used and to measure advertising. You can change your choice at any time.",
      privacyLinkText: 'Read the privacy note',
      privacyUrl: '/privacy',
      acceptAll: 'Accept all',
      rejectAll: 'Reject non-essential',
      customise: 'Customise',
      prefTitle: 'Cookie settings',
      save: 'Save preferences',
      close: 'Close',
      cookieListText: 'See the cookie list',
      cookieListUrl: ''           // '' hides the link
    },
    theme: {
      fontFamily: 'inherit',      // 'inherit' uses the site's own font
      fontSize: '15px',
      text: '#131A4F',
      background: '#FFFFFF',
      primary: '#2B4BFF',
      primaryText: '#FFFFFF',
      border: '#131A4F',
      link: '#2B4BFF',
      toggleOff: '#EEF1FF',
      divider: '#C9CEE6',
      overlay: 'rgba(19, 26, 79, 0.5)',
      radius: '4px'
    },
    events: {
      update: 'consent_update',
      dismiss: 'consent_dismiss'
    }
  };

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  function merge(base, extra) {
    var out = {}, k;
    for (k in base) { if (Object.prototype.hasOwnProperty.call(base, k)) { out[k] = base[k]; } }
    if (!extra) { return out; }
    for (k in extra) {
      if (!Object.prototype.hasOwnProperty.call(extra, k)) { continue; }
      var b = base[k], e = extra[k];
      if (b && e && typeof b === 'object' && typeof e === 'object' && !(b instanceof Array) && !(e instanceof Array)) {
        out[k] = merge(b, e);
      } else {
        out[k] = e;
      }
    }
    return out;
  }

  var cfg = merge(DEFAULTS, window.MiniCMPConfig || {});
  var keys = [];
  for (var c = 0; c < cfg.categories.length; c++) { keys.push(cfg.categories[c].key); }

  function el(tag, attrs, text) {
    var node = document.createElement(tag), a;
    if (attrs) { for (a in attrs) { if (Object.prototype.hasOwnProperty.call(attrs, a)) { node.setAttribute(a, attrs[a]); } } }
    if (text !== undefined && text !== null) { node.textContent = text; }
    return node;
  }

  // ---------------------------------------------------------------------------
  // Cookie
  // ---------------------------------------------------------------------------
  function readRaw() {
    var parts = document.cookie ? document.cookie.split('; ') : [];
    for (var i = 0; i < parts.length; i++) {
      var idx = parts[i].indexOf('=');
      if (parts[i].substring(0, idx) === cfg.cookieName) { return parts[i].substring(idx + 1); }
    }
    return null;
  }

  function cookieAttrs(maxAge) {
    var s = '; Path=/; SameSite=Lax; Max-Age=' + maxAge;
    if (cfg.cookieDomain) { s += '; Domain=' + cfg.cookieDomain; }
    if (window.location.protocol === 'https:') { s += '; Secure'; }
    return s;
  }

  function deleteCookie() { document.cookie = cfg.cookieName + '=' + cookieAttrs(0); }

  function writeCookie(state) {
    var maxAge = Math.round(cfg.expiryDays * 24 * 60 * 60);
    document.cookie = cfg.cookieName + '=' + encodeURIComponent(JSON.stringify(state)) + cookieAttrs(maxAge);
  }

  function readState() {
    var raw = readRaw();
    if (!raw) { return null; }
    var state;
    try { state = JSON.parse(decodeURIComponent(raw)); } catch (e) { deleteCookie(); return null; }
    var expired = !state || typeof state.t !== 'number' || (Date.now() - state.t) > cfg.expiryDays * 86400000;
    if (!state || state.v !== cfg.version || expired) { deleteCookie(); return null; }
    for (var i = 0; i < keys.length; i++) {
      if (state[keys[i]] !== 'granted' && state[keys[i]] !== 'denied') { deleteCookie(); return null; }
    }
    return state;
  }

  // ---------------------------------------------------------------------------
  // dataLayer
  // ---------------------------------------------------------------------------
  function push(eventName, params) {
    var dl = window[cfg.dataLayerName] = window[cfg.dataLayerName] || [];
    var payload = {
      event: eventName,
      element_id: undefined,
      element_type: undefined,
      element_text: undefined,
      element_location: 'consent',
      consent_action: undefined,
      close_method: undefined
    };
    for (var i = 0; i < keys.length; i++) { payload[keys[i] + '_consent'] = undefined; }
    for (var p in params) { if (Object.prototype.hasOwnProperty.call(params, p)) { payload[p] = params[p]; } }
    dl.push(payload);
  }

  // ---------------------------------------------------------------------------
  // Styles (scoped inside the Shadow DOM)
  // ---------------------------------------------------------------------------
  function css() {
    var t = cfg.theme;
    return '' +
      ':host{' +
        '--cmp-font:' + (t.fontFamily === 'inherit' ? 'inherit' : t.fontFamily) + ';--cmp-size:' + t.fontSize + ';--cmp-text:' + t.text + ';' +
        '--cmp-bg:' + t.background + ';--cmp-primary:' + t.primary + ';--cmp-primary-text:' + t.primaryText + ';' +
        '--cmp-border:' + t.border + ';--cmp-link:' + t.link + ';--cmp-off:' + t.toggleOff + ';' +
        '--cmp-overlay:' + t.overlay + ';--cmp-radius:' + t.radius + ';--cmp-divider:' + t.divider + ';}' +
      '*{box-sizing:border-box;}' +
      '.root{' + (t.fontFamily && t.fontFamily !== 'inherit' ? 'font-family:var(--cmp-font);' : '') +
        'font-size:var(--cmp-size);line-height:1.5;color:var(--cmp-text);font-weight:400;font-style:normal;' +
        'letter-spacing:normal;text-transform:none;text-align:left;white-space:normal;}' +
      'h2,h3{font-weight:600;}' +
      '[hidden]{display:none!important;}' +
      '.banner{position:fixed;left:0;right:0;bottom:0;z-index:' + cfg.zIndex + ';background:var(--cmp-bg);' +
        'border-top:1px solid var(--cmp-border);padding:20px 24px;display:flex;flex-wrap:wrap;align-items:center;gap:16px 32px;}' +
      '.banner p{margin:0;flex:1 1 420px;max-width:72ch;}' +
      '.buttons{display:flex;flex-wrap:wrap;gap:12px;}' +
      '.btn{font:inherit;font-weight:600;cursor:pointer;min-height:44px;padding:10px 20px;border-radius:var(--cmp-radius);' +
        'border:2px solid var(--cmp-primary);background:var(--cmp-primary);color:var(--cmp-primary-text);flex:1 1 auto;}' +
      '.btn:hover{filter:brightness(0.92);}' +
      '.link{color:var(--cmp-link);text-decoration:underline;}' +
      '.btn:focus-visible,.link:focus-visible,.close:focus-visible,.switch:focus-visible{outline:3px solid var(--cmp-primary);outline-offset:2px;}' +
      '.overlay{position:fixed;inset:0;z-index:' + (cfg.zIndex + 1) + ';background:var(--cmp-overlay);display:flex;' +
        'align-items:center;justify-content:center;padding:16px;}' +
      '.dialog{background:var(--cmp-bg);color:var(--cmp-text);border:1px solid var(--cmp-border);width:100%;max-width:640px;' +
        'max-height:calc(100vh - 32px);overflow-y:auto;padding:28px;position:relative;}' +
      '.dialog h2{margin:0 0 8px;font-size:1.5em;line-height:1.2;padding-right:72px;}' +
      '.close{position:absolute;top:24px;right:24px;font:inherit;font-weight:600;background:none;border:0;' +
        'color:var(--cmp-text);cursor:pointer;min-height:44px;padding:0 4px;}' +
      '.row{display:flex;justify-content:space-between;align-items:flex-start;gap:24px;padding:16px 0;' +
        'border-top:1px solid var(--cmp-divider);}' +
      '.row h3{margin:0 0 4px;font-size:1.1em;}' +
      '.row p{margin:0;}' +
      '.always{font-weight:600;white-space:nowrap;padding-top:2px;}' +
      '.switch{appearance:none;-webkit-appearance:none;flex:0 0 auto;width:52px;height:30px;margin:2px 0 0;cursor:pointer;' +
        'border:2px solid var(--cmp-border);border-radius:var(--cmp-radius);background:var(--cmp-off);position:relative;}' +
      '.switch::after{content:"";position:absolute;top:3px;left:3px;width:20px;height:20px;border-radius:var(--cmp-radius);' +
        'background:var(--cmp-border);}' +
      '.switch:checked{background:var(--cmp-primary);border-color:var(--cmp-primary);}' +
      '.switch:checked::after{left:25px;background:var(--cmp-primary-text);}' +
      '.list-link{display:inline-block;margin:8px 0 20px;}' +
      '.dialog .buttons{margin-top:20px;}' +
      '.reopen{position:fixed;bottom:16px;' + (cfg.floatingButton.position === 'right' ? 'right' : 'left') + ':16px;z-index:' + cfg.zIndex + ';' +
        'font:inherit;font-size:0.85em;font-weight:600;cursor:pointer;min-height:36px;padding:6px 14px;' +
        'border-radius:var(--cmp-radius);border:1px solid var(--cmp-border);background:var(--cmp-bg);color:var(--cmp-text);}' +
      '.reopen:focus-visible{outline:3px solid var(--cmp-primary);outline-offset:2px;}' +
      '@media (max-width:600px){.banner{padding:16px;}.btn{flex:1 1 100%;}.dialog{padding:20px;}.close{top:18px;right:16px;}}' +
      (cfg.floatingButton && cfg.floatingButton.css ? cfg.floatingButton.css : '');
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  var state = null, host, shadow, root, banner, overlay, dialog, reopen = null, lastFocus = null;

  function buildReopen() {
    if (!cfg.floatingButton || !cfg.floatingButton.enabled) { return; }
    reopen = el('button', { type: 'button', 'class': 'reopen' }, cfg.floatingButton.text || 'Cookie settings');
    reopen.addEventListener('click', function () { openPreferences(reopen); });
    reopen.hidden = true;
    root.appendChild(reopen);
  }

  function refreshReopen() {
    if (!reopen) { return; }
    reopen.hidden = !(state && banner.hidden && overlay.hidden);
  }

  function buildBanner() {
    var t = cfg.text;
    banner = el('section', { 'class': 'banner', role: 'region', 'aria-label': t.bannerLabel });
    var p = el('p', null, t.bannerText + ' ');
    if (t.privacyUrl) { p.appendChild(el('a', { 'class': 'link', href: t.privacyUrl }, t.privacyLinkText)); }
    banner.appendChild(p);

    var btns = el('div', { 'class': 'buttons' });
    var accept = el('button', { type: 'button', 'class': 'btn' }, t.acceptAll);
    var reject = el('button', { type: 'button', 'class': 'btn' }, t.rejectAll);
    var custom = el('button', { type: 'button', 'class': 'btn' }, t.customise);
    accept.addEventListener('click', function () { chooseAll('granted', 'accept_all', 'banner'); });
    reject.addEventListener('click', function () { chooseAll('denied', 'reject_all', 'banner'); });
    custom.addEventListener('click', function () { openPreferences(custom); });
    btns.appendChild(accept); btns.appendChild(reject); btns.appendChild(custom);
    banner.appendChild(btns);
    banner.hidden = true;
    root.appendChild(banner);
  }

  function buildDialog() {
    var t = cfg.text;
    overlay = el('div', { 'class': 'overlay' });
    dialog = el('div', { 'class': 'dialog', role: 'dialog', 'aria-modal': 'true', 'aria-labelledby': 'cmp-title' });
    dialog.appendChild(el('h2', { id: 'cmp-title' }, t.prefTitle));

    var close = el('button', { type: 'button', 'class': 'close' }, t.close);
    close.addEventListener('click', function () { dismiss('close_button'); });
    dialog.appendChild(close);

    var ess = el('div', { 'class': 'row' });
    var essText = el('div');
    essText.appendChild(el('h3', null, cfg.essential.title));
    essText.appendChild(el('p', null, cfg.essential.description));
    ess.appendChild(essText);
    ess.appendChild(el('span', { 'class': 'always' }, cfg.essential.label));
    dialog.appendChild(ess);

    for (var i = 0; i < cfg.categories.length; i++) {
      var cat = cfg.categories[i];
      var row = el('div', { 'class': 'row' });
      var txt = el('div');
      txt.appendChild(el('h3', { id: 'cmp-cat-' + cat.key }, cat.title));
      txt.appendChild(el('p', null, cat.description));
      row.appendChild(txt);
      row.appendChild(el('input', {
        type: 'checkbox', role: 'switch', 'class': 'switch',
        'data-key': cat.key, 'aria-labelledby': 'cmp-cat-' + cat.key
      }));
      dialog.appendChild(row);
    }

    if (t.cookieListUrl) { dialog.appendChild(el('a', { 'class': 'link list-link', href: t.cookieListUrl }, t.cookieListText)); }

    var btns = el('div', { 'class': 'buttons' });
    var save = el('button', { type: 'button', 'class': 'btn' }, t.save);
    var accept = el('button', { type: 'button', 'class': 'btn' }, t.acceptAll);
    var reject = el('button', { type: 'button', 'class': 'btn' }, t.rejectAll);
    save.addEventListener('click', saveFromToggles);
    accept.addEventListener('click', function () { chooseAll('granted', 'accept_all', 'modal'); });
    reject.addEventListener('click', function () { chooseAll('denied', 'reject_all', 'modal'); });
    btns.appendChild(save); btns.appendChild(accept); btns.appendChild(reject);
    dialog.appendChild(btns);

    overlay.appendChild(dialog);
    overlay.hidden = true;
    overlay.addEventListener('mousedown', function (e) { if (e.target === overlay) { dismiss('outside_click'); } });
    overlay.addEventListener('keydown', onDialogKeydown);
    root.appendChild(overlay);
  }

  function focusables() {
    return dialog.querySelectorAll('button, a[href], input:not([disabled])');
  }

  function onDialogKeydown(e) {
    if (e.key === 'Escape' || e.key === 'Esc') { e.preventDefault(); dismiss('escape'); return; }
    if (e.key !== 'Tab') { return; }
    var items = focusables();
    if (!items.length) { return; }
    var first = items[0], last = items[items.length - 1], active = shadow.activeElement;
    if (e.shiftKey && (active === first || !dialog.contains(active))) { e.preventDefault(); last.focus(); }
    else if (!e.shiftKey && (active === last || !dialog.contains(active))) { e.preventDefault(); first.focus(); }
  }

  function setToggles() {
    var inputs = dialog.querySelectorAll('.switch');
    for (var i = 0; i < inputs.length; i++) {
      var k = inputs[i].getAttribute('data-key');
      inputs[i].checked = !!(state && state[k] === 'granted');
    }
  }

  function openPreferences(trigger) {
    lastFocus = trigger || document.activeElement;
    setToggles();
    banner.hidden = true;
    overlay.hidden = false;
    refreshReopen();
    var first = focusables()[0];
    if (first) { first.focus(); }
  }

  function closeDialog() {
    overlay.hidden = true;
    refreshReopen();
    if (lastFocus && typeof lastFocus.focus === 'function' && lastFocus.isConnected !== false) {
      try { lastFocus.focus(); } catch (e) { /* ignore */ }
    }
    lastFocus = null;
  }

  function dismiss(method) {
    if (overlay.hidden) { return; }
    closeDialog();
    if (!state) { banner.hidden = false; }
    refreshReopen();
    push(cfg.events.dismiss, {
      element_id: 'preference_centre',
      element_type: 'modal',
      close_method: method
    });
  }

  // ---------------------------------------------------------------------------
  // Saving a choice
  // ---------------------------------------------------------------------------
  function save(values, action, source) {
    state = { v: cfg.version };
    for (var i = 0; i < keys.length; i++) { state[keys[i]] = values[keys[i]] === 'granted' ? 'granted' : 'denied'; }
    state.t = Date.now();
    writeCookie(state);

    var wasModal = !overlay.hidden;
    banner.hidden = true;
    if (wasModal) { closeDialog(); }
    refreshReopen();

    var params = {
      element_id: source === 'modal' ? 'preference_centre' : 'consent_banner',
      element_type: source === 'modal' ? 'modal' : 'banner',
      consent_action: action
    };
    for (var j = 0; j < keys.length; j++) { params[keys[j] + '_consent'] = state[keys[j]]; }
    push(cfg.events.update, params);
  }

  function chooseAll(value, action, source) {
    var values = {};
    for (var i = 0; i < keys.length; i++) { values[keys[i]] = value; }
    save(values, action, source);
  }

  function saveFromToggles() {
    var values = {}, inputs = dialog.querySelectorAll('.switch');
    for (var i = 0; i < inputs.length; i++) {
      values[inputs[i].getAttribute('data-key')] = inputs[i].checked ? 'granted' : 'denied';
    }
    save(values, 'save_preferences', 'modal');
  }

  // ---------------------------------------------------------------------------
  // Cookie list (rendered into the site's own page, so it takes the site's styling)
  // ---------------------------------------------------------------------------
  function categoryTitle(key) {
    if (key === 'essential') { return cfg.essential.title; }
    for (var i = 0; i < cfg.categories.length; i++) { if (cfg.categories[i].key === key) { return cfg.categories[i].title; } }
    return key;
  }

  function renderCookieList(target) {
    if (target.getAttribute('data-cmp-rendered') === '1') { return; }
    target.setAttribute('data-cmp-rendered', '1');
    while (target.firstChild) { target.removeChild(target.firstChild); }
    var order = ['essential'].concat(keys), h = cfg.cookieListHeaders;
    for (var o = 0; o < order.length; o++) {
      var rows = [];
      for (var i = 0; i < cfg.cookies.length; i++) {
        if ((cfg.cookies[i].category || 'essential') === order[o]) { rows.push(cfg.cookies[i]); }
      }
      if (!rows.length) { continue; }
      var section = el('section', { 'class': 'cmp-cookie-group', 'data-category': order[o] });
      section.appendChild(el('h3', null, categoryTitle(order[o])));
      var table = el('table', { 'class': 'cmp-cookie-table' });
      var thead = el('thead'), hr = el('tr');
      var cols = ['name', 'provider', 'purpose', 'expiry'];
      for (var c = 0; c < cols.length; c++) { hr.appendChild(el('th', { scope: 'col' }, h[cols[c]])); }
      thead.appendChild(hr); table.appendChild(thead);
      var tbody = el('tbody');
      for (var r = 0; r < rows.length; r++) {
        var tr = el('tr');
        for (var d = 0; d < cols.length; d++) { tr.appendChild(el('td', null, rows[r][cols[d]] || '')); }
        tbody.appendChild(tr);
      }
      table.appendChild(tbody); section.appendChild(table); target.appendChild(section);
    }
  }

  var listCssAdded = false;
  function addCookieListCss() {
    if (listCssAdded || !cfg.cookieListCss) { return; }
    listCssAdded = true;
    var st = el('style', { id: 'minicmp-cookie-list-css' }, cfg.cookieListCss);
    (document.head || document.documentElement).appendChild(st);
  }

  function renderAllCookieLists() {
    var targets = document.querySelectorAll(cfg.cookieListSelector);
    if (targets.length) { addCookieListCss(); }
    for (var i = 0; i < targets.length; i++) { renderCookieList(targets[i]); }
  }

  // ---------------------------------------------------------------------------
  // Start
  // ---------------------------------------------------------------------------
  function start() {
    if (document.getElementById('minicmp-host')) { return; }
    host = el('div', { id: 'minicmp-host' });
    shadow = host.attachShadow({ mode: 'open' });
    var style = el('style', null, css());
    shadow.appendChild(style);
    root = el('div', { 'class': 'root' });
    shadow.appendChild(root);
    document.body.appendChild(host);

    buildBanner();
    buildDialog();
    buildReopen();

    state = readState();
    if (!state) { banner.hidden = false; }
    refreshReopen();

    // Cookie list placeholders, including ones added later by single-page app navigation
    renderAllCookieLists();
    if (window.MutationObserver) {
      new MutationObserver(function () { renderAllCookieLists(); })
        .observe(document.body, { childList: true, subtree: true });
    }

    // Any element matching openSelector opens the preference centre (e.g. a footer "Cookie settings" link)
    document.addEventListener('click', function (e) {
      var target = e.target;
      if (!target || !target.closest) { return; }
      var trigger = target.closest(cfg.openSelector);
      if (trigger) { e.preventDefault(); openPreferences(trigger); }
    });
  }

  window.MiniCMP = {
    _initialised: true,
    version: '1.0.0',
    open: function () { if (overlay) { openPreferences(document.activeElement); } },
    getConsent: function () { return state ? JSON.parse(JSON.stringify(state)) : null; },
    reset: function () { deleteCookie(); state = null; if (banner) { banner.hidden = false; refreshReopen(); } }
  };

  if (document.body) { start(); }
  else { document.addEventListener('DOMContentLoaded', start); }
})(window, document);

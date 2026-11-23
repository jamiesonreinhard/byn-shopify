(() => {
  const { project, pageType, canonical } = document.currentScript.dataset;
  const storageKey = 'byn_storefront_visitor';
  const publicPath = /^\/(?:products|collections|pages|policies)\/[a-z0-9-]+\/?$|^\/blogs\/[a-z0-9-]+(?:\/[a-z0-9-]+)?\/?$|^\/(?:collections|cart|search)?\/?$/;
  const path = new URL(canonical).pathname;
  if (!publicPath.test(path)) return;

  let visitor;
  let viewed = false;

  function permitted() {
    return !navigator.globalPrivacyControl && window.Shopify?.customerPrivacy?.analyticsProcessingAllowed() === true;
  }

  function capture(event, details = {}) {
    if (!permitted() || !visitor) return;
    const payload = {
      api_key: project,
      event,
      distinct_id: visitor,
      properties: {
        $process_person_profile: false,
        $geoip_disable: true,
        $current_url: location.origin + path,
        $host: location.hostname,
        $pathname: path,
        site: 'shopify',
        page_type: pageType,
        ...details
      }
    };
    fetch('https://us.i.posthog.com/i/v0/e/', {
      method: 'POST', body: JSON.stringify(payload), keepalive: true,
      credentials: 'omit', referrerPolicy: 'no-referrer'
    }).catch(() => {});
  }

  function refresh() {
    if (!permitted()) {
      viewed = false;
      visitor = undefined;
      try { localStorage.removeItem(storageKey); } catch {}
      return;
    }
    if (viewed) return;
    try {
      visitor = localStorage.getItem(storageKey) || crypto.randomUUID();
      localStorage.setItem(storageKey, visitor);
    } catch {
      visitor = crypto.randomUUID();
    }
    capture('$pageview');
    viewed = true;
  }

  document.addEventListener('click', event => {
    if (!viewed || !permitted() || !(event.target instanceof Element)) return;
    const control = event.target.closest('a[href], button, summary');
    if (!control || !control.closest('header, main, footer, cart-drawer, navigation-drawer')) return;
    const details = { area: control.closest('header, navigation-drawer') ? 'navigation' : control.closest('footer') ? 'footer' : 'content' };
    if (control instanceof HTMLAnchorElement) {
      const destination = new URL(control.href, location.href);
      if (destination.origin !== location.origin || !publicPath.test(destination.pathname)) return;
      details.control = 'link';
      details.destination_path = destination.pathname;
    } else if (control.matches('buy-buttons button[type="submit"]')) {
      details.control = 'add_to_cart';
    } else {
      if (control.closest('form')) return;
      details.control = control.localName;
      // Only use static theme labels, never shopper-entered text or field values.
      const label = (control.getAttribute('aria-label') || control.textContent || '').trim().toLowerCase();
      if (/^(next|previous|search|close|open menu|menu|filters?|sort by|quick buy|view cart|checkout|show more)$/.test(label)) details.control = label.replace(/ /g, '_');
    }
    capture('storefront_clicked', details);
  }, true);

  document.addEventListener('visitorConsentCollected', refresh);
  window.addEventListener('pageshow', event => {
    if (event.persisted) { viewed = false; refresh(); }
  });
  if (window.Shopify?.customerPrivacy) refresh();
  else window.Shopify?.loadFeatures?.([{ name: 'consent-tracking-api', version: '1.0' }], error => {
    if (!error) refresh();
  });
})();

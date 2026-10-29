# MiniCMP

A lightweight, free cookie consent banner and preference centre for Google Tag Manager.

MiniCMP asks visitors for consent, stores their choice in a first-party cookie and pushes it to the dataLayer. You then use that choice in Google Tag Manager, including for Google Consent Mode.

![MiniCMP cookie banner](screenshots/minicmp-banner-desktop.png)

## Features

- **Banner** with Accept all, Reject non-essential and Customise. Rejecting is as easy as accepting.
- **Preference centre** with one toggle per category. Essential is always on. You name the categories.
- **Withdraw at any time** with a floating Cookie settings button, or any link on your site.
- **Cookie list** that renders a table of your cookies, grouped by category, on any page.
- **Your design**: colours, font, corner radius, all wording, plus custom CSS.
- **dataLayer events**: `consent_update` and `consent_dismiss`, with the choice for each category.
- **Isolated styles**: the banner runs in a Shadow DOM, so your site's CSS and the banner's CSS don't affect each other.
- **Single small script**, no dependencies, written in ES5.

| Preference centre | Cookie list |
|---|---|
| ![Preference centre](screenshots/minicmp-preferences-desktop.png) | ![Cookie list](screenshots/minicmp-cookie-list.png) |

## Install

### Option 1: GTM tag template (recommended)

1. In Google Tag Manager, go to **Templates → Tag Templates → New**.
2. Open the **⋮** menu, choose **Import** and select `template.tpl` from this repo. Save.
3. Create a tag from the MiniCMP template and fill in the fields. Every field has a tooltip.
4. Fire it on **Initialization – All Pages**.

### Option 2: GTM Custom HTML tag

Copy the contents of `minicmp-custom-html.html` into a Custom HTML tag, edit the settings at the top and fire it on **Initialization – All Pages**. The script is included in the tag, so nothing is loaded from elsewhere.

### Option 3: Script on your site

Host `minicmp-1.0.0.js` yourself and add it to your pages, with your settings defined first:

```html
<script>
  window.MiniCMPConfig = { /* your settings, see minicmp-custom-html.html */ };
</script>
<script src="/path/to/minicmp-1.0.0.js"></script>
```

## Settings

All settings are optional. The full list with defaults is at the top of `minicmp-1.0.0.js`, and `minicmp-custom-html.html` has a commented example. The main ones:

| Setting | What it does |
|---|---|
| `cookieName` | Name of the consent cookie. |
| `cookieDomain` | Set to e.g. `.example.com` to share the choice across subdomains. |
| `version` | Raise it to ask every visitor again, e.g. after adding a category. |
| `expiryDays` | How long the choice is kept. |
| `categories` | The categories shown in the preference centre: `key`, `title`, `description`. |
| `text` | All wording, including the privacy link. |
| `cookies` | The rows of the cookie list. |
| `floatingButton` | The Cookie settings button shown after a choice. |
| `theme` | Colours, font and corner radius. |

## The consent cookie

The choice is stored as URL-encoded JSON, for example:

```json
{"v":1,"analytics":"granted","advertising":"denied","t":1767225600000}
```

`v` is the settings version and `t` is when the choice was made. There is one key per category. In GTM, read it with a first-party cookie variable (enable URL decoding) to set consent on page load.

## dataLayer events

When a visitor makes a choice:

```js
{
  event: 'consent_update',
  element_id: 'consent_banner',      // or 'preference_centre'
  element_type: 'banner',            // or 'modal'
  element_text: undefined,
  element_location: 'consent',
  consent_action: 'accept_all',      // 'reject_all' or 'save_preferences'
  close_method: undefined,
  analytics_consent: 'granted',      // one <key>_consent per category
  advertising_consent: 'denied'
}
```

When the preference centre is closed without saving:

```js
{
  event: 'consent_dismiss',
  element_id: 'preference_centre',
  element_type: 'modal',
  element_location: 'consent',
  close_method: 'close_button'       // 'outside_click' or 'escape'
}
```

Parameters that don't apply are pushed as `undefined`, so values from earlier pushes don't carry over.

## Google Consent Mode

MiniCMP doesn't set Consent Mode itself. Set it in Google Tag Manager from the cookie (on page load) and from `consent_update` (when the visitor chooses), using a Consent Mode tag of your choice. Map each category key to the consent types it covers.

## Cookie settings link and cookie list

- Any element with `data-cmp-open`, or any link to `#cookie-settings`, opens the preference centre. Use it for a footer link.
- Add `<div data-cmp-cookie-list></div>` to a page, such as your cookie policy, to show the cookie list there. It uses your site's styling unless you add `cookieListCss`.

## JavaScript API

```js
MiniCMP.open();        // open the preference centre
MiniCMP.getConsent();  // the stored choice, or null
MiniCMP.reset();       // clear the choice and show the banner again
```

## What it doesn't do on its own

MiniCMP does one job: asking for consent and passing the choice on. It doesn't scan for cookies, store consent records, block scripts or target by country on its own. These depend on how each site is set up and are handled around it, usually in Google Tag Manager.

## Licence

[Apache 2.0](LICENSE)

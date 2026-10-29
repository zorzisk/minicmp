___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "MiniCMP",
  "categories": [
    "UTILITY",
    "TAG_MANAGEMENT"
  ],
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "setupGroup",
    "displayName": "Setup",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "LABEL",
        "name": "setupHelp",
        "displayName": "Basic settings for the consent cookie. Fire this tag on Initialization – All Pages, after your Consent Mode default tag, with Consent Settings set to No additional consent required."
      },
      {
        "type": "TEXT",
        "name": "cookieName",
        "displayName": "Consent cookie name",
        "simpleValueType": true,
        "defaultValue": "site_consent",
        "help": "Name of the first-party cookie that stores the visitor\u0027s choice, e.g. site_consent. Use letters, numbers and underscores only. Your Consent Mode tag must read the same cookie name.",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "cookieDomain",
        "displayName": "Cookie domain",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Which domain the consent cookie belongs to. Leave empty to keep it on the current host only. Enter .example.com (with the leading dot) to share one choice across www.example.com, shop.example.com and other subdomains."
      },
      {
        "type": "TEXT",
        "name": "version",
        "displayName": "Consent version",
        "simpleValueType": true,
        "defaultValue": "1",
        "help": "Stored inside the consent cookie. Visitors whose cookie has a different number see the banner again and choose afresh. Raise it (1 → 2) when you add or remove a category or change what a category covers. Leave it alone for text or colour changes.",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          },
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "expiryDays",
        "displayName": "Ask again after (days)",
        "simpleValueType": true,
        "defaultValue": "180",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          },
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ],
        "help": "How many days a choice is remembered before the banner shows again. A whole number, e.g. 180 for about six months."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "categoriesGroup",
    "displayName": "Categories",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "LABEL",
        "name": "categoriesHelp",
        "displayName": "Each row is one category the visitor can switch on or off. Remove a row to drop it, or add rows for new ones. The key is stored in the cookie as key:\"granted\"/\"denied\" and pushed to the dataLayer as key_consent, so your Consent Mode setup must use the same keys. Raise the consent version after changing the rows."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "categories",
        "displayName": "",
        "newRowButtonText": "Add category",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Key (e.g. analytics)",
            "name": "key",
            "type": "TEXT",
            "isUnique": true,
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Title",
            "name": "title",
            "type": "TEXT"
          },
          {
            "defaultValue": "",
            "displayName": "Description",
            "name": "description",
            "type": "TEXT"
          }
        ],
        "defaultValue": [
          {
            "key": "analytics",
            "title": "Analytics",
            "description": "Helps us understand how the site is used."
          },
          {
            "key": "advertising",
            "title": "Advertising",
            "description": "Measures advertising and lets ad platforms attribute conversions."
          }
        ],
        "help": "The consent categories shown in the preference centre, in this order. Key: short identifier in lower case, e.g. analytics. Title: name shown to visitors. Description: one sentence on what it covers."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "reopenGroup",
    "displayName": "Cookie settings button",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "LABEL",
        "name": "reopenHelp",
        "displayName": "Visitors must be able to change their choice later. Either turn on the floating button, or add a link on the site with href\u003d\"#cookie-settings\" (or any element with the attribute data-cmp-open), e.g. in the footer. The floating button uses the Styling section (background, text and border colours, font and corner radius). Use Button custom CSS below to change anything else."
      },
      {
        "type": "CHECKBOX",
        "name": "floatingButton",
        "checkboxText": "Show a floating Cookie settings button",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Shows a small button in a bottom corner once the visitor has made a choice. Clicking it opens the preference centre. Turn it off only if the site already has a cookie settings link."
      },
      {
        "type": "TEXT",
        "name": "floatingText",
        "displayName": "Button text",
        "simpleValueType": true,
        "defaultValue": "",
        "enablingConditions": [
          {
            "paramName": "floatingButton",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "help": "Label of the floating button. Leave empty for the default: Cookie settings."
      },
      {
        "type": "SELECT",
        "name": "floatingPosition",
        "displayName": "Button position",
        "simpleValueType": true,
        "defaultValue": "left",
        "enablingConditions": [
          {
            "paramName": "floatingButton",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "selectItems": [
          {
            "value": "left",
            "displayValue": "Bottom left"
          },
          {
            "value": "right",
            "displayValue": "Bottom right"
          }
        ],
        "help": "Which bottom corner the floating button sits in. Pick the side that doesn\u0027t cover the site\u0027s own buttons, such as a chat widget."
      },
      {
        "type": "TEXT",
        "name": "buttonCss",
        "displayName": "Button custom CSS",
        "simpleValueType": true,
        "defaultValue": "",
        "enablingConditions": [
          {
            "paramName": "floatingButton",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "help": "Extra CSS for the floating button, applied after the Styling settings. Select the button with .reopen. Example: .reopen{bottom:80px;font-size:13px;box-shadow:0 2px 6px rgba(0,0,0,.2)} moves it up and adds a shadow. Write it on one line."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "cookieListGroup",
    "displayName": "Cookie list",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "LABEL",
        "name": "cookieListInfo",
        "displayName": "To show this list on a page, add \u003cstrong\u003e\u0026lt;div data-cmp-cookie-list\u0026gt;\u0026lt;/div\u0026gt;\u003c/strong\u003e where it should appear, e.g. on the privacy page. The table is built from the rows below, grouped by category. It uses the site\u0027s own styling unless you add Cookie list custom CSS below."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "cookies",
        "displayName": "",
        "newRowButtonText": "Add cookie",
        "help": "One row per cookie the site sets. Name: the cookie name, e.g. _ga. Provider: who sets it, e.g. Google. Category key: essential, or one of the keys in the Categories table, e.g. analytics; it decides which group the cookie is listed under. Purpose: one sentence on what it does. Expiry: how long it lasts, e.g. 2 years or Session.",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Name",
            "name": "name",
            "type": "TEXT",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Provider",
            "name": "provider",
            "type": "TEXT"
          },
          {
            "defaultValue": "essential",
            "displayName": "Category key",
            "name": "category",
            "type": "TEXT"
          },
          {
            "defaultValue": "",
            "displayName": "Purpose",
            "name": "purpose",
            "type": "TEXT"
          },
          {
            "defaultValue": "",
            "displayName": "Expiry",
            "name": "expiry",
            "type": "TEXT"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "headerName",
        "displayName": "Column heading: name",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Heading of the cookie name column. Default: Cookie."
      },
      {
        "type": "TEXT",
        "name": "headerProvider",
        "displayName": "Column heading: provider",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Heading of the provider column. Default: Provider."
      },
      {
        "type": "TEXT",
        "name": "headerPurpose",
        "displayName": "Column heading: purpose",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Heading of the purpose column. Default: Purpose."
      },
      {
        "type": "TEXT",
        "name": "headerExpiry",
        "displayName": "Column heading: expiry",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Heading of the expiry column. Default: Expiry."
      },
      {
        "type": "TEXT",
        "name": "cookieListCss",
        "displayName": "Cookie list custom CSS",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "CSS added to the page to style the cookie list. Available selectors: .cmp-cookie-group (each category section), .cmp-cookie-group h3 (category title), .cmp-cookie-table (each table), and its th and td cells. Example: .cmp-cookie-table{width:100%;border-collapse:collapse}.cmp-cookie-table th,.cmp-cookie-table td{border:1px solid #ddd;padding:8px;text-align:left}. Write it on one line."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "textGroup",
    "displayName": "Text",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "LABEL",
        "name": "textHelp",
        "displayName": "Leave any field empty to use the default English text."
      },
      {
        "type": "TEXT",
        "name": "bannerText",
        "displayName": "Banner text",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "The main sentence of the banner. The privacy link is added after it."
      },
      {
        "type": "TEXT",
        "name": "privacyLinkText",
        "displayName": "Privacy link text",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Text of the privacy link shown after the banner sentence. Default: Read the privacy note."
      },
      {
        "type": "TEXT",
        "name": "privacyUrl",
        "displayName": "Privacy page URL",
        "simpleValueType": true,
        "defaultValue": "/privacy",
        "help": "Link to the privacy page. A path (/privacy) or full URL. Leave empty to hide the link."
      },
      {
        "type": "TEXT",
        "name": "acceptAll",
        "displayName": "Accept all button",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Label of the button that grants every category. Shown on the banner and in the preference centre. Default: Accept all."
      },
      {
        "type": "TEXT",
        "name": "rejectAll",
        "displayName": "Reject button",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Label of the button that denies every category except essential. Default: Reject non-essential."
      },
      {
        "type": "TEXT",
        "name": "customise",
        "displayName": "Customise button",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Label of the banner button that opens the preference centre. Default: Customise."
      },
      {
        "type": "TEXT",
        "name": "prefTitle",
        "displayName": "Preference centre title",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Heading of the preference centre. Default: Cookie settings."
      },
      {
        "type": "TEXT",
        "name": "save",
        "displayName": "Save button",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Label of the preference centre button that saves the visitor\u0027s toggle choices. Default: Save preferences."
      },
      {
        "type": "TEXT",
        "name": "close",
        "displayName": "Close button",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Label of the button that closes the preference centre without saving. Default: Close."
      },
      {
        "type": "TEXT",
        "name": "cookieListText",
        "displayName": "Cookie list link text",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Text of the link to the cookie list, shown in the preference centre. Default: See the cookie list."
      },
      {
        "type": "TEXT",
        "name": "cookieListUrl",
        "displayName": "Cookie list URL",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Link to the page listing the site\u0027s cookies, e.g. /privacy#cookie-list. A path or full URL. Leave empty to hide the link."
      },
      {
        "type": "TEXT",
        "name": "bannerLabel",
        "displayName": "Banner label (for screen readers)",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Name screen readers announce for the banner. Not shown on screen. Default: Cookie consent."
      },
      {
        "type": "TEXT",
        "name": "essentialTitle",
        "displayName": "Essential category title",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Name of the always-on category in the preference centre. Default: Essential."
      },
      {
        "type": "TEXT",
        "name": "essentialDescription",
        "displayName": "Essential category description",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "One sentence on what the always-on cookies do. Default: Needed for the site to work, including remembering your cookie choices."
      },
      {
        "type": "TEXT",
        "name": "essentialLabel",
        "displayName": "Essential status label",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Text shown instead of a toggle for the always-on category. Default: Always on."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "themeGroup",
    "displayName": "Styling",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "LABEL",
        "name": "themeHelp",
        "displayName": "Leave a field empty to use its default. Each field takes a CSS value: see the ? next to it. You can also pick a GTM variable."
      },
      {
        "type": "TEXT",
        "name": "fontFamily",
        "displayName": "Font family",
        "simpleValueType": true,
        "defaultValue": "inherit",
        "help": "A CSS font-family value. \u0027inherit\u0027 uses the site\u0027s own font. Examples: inherit · Arial, sans-serif · \u0027Inter\u0027, sans-serif (the font must already be loaded by the site)."
      },
      {
        "type": "TEXT",
        "name": "fontSize",
        "displayName": "Font size",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "A CSS size for the body text. Examples: 15px · 1rem. Default: 15px."
      },
      {
        "type": "TEXT",
        "name": "textColor",
        "displayName": "Text colour",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Any CSS colour. Examples: #131A4F · rgb(19, 26, 79) · black. Default: #131A4F."
      },
      {
        "type": "TEXT",
        "name": "background",
        "displayName": "Background colour",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Background of the banner and preference centre. Any CSS colour, e.g. #FFFFFF. Default: #FFFFFF."
      },
      {
        "type": "TEXT",
        "name": "primary",
        "displayName": "Button colour",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Button background colour. Any CSS colour, e.g. #2B4BFF. Default: #2B4BFF."
      },
      {
        "type": "TEXT",
        "name": "primaryText",
        "displayName": "Button text colour",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Button text colour. Pick one with strong contrast against the button colour. Default: #FFFFFF."
      },
      {
        "type": "TEXT",
        "name": "border",
        "displayName": "Border colour",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Colour of the banner\u0027s top line, the dialog border and the toggle outline. Default: #131A4F."
      },
      {
        "type": "TEXT",
        "name": "link",
        "displayName": "Link colour",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Colour of the privacy and cookie list links. Default: #2B4BFF."
      },
      {
        "type": "TEXT",
        "name": "toggleOff",
        "displayName": "Toggle off colour",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Fill of a switched-off toggle. Default: #EEF1FF."
      },
      {
        "type": "TEXT",
        "name": "divider",
        "displayName": "Divider colour",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Colour of the lines between categories. Default: #C9CEE6."
      },
      {
        "type": "TEXT",
        "name": "overlay",
        "displayName": "Overlay colour",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Colour that dims the page behind the preference centre. Use a colour with transparency, e.g. rgba(0, 0, 0, 0.5). Default: rgba(19, 26, 79, 0.5)."
      },
      {
        "type": "TEXT",
        "name": "radius",
        "displayName": "Corner radius",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Corner rounding of buttons and toggles. A CSS length: 0 for square, e.g. 4px or 8px. Default: 4px."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const setInWindow = require('setInWindow');
const injectScript = require('injectScript');
const queryPermission = require('queryPermission');
const makeNumber = require('makeNumber');
const log = require('logToConsole');

// Hosted script. Update this URL (and the Injects scripts permission) when a new version is released.
const SCRIPT_URL = 'https://www.unsampled.co.uk/cmp/minicmp-1.0.0.js';

function has(v) { return v !== undefined && v !== null && v !== ''; }
function put(obj, key, value) { if (has(value)) { obj[key] = value; } }

const cfg = {
  cookieName: data.cookieName,
  version: makeNumber(data.version),
  expiryDays: makeNumber(data.expiryDays)
};
put(cfg, 'cookieDomain', data.cookieDomain);

if (data.categories && data.categories.length) {
  const cats = [];
  for (let i = 0; i < data.categories.length; i++) {
    const row = data.categories[i];
    if (has(row.key)) {
      cats.push({ key: row.key, title: has(row.title) ? row.title : row.key, description: has(row.description) ? row.description : '' });
    }
  }
  if (cats.length) { cfg.categories = cats; }
}

const text = {};
const textKeys = ['bannerText', 'privacyLinkText', 'acceptAll', 'rejectAll', 'customise', 'prefTitle',
  'save', 'close', 'cookieListText', 'bannerLabel'];
for (let i = 0; i < textKeys.length; i++) { put(text, textKeys[i], data[textKeys[i]]); }
if (data.privacyUrl !== undefined) { text.privacyUrl = data.privacyUrl || ''; }
text.cookieListUrl = data.cookieListUrl || '';
cfg.text = text;

const essential = {};
put(essential, 'title', data.essentialTitle);
put(essential, 'description', data.essentialDescription);
put(essential, 'label', data.essentialLabel);
cfg.essential = essential;

const theme = {};
put(theme, 'fontFamily', data.fontFamily);
put(theme, 'fontSize', data.fontSize);
put(theme, 'text', data.textColor);
put(theme, 'background', data.background);
put(theme, 'primary', data.primary);
put(theme, 'primaryText', data.primaryText);
put(theme, 'border', data.border);
put(theme, 'link', data.link);
put(theme, 'toggleOff', data.toggleOff);
put(theme, 'divider', data.divider);
put(theme, 'overlay', data.overlay);
put(theme, 'radius', data.radius);
cfg.theme = theme;

if (data.cookies && data.cookies.length) {
  const list = [];
  for (let i = 0; i < data.cookies.length; i++) {
    const c = data.cookies[i];
    if (has(c.name)) {
      list.push({ name: c.name, provider: c.provider || '', category: has(c.category) ? c.category : 'essential', purpose: c.purpose || '', expiry: c.expiry || '' });
    }
  }
  cfg.cookies = list;
}
const headers = {};
put(headers, 'name', data.headerName);
put(headers, 'provider', data.headerProvider);
put(headers, 'purpose', data.headerPurpose);
put(headers, 'expiry', data.headerExpiry);
cfg.cookieListHeaders = headers;

cfg.floatingButton = { enabled: data.floatingButton === true, position: data.floatingPosition === 'right' ? 'right' : 'left' };
put(cfg.floatingButton, 'text', data.floatingText);
put(cfg.floatingButton, 'css', data.buttonCss);
put(cfg, 'cookieListCss', data.cookieListCss);

setInWindow('MiniCMPConfig', cfg, true);

if (queryPermission('inject_script', SCRIPT_URL)) {
  injectScript(SCRIPT_URL, data.gtmOnSuccess, function () {
    log('MiniCMP: the script failed to load from ' + SCRIPT_URL);
    data.gtmOnFailure();
  }, 'minicmp');
} else {
  log('MiniCMP: ' + SCRIPT_URL + ' is not allowed in this template\'s Injects scripts permission.');
  data.gtmOnFailure();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "MiniCMPConfig"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://www.unsampled.co.uk/cmp/minicmp-1.0.0.js"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

MiniCMP tag template v1.0.0 (script minicmp-1.0.0.js)



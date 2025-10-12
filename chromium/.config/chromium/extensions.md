# Chromium Extensions

This file documents the Chromium extensions installed on this system. Extensions cannot be automatically installed via dotfiles, but this serves as a reference for setting up a new system.

## Installation Methods

### Method 1: Chrome Web Store (Recommended)
Visit the Chrome Web Store URLs below and click "Add to Chrome"

### Method 2: Manual CRX Installation
1. Download `.crx` file from Chrome Web Store or developer website
2. Navigate to `chrome://extensions`
3. Enable "Developer mode" in top right
4. Drag and drop `.crx` file onto the page

### Method 3: Load Unpacked (Development)
For unpacked extension directories, you can use the `--load-extension` flag in `chromium-flags.conf`

## Installed Extensions

### Password Management
- **1Password – Password Manager** (v8.11.12.27)
  - ID: `aeblfdkhhhdcdjpifhhbdiojplfjncoa`
  - URL: https://chrome.google.com/webstore/detail/aeblfdkhhhdcdjpifhhbdiojplfjncoa
  - Purpose: Password management and autofill

### SEO & Web Development
- **Ahrefs SEO Toolbar** (v3.2.2)
  - ID: `hgmoccdbjhknikckedaaebbpdeebhiei`
  - URL: https://chrome.google.com/webstore/detail/hgmoccdbjhknikckedaaebbpdeebhiei
  - Purpose: On-page SEO analysis and SERP tools

- **BuiltWith Technology Profiler** (v3.6)
  - ID: `dapjbgnjinbpoindlpdmhochffioedbn`
  - URL: https://chrome.google.com/webstore/detail/dapjbgnjinbpoindlpdmhochffioedbn
  - Purpose: Identify technologies used on websites

- **Wappalyzer** (v6.10.86)
  - ID: `gppongmhjkpfnbhagpmjfkannfbllamg`
  - URL: https://chrome.google.com/webstore/detail/gppongmhjkpfnbhagpmjfkannfbllamg
  - Purpose: Technology profiler for web technologies

- **WooRank SEO Analysis** (v2.2.3)
  - ID: `hlngmmdolgbdnnimbmblfhhndibdipaf`
  - URL: https://chrome.google.com/webstore/detail/hlngmmdolgbdnnimbmblfhhndibdipaf
  - Purpose: Website review and SEO analysis

- **Lighthouse** (v100.0.0.4)
  - ID: `blipmdconlkpinefehnmjammfjpmpbjk`
  - URL: https://chrome.google.com/webstore/detail/blipmdconlkpinefehnmjammfjpmpbjk
  - Purpose: Performance, accessibility, and SEO auditing

### Design & CSS Tools
- **CSS Peeper** (v1.0.19)
  - ID: `mbnbehikldjhnfehhnaidhjhoofhpehk`
  - URL: https://chrome.google.com/webstore/detail/mbnbehikldjhnfehhnaidhjhoofhpehk
  - Purpose: CSS inspector and style extractor

- **Stylebot** (v3.1.4)
  - ID: `oiaejidbmkiecgbjeifoejpgmdaleoha`
  - URL: https://chrome.google.com/webstore/detail/oiaejidbmkiecgbjeifoejpgmdaleoha
  - Purpose: Custom CSS injection and styling

- **html.to.design** (v0.0.187)
  - ID: `ldnheaepmnmbjjjahokphckbpgciiaed`
  - URL: https://chrome.google.com/webstore/detail/ldnheaepmnmbjjjahokphckbpgciiaed
  - Purpose: Convert HTML to Figma designs

### Developer Tools
- **Web Developer** (v3.0.1)
  - ID: `bfbameneiokkgbdmiekhjnmfkcnldhhm`
  - URL: https://chrome.google.com/webstore/detail/bfbameneiokkgbdmiekhjnmfkcnldhhm
  - Purpose: Various web development tools and utilities

### Utilities
- **Cookie Remover** (v1.0.5)
  - ID: `kcgpggonjhmeaejebeoeomdlohicfhce`
  - URL: https://chrome.google.com/webstore/detail/kcgpggonjhmeaejebeoeomdlohicfhce
  - Purpose: Quick cookie removal for current site

- **Modern for Hacker News** (v1.14)
  - ID: `dabkegjlekdcmefifaolmdhnhdcplklo`
  - URL: https://chrome.google.com/webstore/detail/dabkegjlekdcmefifaolmdhnhdcplklo
  - Purpose: Modern UI for Hacker News

### Built-in Extensions
- **Chromium PDF Viewer** (v1)
  - ID: `mhjfbmdgcfjbbpaeojofohoefgiehjai`
  - Built-in extension (no installation needed)

- **Google Hangouts** (v1.3.26)
  - ID: `nkeimhogjdpnpccoofpliimaahmaaome`
  - URL: https://chrome.google.com/webstore/detail/nkeimhogjdpnpccoofpliimaahmaaome

- **Web Store** (v0.2)
  - ID: `ahfgeienlihckogmohjhadlkjgocpleb`
  - Built-in extension (no installation needed)

## Extension Configuration

Some extensions have exportable settings. To back up extension settings:

1. Check if extension has export/import settings feature
2. Export settings to JSON/file
3. Store in `chromium/.config/chromium/extension-settings/`
4. Import manually on new system

## Updating This File

To update this list after installing/removing extensions:

```bash
jq -r '.extensions.settings | to_entries[] | "\(.key)|\(.value.manifest.name // "Unknown")|\(.value.manifest.version // "unknown")"' ~/.config/chromium/Default/Preferences 2>/dev/null | sort -t'|' -k2
```

Or use the provided utility script:

```bash
chromium-list-extensions
chromium-list-extensions markdown > chromium/.config/chromium/extensions.md
```

---

**Last updated:** 2025-10-12
**Total extensions:** 16

# Icon Workspace

Use this folder as a single source of truth for all CAT.AI icon assets.

## Structure

- `source/`: editable source files (`.svg`, `.fig`, `.ai`, `.sketch`)
- `generate-icons/`: script to generate all runtime icon outputs
- `exports/android/`: exported Android icon files
- `exports/web/`: exported Web/PWA icon files
- `exports/store/`: exported marketplace/store icon files

## Base SVG

- Keep your primary icon at:
  - `source/icon-svg-base.svg`

## Generate Icons

```bash
cd cat_os_flutter/design/icons/generate-icons
npm install
npm run generate
```

This updates icons used by the app directly:

- `android/app/src/main/res/mipmap-*/ic_launcher.png`
- `web/favicon.png`
- `web/icons/Icon-192.png`
- `web/icons/Icon-512.png`
- `web/icons/Icon-maskable-192.png`
- `web/icons/Icon-maskable-512.png`

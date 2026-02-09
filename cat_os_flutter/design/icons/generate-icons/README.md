# generate-icons

Generate PNG icon sets from one SVG base file.

## Input

- Default file: `../source/icon-svg-base.svg`
- Optional custom file:
  - `npm run generate -- ../source/your-icon.svg`

## Output

- Web/PWA:
  - `web/favicon.png`
  - `web/icons/Icon-192.png`
  - `web/icons/Icon-512.png`
  - `web/icons/Icon-maskable-192.png`
  - `web/icons/Icon-maskable-512.png`
- Android:
  - `android/app/src/main/res/mipmap-*/ic_launcher.png`
- Design exports:
  - `../exports/android/*`
  - `../exports/web/*`
  - `../exports/store/play-icon-512.png`

## Usage

```bash
cd cat_os_flutter/design/icons/generate-icons
npm install
npm run generate
```

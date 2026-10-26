# Kiosk showcase website

An interactive 3D showcase for the self-service kiosk in the repo root. Scroll to take a 3D iPad apart, then try a working ordering flow rendered *inside* the 3D iPad.

## What's real and what's simulated

| | |
|---|---|
| 3D iPad | Procedural three.js geometry (no downloaded model, so no asset licences). Screen textures are real screenshots of the Flutter app. |
| Demo kiosk | A **web re-creation** of the Flutter app's ordering flow in React (same sample menu, modifiers and the 2.5% + $0.30 service fee). It is *not* the Flutter app itself. |
| Payment | **Simulated.** The QR code is real but encodes a demo string; a button stands in for the customer's phone. Nothing is charged or sent anywhere. |

Why not embed the Flutter web build? It needs a ~MB-scale CanvasKit download, would not render as a live texture inside the 3D scene, and the QR flow depends on the local Dart server. A lightweight re-creation gives a faster, more reliable demo.

## Stack

React 18 · TypeScript · Vite · three.js · React Three Fiber · drei · qrcode-generator · Inter (self-hosted via Fontsource). No animation library: scroll choreography is a small custom rig (`src/scene/poses.ts`).

## Run locally

```bash
cd website
npm install
npm run dev      # http://localhost:5173
npm run build    # type-check + production build to dist/
npm run preview
```

## Edit your details

Personal links live in [`src/site.config.ts`](src/site.config.ts). Set `email` to show a contact button; verify the LinkedIn profile URL.

## Performance and accessibility

- The 3D scene is code-split and loads after first paint (~17 KB gzipped initial JS).
- Pixel ratio is capped (1.75 desktop / 1.5 mobile); lighting is built in-scene, with no HDR downloads.
- `prefers-reduced-motion` or no WebGL: the 3D stage is skipped, a static screenshot is shown and the demo renders inline.
- Phones: 3D iPad in the hero and "take it apart" sections; the demo is rendered inline and scaled (best in landscape).
- The demo is real DOM: keyboard-focusable buttons, focus rings, skip link, semantic headings.

## Deploy (free): GitHub Pages

The workflow at [`.github/workflows/deploy-site.yml`](../.github/workflows/deploy-site.yml) builds and publishes `website/dist`.

1. Repo **Settings → Pages → Build and deployment → Source: GitHub Actions**.
2. Push to `main` (or run the workflow manually). The site appears at `https://<user>.github.io/<repo>/`.

The build uses relative asset paths (`base: './'`), so it also works unchanged on Cloudflare Pages, Netlify or Vercel (build command `npm run build`, output `dist`, root `website`).

## Credits

Menu photos from [Unsplash](https://unsplash.com/license). Inter font (SIL OFL). Not affiliated with Apple or any payment provider.

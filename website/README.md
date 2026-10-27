# Kiosk showcase website

An interactive 3D showcase for the self-service kiosk in the repo root. Scroll to take a 3D iPad apart, then try a working ordering flow rendered *inside* the 3D iPad.

## What's real and what's simulated

| | |
|---|---|
| 3D iPad | Procedural three.js geometry (no downloaded model, so no asset licences). Screen textures are real screenshots of the Flutter app. |
| Demo kiosk | The real Flutter web build, embedded from `/app`. On phones it loads only when the visitor launches an experience. |
| Payment | **Simulated.** The QR code is real but encodes a demo string; a button stands in for the customer's phone. Nothing is charged or sent anywhere. |

The Flutter demo includes its CanvasKit runtime. It is loaded independently of the showcase, so browsing the mobile page does not download or initialise the app.

## Stack

React 18 · TypeScript · Vite · three.js · React Three Fiber · drei · qrcode-generator · Inter (self-hosted via Fontsource). No animation library: scroll choreography is a small custom rig (`src/scene/poses.ts`).

## Run locally

Build the embedded demo from the repository root first (also required after changes to Dart):

```bash
flutter build web --release -t lib/main_demo.dart -o website/public/app
```

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

- The 3D scene is dynamically imported on desktop. Mobile does not download or initialise WebGL, and has no scroll rig or pointer tracking.
- Desktop pixel ratio is capped at 1.75; lighting is built in-scene, with no HDR downloads.
- `prefers-reduced-motion` or no WebGL: the 3D stage is skipped, a static screenshot is shown and the demo renders inline.
- Phones: text-first hero, lightweight device artwork, compact chapter layouts, full navigation in a native modal, and an on-demand full-screen app workspace. Touch landscape layouts remain mobile through 1100px when the viewport is short.
- Ordering adapts to phone width. Merchant tools preserve a readable tablet canvas with internal horizontal/vertical scrolling; landscape provides more room.
- The showcase uses semantic HTML, keyboard-focusable controls, visible focus rings, native dialog focus containment, safe-area padding, and reduced-motion support. The embedded Flutter app has its own accessibility behavior.
- Screenshots use responsive WebP assets with intrinsic dimensions and lazy loading below the hero. The self-hosted font uses a single Latin variable font with `font-display: swap`.

See [MOBILE-QA.md](MOBILE-QA.md) for verification results and limitations. Mobile styling is isolated in `src/mobile.css`; desktop scene choreography remains in `src/scene/`.

## Deploy (free): GitHub Pages

The workflow at [`.github/workflows/deploy-site.yml`](../.github/workflows/deploy-site.yml) builds and publishes `website/dist`.

1. Repo **Settings → Pages → Build and deployment → Source: GitHub Actions**.
2. Push to `main` (or run the workflow manually). The site appears at `https://<user>.github.io/<repo>/`.

The build uses relative asset paths (`base: './'`), so it also works unchanged on Cloudflare Pages, Netlify or Vercel (build command `npm run build`, output `dist`, root `website`).

## Credits

Menu photos from [Unsplash](https://unsplash.com/license). Inter font (SIL OFL). Not affiliated with Apple or any payment provider.

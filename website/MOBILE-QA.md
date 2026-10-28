# Mobile redesign — verification, 28 October 2026

## Implementation

- `src/mobile.css`: mobile typography, spacing, chapter layouts, dimensional hero artwork, touch controls, safe areas, landscape support and reduced motion. Desktop scene composition remains intact.
- `src/Navigation.tsx` and `src/hooks.ts`: native mobile menu, keyboard focus containment, Escape dismissal, focus restoration and background scroll locking. Desktop navigation remains available above the mobile breakpoint.
- `src/kiosk/MobileDemo.tsx`: an automated, non-interactive five-chapter walkthrough inside the demo panel. Real app screens advance on a timer, loop, and expose a pause/play control for accessibility. The launch selector and full-screen workspace were removed; phones no longer load the Flutter runtime.
- `src/sections/Sections.tsx`: the statement film now autoplays muted and inline on phones, keeps playing off screen, and retries playback after a browser policy delay or the first touch. Desktop keeps its play-in-view behaviour.
- `src/kiosk/FlutterDemo.tsx`: loading recovery link and same-origin message validation. Tablet and desktop interaction is unchanged.
- `src/ScreenImage.tsx`, `src/fonts.css`, `public/screens`, `public/media`, `public/menu`: responsive WebP images, reserved image dimensions, lazy loading and one self-hosted Latin variable font. New tablet-size captures cover checkout, QR payment, menu scanning and menu management.
- `vite.config.ts`: removed manual chunk grouping that caused shared React dependencies to preload the 3D libraries on phones. The 889 KB desktop scene is now genuinely lazy. Mobile initial JavaScript is approximately 186 KB raw / 60 KB gzip. No new runtime dependencies.
- Flutter: phone ordering dialog, horizontal category navigation, product options, mobile QR checkout and smaller confirmation layout. `lib/demo/demo_viewport.dart` preserves original merchant tools in an internally scrollable tablet canvas without shrinking their controls.

The existing copy, product sections, profile/source links, metadata and desktop 3D scene remain. The mobile statement restores the explanatory text that the previous stylesheet hid.

## Checks performed

Chrome, controlled with Playwright, using local Vite development and production preview servers:

- Widths: 320, 360, 375, 390, 430, 768, 820, 844, 1024 and 1440 CSS pixels. All sections checked for off-screen elements and document overflow; none found in the final layout sweep.
- 844 × 390 touch landscape: the walkthrough reflows across rotation without horizontal overflow.
- Menu: every section link, keyboard Tab containment, Escape, close button, restored focus and scroll locking.
- Walkthrough: five chapters and all eleven frames observed advancing at 320, 390 and 768px; pause held the active frame for four seconds and play resumed it. No `Launch experience` control remains.
- Statement film: `paused: false` and increasing `currentTime` at 320, 390 and 768px after scrolling the section into view. Playback continued while the section was off screen.
- Flutter runtime: no `/app` request, Flutter bundle or WebGL scene during mobile page browsing. The brand MP4 and tour WebP assets are requested; the desktop app remains lazy.
- Product preview: size/milk controls update the price and receipt.
- Real Flutter app (tablet/desktop): start order → dine in → latte → size/milk → notes → quantity → review → cart → simulated QR payment. Checkout, QR and confirmation screens visually inspected at 1024 × 712.
- Merchant tools: all five initial demo screens inspected; touch panning exercised and screenshots reviewed for analytics, branding and menu scanning.
- Reduced motion: showcase animations disabled, content remains visible, no WebGL scene, and the walkthrough starts paused.
- Desktop and iPad: demo heading, five selectable flows and live Flutter embed unchanged at 1024 and 1440px. Before/after reduced-motion hero screenshots compared at 1440 × 1000; approximately 0.01% of pixels differed at a summed-channel tolerance of 30.
- Axe WCAG A/AA checks: zero detected violations in the showcase and open menu. This is not a full accessibility certification of the embedded Flutter application.
- `npm run build`: TypeScript check and Vite production build passed.
- `flutter build web --release -t lib/main_demo.dart -o website/public/app`: passed.
- `dart analyze lib/demo/demo_viewport.dart`: no issues. Analysis of the existing kiosk files still reports pre-existing unused declarations/imports, null-check and deprecated API warnings; the overall Dart analyzer is not clean.
- `git diff --check`: passed.

## Performance measurement

Lighthouse 12.8.2, Chrome headless, localhost production preview, simulated mobile throttling (150ms RTT, approximately 1.6Mbps throughput, 4× CPU slowdown). Latest run after the walkthrough and mobile film changes:

| Isolated final measurement | Result |
| --- | --- |
| Performance | 93 |
| Accessibility | 100 |
| Best practices | 100 |
| SEO | 100 |
| Largest Contentful Paint | 2.9 seconds |
| Cumulative Layout Shift | 0 |
| Total Blocking Time | 20 milliseconds |
| First Contentful Paint | 2.3 seconds |

The initial mobile build measured 99 performance / 2.0s LCP. The additional video and walkthrough assets account for most of the difference; the film is deferred until it approaches the viewport. A separate run during other browser verification scored 78, with 490ms TBT; repeating in isolation produced the result above. Local CPU contention materially affects these lab results. These are not production field measurements, p75 Core Web Vitals, an INP measurement or a 60 FPS guarantee.

Raw Lighthouse JSON, browser checks and screenshots are retained locally in the ignored `.mobile-qa/` directory at the repository root. Test tools were installed there, independently of application dependencies.

## Remaining limits

- Merchant tools and alternative kiosk templates remain tablet-oriented. Their workspace supports deliberate internal scrolling; fully native phone layouts for all of those tools are a separate application redesign.
- Verification used Chrome emulation, not physical iOS/Android hardware or Safari/Firefox. Physical-device screen reader, safe-area, keyboard and performance testing remains advisable.
- Not every merchant template, export or business workflow was exercised. The existing simulated payment/backend limitations remain.
- The walkthrough is an automated film of real captured screens, not a live interaction. Visitors who need the interactive app are pointed to a tablet or desktop.
- No deployment was performed locally. Pushing to `main` triggers GitHub Actions, which rebuilds the Flutter demo, the site and publishes GitHub Pages; local builds need the sequence documented in `README.md`.

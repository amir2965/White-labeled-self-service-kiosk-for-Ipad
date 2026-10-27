# Mobile redesign — verification, 27 October 2026

## Implementation

- `src/mobile.css`: mobile typography, spacing, chapter layouts, dimensional hero artwork, touch controls, safe areas, landscape support and reduced motion. Desktop scene composition remains intact.
- `src/Navigation.tsx` and `src/hooks.ts`: native mobile menu, keyboard focus containment, Escape dismissal, focus restoration and background scroll locking. Desktop navigation remains available above the mobile breakpoint.
- `src/kiosk/MobileDemo.tsx`: five selectable experiences, clear instructions, on-demand launch, full-screen workspace, restart and persistent return control.
- `src/kiosk/FlutterDemo.tsx`: loading recovery link, same-origin message validation and separate desktop pointer-release behavior.
- `src/ScreenImage.tsx`, `src/fonts.css`, `public/screens`, `public/media`, `public/menu`: responsive WebP images, reserved image dimensions, lazy loading and one self-hosted Latin variable font.
- `vite.config.ts`: removed manual chunk grouping that caused shared React dependencies to preload the 3D libraries on phones. The 889 KB desktop scene is now genuinely lazy. Mobile initial JavaScript is approximately 186 KB raw / 59.5 KB gzip. No new runtime dependencies.
- Flutter: phone ordering dialog, horizontal category navigation, product options, mobile QR checkout and smaller confirmation layout. `lib/demo/demo_viewport.dart` preserves original merchant tools in an internally scrollable tablet canvas without shrinking their controls.

The existing copy, product sections, profile/source links, metadata and desktop 3D scene remain. The mobile statement restores the explanatory text that the previous stylesheet hid.

## Checks performed

Chrome, controlled with Playwright, using local Vite development and production preview servers:

- Widths: 320, 360, 375, 390, 430, 768, 820, 844, 1024 and 1440 CSS pixels. All sections checked for off-screen elements and document overflow; none found in the final layout sweep.
- 844 × 390 touch landscape: workspace remains open across rotation, with persistent controls.
- Menu: every section link, keyboard Tab containment, Escape, close button, restored focus and scroll locking.
- Demo: all five selections, launch, restart, return and restored focus. No Flutter, WebGL scene or MP4 requests during mobile page browsing before launch; verified against production network requests.
- Product preview: size/milk controls update the price and receipt.
- Real Flutter app: start order → dine in → latte → size/milk → notes → quantity → review → cart → pay at counter at 390px; the simulated QR payment path at 320px. Success screens visually inspected.
- Merchant tools: all five initial demo screens inspected; touch panning exercised and screenshots reviewed for analytics, branding and menu scanning.
- Reduced motion: showcase animations disabled, content remains visible, no WebGL scene.
- Desktop: rendered WebGL hero inspected at 1440px. Before/after reduced-motion hero screenshots compared at 1440 × 1000; approximately 0.01% of pixels differed at a summed-channel tolerance of 30.
- Axe WCAG A/AA checks: zero detected violations in the showcase and open menu. This is not a full accessibility certification of the embedded Flutter application.
- `npm run build`: TypeScript check and Vite production build passed.
- `flutter build web --release -t lib/main_demo.dart -o website/public/app`: passed.
- `dart analyze lib/demo/demo_viewport.dart`: no issues. Analysis of the existing kiosk files still reports pre-existing unused declarations/imports, null-check and deprecated API warnings; the overall Dart analyzer is not clean.
- `git diff --check`: passed.

## Performance measurement

Lighthouse 12.8.2, Chrome headless, localhost production preview, simulated mobile throttling (150ms RTT, approximately 1.6Mbps throughput, 4× CPU slowdown):

| Isolated final measurement | Result |
| --- | --- |
| Performance | 99 |
| Accessibility | 100 |
| Best practices | 100 |
| SEO | 100 |
| Largest Contentful Paint | 2.0 seconds |
| Cumulative Layout Shift | 0 |
| Total Blocking Time | 40 milliseconds |
| First Contentful Paint | 1.5 seconds |

The initial implementation measured 96 performance / 2.4s LCP. A later run during other browser verification scored 78, with 760ms TBT; repeating in isolation produced the result above. Local CPU contention materially affects these lab results. These are not production field measurements, p75 Core Web Vitals, an INP measurement or a 60 FPS guarantee.

Raw Lighthouse JSON, browser checks and screenshots are retained locally in the ignored `.mobile-qa/` directory at the repository root. Test tools were installed there, independently of application dependencies.

## Remaining limits

- Merchant tools and alternative kiosk templates remain tablet-oriented. Their workspace supports deliberate internal scrolling; fully native phone layouts for all of those tools are a separate application redesign.
- Verification used Chrome emulation, not physical iOS/Android hardware or Safari/Firefox. Physical-device screen reader, safe-area, keyboard and performance testing remains advisable.
- Not every merchant template, export or business workflow was exercised. The existing simulated payment/backend limitations remain.
- No deployment was performed. The production build is available in `website/dist`. GitHub Actions already rebuilds the Flutter demo before publishing; local builds need the same sequence documented in `README.md`.

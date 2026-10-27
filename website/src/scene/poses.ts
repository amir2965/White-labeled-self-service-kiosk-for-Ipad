// Scroll choreography. Each page section owns a list of keyframes; scrolling through the section
// walks the iPad through them. A section's last keyframe equals the next section's first.
export interface Pose {
  x: number; // centre offset, fraction of half viewport width
  y: number; // centre offset, fraction of half viewport height
  w: number; // iPad width as a fraction of viewport width
  rx: number;
  ry: number;
  rz: number;
  screen: number; // index into SCREENS (fractional = cross-fade)
  vis: number; // 0 hidden, 1 visible (scale multiplier)
}

const P = (p: Partial<Pose>): Pose => ({ x: 0, y: 0, w: 0.4, rx: 0, ry: 0, rz: 0, screen: 0, vis: 1, ...p });

const HERO_A = P({ x: 0.52, w: 0.42, rx: 0.1, ry: -0.45, rz: 0.03 });
const HERO_B = P({ x: 0.46, w: 0.42, rx: 0.14, ry: -0.7, rz: 0.04 });
const DEMO = P({ x: 0.33, w: 0.6, rx: 0.015, ry: -0.015 });
// The iPad steps out while the product walkthrough visuals take the stage.
const AWAY = P({ x: 0.33, w: 0.6, rx: 0.015, ry: -0.015, vis: 0 });
// Merchant: the iPad sits right of the copy and flips through the admin screens as the steps scroll by.
const MERCH = (screen: number, vis = 1) => P({ x: 0.46, y: 0, w: 0.42, rx: 0.06, ry: -0.35, screen, vis });
// Decisions: iPad on the left, copy on the right.
const DECISIONS = P({ x: -0.68, y: 0, w: 0.26, rx: 0.08, ry: 0.7, screen: 1 });
const ABOUT = P({ x: 0.64, y: -0.08, w: 0.3, rx: 0.06, ry: -0.4, screen: 6, vis: 0 });
// Between far-apart poses the iPad shrinks away and reappears, so it never slides behind text panels.
const MERCH_HIDDEN = MERCH(6, 0);
const DECISIONS_HIDDEN = { ...DECISIONS, vis: 0 };
const ABOUT_HIDDEN = { ...ABOUT, vis: 0 };

export interface Section {
  id: string;
  keyframes: Pose[];
  hold?: number; // fraction of the section to rest on the first keyframe
}

export const SECTIONS: Section[] = [
  { id: 'hero', keyframes: [HERO_A, HERO_B] },
  { id: 'product', keyframes: [HERO_B, AWAY, AWAY, AWAY, AWAY, AWAY] },
  { id: 'demo', keyframes: [AWAY, DEMO, DEMO, DEMO, MERCH(2)] },
  { id: 'merchant', keyframes: [MERCH(2), MERCH(2), MERCH(3), MERCH(3), MERCH(4), MERCH(5), MERCH(6), MERCH_HIDDEN] },
  { id: 'engineering', keyframes: [MERCH_HIDDEN, DECISIONS_HIDDEN] },
  { id: 'decisions', keyframes: [DECISIONS_HIDDEN, DECISIONS, DECISIONS, ABOUT_HIDDEN] },
  { id: 'state', keyframes: [ABOUT_HIDDEN, ABOUT_HIDDEN] },
  { id: 'about', keyframes: [ABOUT_HIDDEN, ABOUT, ABOUT] },
];

export const SECTION_IDS = SECTIONS.map((s) => s.id);

// Small screens: iPad sits above the copy in the hero, then steps away.
export function toMobile(p: Pose, sectionIndex: number): Pose {
  return { ...p, x: 0, y: 0.36, w: 0.84, vis: sectionIndex >= 2 ? 0 : p.vis };
}

export const smooth = (t: number) => t * t * (3 - 2 * t);

export function lerpPose(a: Pose, b: Pose, t: number): Pose {
  const out = {} as Pose;
  (Object.keys(a) as (keyof Pose)[]).forEach((k) => {
    out[k] = a[k] + (b[k] - a[k]) * t;
  });
  return out;
}

export function targetPose(sectionIndex: number, frac: number, mobile: boolean): Pose {
  const sec = SECTIONS[sectionIndex];
  const kfs = mobile ? sec.keyframes.map((k) => toMobile(k, sectionIndex)) : sec.keyframes;
  const hold = sec.hold ?? 0;
  const u = Math.min(1, Math.max(0, (frac - hold) / (1 - hold)));
  const pos = u * (kfs.length - 1);
  const i = Math.min(kfs.length - 2, Math.floor(pos));
  return lerpPose(kfs[i], kfs[i + 1], smooth(pos - i));
}

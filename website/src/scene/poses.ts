// Scroll choreography. Each page section owns a list of keyframes; scrolling through the section
// walks the iPad through them. A section's last keyframe equals the next section's first.
export interface Pose {
  x: number; // centre offset, fraction of half viewport width
  y: number; // centre offset, fraction of half viewport height
  w: number; // iPad width as a fraction of viewport width
  rx: number;
  ry: number;
  rz: number;
  explode: number; // 0 assembled, 1 layers fully separated
  screen: number; // index into SCREENS (fractional = cross-fade)
  vis: number; // 0 hidden, 1 visible (scale multiplier)
}

const P = (p: Partial<Pose>): Pose => ({ x: 0, y: 0, w: 0.4, rx: 0, ry: 0, rz: 0, explode: 0, screen: 0, vis: 1, ...p });

const HERO_A = P({ x: 0.52, w: 0.42, rx: 0.1, ry: -0.45, rz: 0.03 });
const HERO_B = P({ x: 0.46, w: 0.42, rx: 0.14, ry: -0.7, rz: 0.04 });
const DEMO = P({ x: 0.33, w: 0.6, rx: 0.015, ry: -0.015 });
const ENGINEERING = P({ x: 0.66, y: 0.52, w: 0.24, rx: 0.12, ry: -0.9, screen: 2 });
const STORY = P({ x: -0.6, y: 0.02, w: 0.32, rx: 0.08, ry: 0.75, screen: 3 });
const ABOUT = P({ x: 0.64, y: -0.08, w: 0.32, rx: 0.06, ry: -0.4, screen: 4 });

export interface Section {
  id: string;
  keyframes: Pose[];
  hold?: number; // fraction of the section to rest on the first keyframe
}

export const SECTIONS: Section[] = [
  { id: 'hero', keyframes: [HERO_A, HERO_B] },
  {
    id: 'anatomy',
    keyframes: [
      HERO_B,
      P({ x: 0.2, w: 0.4, rx: 0.1, ry: -1.0, explode: 0.55 }),
      P({ x: 0.2, w: 0.4, rx: 0.1, ry: -1.12, explode: 1, screen: 1 }),
      P({ x: 0.2, w: 0.4, rx: 0.1, ry: -1.12, explode: 1, screen: 2 }),
      DEMO,
    ],
  },
  { id: 'demo', keyframes: [DEMO, ENGINEERING], hold: 0.8 },
  { id: 'engineering', keyframes: [ENGINEERING, STORY] },
  { id: 'story', keyframes: [STORY, ABOUT] },
  { id: 'about', keyframes: [ABOUT, ABOUT] },
];

export const SECTION_IDS = SECTIONS.map((s) => s.id);

// Small screens: iPad sits above the copy for the first two sections, then steps away.
export function toMobile(p: Pose, sectionIndex: number): Pose {
  return { ...p, x: 0, y: 0.36, w: 0.84, vis: sectionIndex <= 1 ? 1 : 0 };
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
  const kfs = mobile ? sec.keyframes.map((k, i) => toMobile(k, sectionIndex + (i === sec.keyframes.length - 1 ? 1 : 0))) : sec.keyframes;
  const hold = sec.hold ?? 0;
  const u = Math.min(1, Math.max(0, (frac - hold) / (1 - hold)));
  const pos = u * (kfs.length - 1);
  const i = Math.min(kfs.length - 2, Math.floor(pos));
  return lerpPose(kfs[i], kfs[i + 1], smooth(pos - i));
}

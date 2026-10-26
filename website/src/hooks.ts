import { useEffect, useRef, useState } from 'react';
import { rig } from './scene/state';
import { SECTION_IDS } from './scene/poses';

export function useMedia(query: string) {
  const [match, setMatch] = useState(() => (typeof window === 'undefined' ? false : window.matchMedia(query).matches));
  useEffect(() => {
    const mq = window.matchMedia(query);
    const on = () => setMatch(mq.matches);
    on();
    mq.addEventListener('change', on);
    return () => mq.removeEventListener('change', on);
  }, [query]);
  return match;
}

export function hasWebGL() {
  try {
    const c = document.createElement('canvas');
    return !!(c.getContext('webgl2') || c.getContext('webgl'));
  } catch {
    return false;
  }
}

const clamp = (n: number, a: number, b: number) => Math.min(b, Math.max(a, n));

/** Maps page scroll to (section index, progress in section) for the 3D rig, and tracks the pointer. */
export function useScrollRig(onDemoActive: (active: boolean) => void) {
  const last = useRef(false);
  useEffect(() => {
    const els = SECTION_IDS.map((id) => document.getElementById(id)).filter(Boolean) as HTMLElement[];
    let raf = 0;
    const update = () => {
      raf = 0;
      const mid = window.innerHeight * 0.5;
      let i = 0;
      els.forEach((el, k) => {
        if (el.getBoundingClientRect().top <= mid) i = k;
      });
      const r = els[i].getBoundingClientRect();
      rig.section = i;
      rig.frac = clamp((mid - r.top) / Math.max(r.height, 1), 0, 1);
      const active = i === 2 && rig.frac < 0.85;
      if (active !== last.current) {
        last.current = active;
        onDemoActive(active);
      }
      const doc = document.documentElement;
      doc.style.setProperty('--progress', String(clamp(window.scrollY / Math.max(doc.scrollHeight - window.innerHeight, 1), 0, 1)));
    };
    const onScroll = () => {
      if (!raf) raf = requestAnimationFrame(update);
    };
    const onPointer = (e: PointerEvent) => {
      rig.pointerX = (e.clientX / window.innerWidth - 0.5) * 2;
      rig.pointerY = (e.clientY / window.innerHeight - 0.5) * 2;
    };
    update();
    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('resize', onScroll);
    window.addEventListener('pointermove', onPointer, { passive: true });
    return () => {
      window.removeEventListener('scroll', onScroll);
      window.removeEventListener('resize', onScroll);
      window.removeEventListener('pointermove', onPointer);
      if (raf) cancelAnimationFrame(raf);
    };
  }, [onDemoActive]);
}

/** Adds .in to [data-reveal] elements as they enter the viewport. */
export function useReveal() {
  useEffect(() => {
    const els = document.querySelectorAll<HTMLElement>('[data-reveal]');
    if (!('IntersectionObserver' in window)) {
      els.forEach((e) => e.classList.add('in'));
      return;
    }
    const io = new IntersectionObserver(
      (entries) =>
        entries.forEach((e) => {
          if (e.isIntersecting) {
            e.target.classList.add('in');
            io.unobserve(e.target);
          }
        }),
      { threshold: 0.2 },
    );
    els.forEach((e) => io.observe(e));
    return () => io.disconnect();
  }, []);
}

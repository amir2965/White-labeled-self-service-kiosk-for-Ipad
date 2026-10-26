import { lazy, Suspense, useCallback, useMemo, useState } from 'react';
import KioskApp, { type KioskStep } from './kiosk/KioskApp';
import { About, Anatomy, Demo, Engineering, Hero, Story } from './sections/Sections';
import { hasWebGL, useMedia, useReveal, useScrollRig } from './hooks';
import { site } from './site.config';

const Scene = lazy(() => import('./scene/Scene'));

export default function App() {
  const mobile = useMedia('(max-width: 820px)');
  const reduced = useMedia('(prefers-reduced-motion: reduce)');
  const webgl = useMemo(hasWebGL, []);
  const use3d = webgl && !reduced;
  const inlineDemo = mobile || !use3d;

  const [step, setStep] = useState<KioskStep>('welcome');
  const [demoActive, setDemoActive] = useState(false);
  const onDemoActive = useCallback((a: boolean) => setDemoActive(a), []);

  useScrollRig(onDemoActive);
  useReveal();

  return (
    <>
      <a className="skip" href="#demo">Skip to the demo</a>
      <div className="progress" aria-hidden="true" />
      <header className="nav">
        <a className="mark" href="#hero" aria-label="Back to top">
          <i aria-hidden="true" />
          Self-Service Kiosk
        </a>
        <nav aria-label="Primary">
          <a href="#demo">Demo</a>
          <a href="#engineering">Engineering</a>
          <a href="#story">Story</a>
          <a href={site.github} target="_blank" rel="noreferrer">GitHub ↗</a>
        </nav>
      </header>

      <div className="stage">
        {use3d && (
          <Suspense fallback={null}>
            <Scene
              mobile={mobile}
              liveActive={demoActive && !mobile}
              liveChildren={mobile ? null : <KioskApp onStep={setStep} />}
            />
          </Suspense>
        )}
        {!use3d && <div className="stage-fallback" aria-hidden="true" />}
      </div>

      <main>
        <Hero fallback={!use3d} />
        <Anatomy />
        <Demo step={step} onStep={setStep} inline={inlineDemo} />
        <Engineering />
        <Story />
        <About />
      </main>

      <footer className="footer">
        <p>
          Simulated demo: no real payments. Menu photos from Unsplash. The 3D iPad is built procedurally with three.js and is not an Apple product.
        </p>
        <p>© {new Date().getFullYear()} {site.name}</p>
      </footer>
    </>
  );
}

import { lazy, Suspense, useCallback, useMemo, useState } from 'react';
import FlutterDemo, { type FlowId } from './kiosk/FlutterDemo';
import { About, Decisions, Demo, Engineering, Hero, Merchant, Product, State, Statement } from './sections/Sections';
import { hasWebGL, useMedia, useReveal, useScrollRig } from './hooks';
import { site } from './site.config';
import Navigation from './Navigation';

const Scene = lazy(() => import('./scene/Scene'));

export default function App() {
  const mobile = useMedia('(max-width: 820px), (max-width: 1100px) and (max-height: 520px) and (pointer: coarse)');
  const reduced = useMedia('(prefers-reduced-motion: reduce)');
  const webgl = useMemo(() => !mobile && !reduced && hasWebGL(), [mobile, reduced]);
  const use3d = webgl && !reduced && !mobile;
  const inlineDemo = mobile || !use3d;

  const [flow, setFlow] = useState<FlowId>('order');
  const [nonce, setNonce] = useState(0);
  const onFlow = useCallback((f: FlowId) => {
    setFlow(f);
    setNonce((n) => n + 1);
    setEngaged(false);
  }, []);
  const onRestart = useCallback(() => {
    setNonce((n) => n + 1);
    setEngaged(false);
  }, []);
  const [engaged, setEngaged] = useState(false);
  const onEngage = useCallback((on: boolean) => setEngaged(on), []);
  const [demoActive, setDemoActive] = useState(false);
  const onDemoActive = useCallback((a: boolean) => {
    setDemoActive(a);
    if (!a) setEngaged(false);
  }, []);

  useScrollRig(onDemoActive, use3d);
  useReveal();

  return (
    <>
      <a className="skip" href="#demo">Skip to the demo</a>
      <div className="progress" aria-hidden="true" />
      <Navigation compact={mobile} />

      <div className="stage">
        {use3d && (
          <Suspense fallback={null}>
            <Scene
              mobile={mobile}
              liveActive={demoActive && !mobile}
              liveChildren={mobile ? null : <FlutterDemo flow={flow} nonce={nonce} engaged={engaged} onEngage={onEngage} />}
            />
          </Suspense>
        )}
        {!use3d && <div className="stage-fallback" aria-hidden="true" />}
        {use3d && !mobile && <div className="stage-glow" aria-hidden="true" />}
      </div>

      <main>
        <Hero fallback={!use3d} mobile={mobile} />
        <Statement reduced={reduced} mobile={mobile} />
        <Product inline={mobile} />
        <Demo flow={flow} nonce={nonce} engaged={engaged} onEngage={onEngage} onFlow={onFlow} onRestart={onRestart} inline={inlineDemo} mobile={mobile} />
        <Merchant inline={inlineDemo} />
        <Engineering inline={mobile} />
        <Decisions />
        <State />
        <About />
      </main>

      <footer className="footer">
        <p>
          Built with Flutter and Dart. Project showcase developed using React, Three.js and React Three Fiber.
        </p>
        <p>
          The demo is simulated: nothing is charged. Menu photos from Unsplash; start-screen terrace photo from Wikimedia Commons (CC0). The 3D iPad is built in code with three.js and is not an Apple product.
        </p>
        <p>© {new Date().getFullYear()} {site.name}{' · '}
          <a className="footer-mail" href={`mailto:${site.email}`}>{site.email}</a>
        </p>
      </footer>
    </>
  );
}

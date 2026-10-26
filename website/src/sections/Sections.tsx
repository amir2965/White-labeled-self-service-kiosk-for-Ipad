import { useEffect, useRef, useState, type ReactNode } from 'react';
import KioskApp, { type KioskStep } from '../kiosk/KioskApp';
import { site } from '../site.config';

const Arrow = () => <span aria-hidden="true">↗</span>;

export function Hero({ fallback }: { fallback: boolean }) {
  return (
    <section id="hero" className="section hero" aria-labelledby="hero-title">
      {fallback && (
        <img
          className="hero-static"
          src={`${import.meta.env.BASE_URL}screens/12-kiosk-welcome.png`}
          alt="The kiosk welcome screen on an iPad"
        />
      )}
      <div className="wrap">
        <p className="eyebrow" data-reveal>Self-service kiosk · iPad · Flutter</p>
        <h1 id="hero-title" data-reveal>
          A kiosk you<br />can <em>touch</em>.
        </h1>
        <p className="lede" data-reveal>
          A complete ordering system for tablets: customer kiosk, merchant back office and a simulated payment flow.
          Scroll to take it apart, then order a coffee yourself.
        </p>
        <div className="cta" data-reveal>
          <a className="btn primary" href="#demo">Try the demo</a>
          <a className="btn" href={site.github} target="_blank" rel="noreferrer">
            View the code <Arrow />
          </a>
        </div>
      </div>
      <div className="scroll-cue" aria-hidden="true"><span />Scroll</div>
    </section>
  );
}

const LAYERS = [
  { n: '01', title: 'Interface', body: 'Landscape-first, big touch targets, 20+ menu templates and a branding editor, all on one design system.' },
  { n: '02', title: 'State & domain', body: 'Riverpod providers and immutable freezed models keep the cart, pricing rules and order lifecycle predictable.' },
  { n: '03', title: 'Payments', body: 'Customer scans a QR, a phone page confirms, the server flips the session to paid and the kiosk, polling every two seconds, moves on. Simulated end to end: no card data exists anywhere.' },
  { n: '04', title: 'Data', body: 'Mock-first: every screen runs on sample data behind interfaces, so a real backend is a swap, not a rewrite.' },
];

export function Anatomy() {
  return (
    <section id="anatomy" className="section anatomy" aria-labelledby="anatomy-title">
      <div className="wrap narrow">
        <div className="block intro" data-reveal>
          <p className="eyebrow">How it’s built</p>
          <h2 id="anatomy-title">Take it apart.</h2>
          <p className="lede">Four layers, one product. Keep scrolling and the iPad separates them.</p>
        </div>
        {LAYERS.map((l) => (
          <div className="block layer" key={l.n} data-reveal>
            <span className="num">{l.n}</span>
            <h3>{l.title}</h3>
            <p>{l.body}</p>
          </div>
        ))}
      </div>
    </section>
  );
}

const STEPS: { id: KioskStep[]; label: string; hint: string }[] = [
  { id: ['welcome'], label: 'Welcome', hint: 'Tap anywhere to start. Branding is configurable in the merchant editor.' },
  { id: ['mode'], label: 'Dine in or takeaway', hint: 'Order mode is carried through to the kitchen.' },
  { id: ['menu'], label: 'Browse the menu', hint: 'Categories and cards come from the same sample menu as the Flutter app.' },
  { id: ['customize'], label: 'Customise', hint: 'Required size, optional milk, quantity. Prices update live.' },
  { id: ['checkout'], label: 'Checkout', hint: 'Cart maths: subtotal + 2.5% + $0.30 service fee, as in the app.' },
  { id: ['qr', 'done'], label: 'Pay (simulated)', hint: 'The QR is real; the phone is a button. No payment is ever taken.' },
];

function ScaledStage({ children }: { children: ReactNode }) {
  const ref = useRef<HTMLDivElement>(null);
  const [scale, setScale] = useState(0.5);
  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    const ro = new ResizeObserver(([e]) => setScale(e.contentRect.width / 1024));
    ro.observe(el);
    return () => ro.disconnect();
  }, []);
  return (
    <div ref={ref} className="scaled" style={{ height: 712 * scale }}>
      <div style={{ width: 1024, height: 712, transform: `scale(${scale})`, transformOrigin: '0 0' }}>{children}</div>
    </div>
  );
}

export function Demo({ step, onStep, inline }: { step: KioskStep; onStep: (s: KioskStep) => void; inline: boolean }) {
  return (
    <section id="demo" className="section demo" aria-labelledby="demo-title">
      <div className="demo-sticky">
        <div className="demo-panel">
          <p className="eyebrow">Live demo</p>
          <h2 id="demo-title">Order a coffee.</h2>
          <p className="lede">
            A web re-creation of the Flutter app’s ordering flow, running in your browser.
            {inline ? ' Best in landscape or on a larger screen.' : ' It’s a real interactive screen inside the 3D iPad.'}
          </p>
          <ol className="steps" aria-label="Ordering steps">
            {STEPS.map((s, i) => {
              const on = s.id.includes(step);
              return (
                <li key={s.label} className={on ? 'on' : ''} aria-current={on ? 'step' : undefined}>
                  <span>{i + 1}</span>
                  <div>
                    <strong>{s.label}</strong>
                    <small>{s.hint}</small>
                  </div>
                </li>
              );
            })}
          </ol>
          <p className="note">
            <b>Simulated:</b> payment, the customer’s phone, order submission. <b>Real:</b> menu data, modifiers and cart maths.
          </p>
        </div>
        {inline && (
          <div className="inline-device">
            <ScaledStage>
              <KioskApp onStep={onStep} />
            </ScaledStage>
          </div>
        )}
      </div>
    </section>
  );
}

const CARDS = [
  { t: 'Flutter + Riverpod', d: 'Immutable state with freezed models; providers own the cart, menu and branding.' },
  { t: 'Layered like a product', d: 'Domain, data and presentation separated, with mock data sources behind interfaces.' },
  { t: 'Payments, safely fake', d: 'QR session → phone checkout → server marks paid → kiosk polls. Built against a tiny shelf server so the whole loop runs locally.' },
  { t: 'Merchant back office', d: 'Five-step onboarding, template gallery, branding editor with a 25-font selector, menu management with drag-to-reorder.' },
  { t: 'Operational views', d: 'Kitchen display, sales analytics with fl_chart and a payouts module with CSV/PDF export, on sample data.' },
  { t: 'Verified honestly', d: 'Core flows exercised end to end on web, 19 unit tests, and every simulated or sample-data screen is labelled as such.' },
];

const STATS = [
  ['190+', 'Dart source files'],
  ['20+', 'menu templates'],
  ['2', 'payment paths'],
  ['$0', 'real transactions'],
];

export function Engineering() {
  return (
    <section id="engineering" className="section engineering" aria-labelledby="eng-title">
      <div className="wrap">
        <p className="eyebrow" data-reveal>Engineering</p>
        <h2 id="eng-title" data-reveal>What I actually built.</h2>
        <dl className="stats" data-reveal>
          {STATS.map(([n, l]) => (
            <div key={l}>
              <dt>{n}</dt>
              <dd>{l}</dd>
            </div>
          ))}
        </dl>
        <div className="cards">
          {CARDS.map((c, i) => (
            <article className="card" key={c.t} data-reveal style={{ transitionDelay: `${(i % 3) * 80}ms` }}>
              <h3>{c.t}</h3>
              <p>{c.d}</p>
            </article>
          ))}
        </div>
        <p className="stack" data-reveal>
          Flutter 3 · Dart · Riverpod · go_router · freezed · fl_chart · shelf · this site: React · three.js · React Three Fiber
        </p>
      </div>
    </section>
  );
}

const STORY = [
  ['Library nights', 'It started as a question: could one person build smart, self-service ordering for small hospitality businesses?'],
  ['A working platform', 'A white-label kiosk for iPads: onboarding, AI-assisted menu extraction, analytics and QR payments.'],
  ['Real interest', 'Showing it around drew genuine attention from people in the industry.'],
  ['Paused, not wasted', 'Payment infrastructure and a fair long-term income model for everyone involved were the hard parts. The engineering lessons stayed with me.'],
];

export function Story() {
  return (
    <section id="story" className="section story" aria-labelledby="story-title">
      <div className="wrap right">
        <p className="eyebrow" data-reveal>The story</p>
        <h2 id="story-title" data-reveal>From idea to product.</h2>
        <ol className="timeline">
          {STORY.map(([t, d]) => (
            <li key={t} data-reveal>
              <h3>{t}</h3>
              <p>{d}</p>
            </li>
          ))}
        </ol>
        <a className="link" href={site.linkedinPost} target="_blank" rel="noreferrer" data-reveal>
          Read the LinkedIn post <Arrow />
        </a>
      </div>
    </section>
  );
}

export function About() {
  return (
    <section id="about" className="section about" aria-labelledby="about-title">
      <div className="wrap">
        <p className="eyebrow" data-reveal>About</p>
        <h2 id="about-title" data-reveal>
          I’m Amir.
        </h2>
        <p className="lede" data-reveal>
          {site.role} based in {site.location}. I like taking a product from a rough idea to something people can actually use,
          and being honest about what’s real and what’s simulated along the way.
        </p>
        <p className="lede" data-reveal>
          Open to internships and junior roles, and happy to talk about kiosk and ordering systems for hospitality.
        </p>
        <div className="cta" data-reveal>
          <a className="btn primary" href={site.linkedinProfile} target="_blank" rel="noreferrer">
            LinkedIn <Arrow />
          </a>
          <a className="btn" href={site.githubProfile} target="_blank" rel="noreferrer">
            GitHub <Arrow />
          </a>
          <a className="btn" href={site.github} target="_blank" rel="noreferrer">
            Kiosk source <Arrow />
          </a>
          {site.email && (
            <a className="btn" href={`mailto:${site.email}`}>
              Email
            </a>
          )}
        </div>
      </div>
    </section>
  );
}

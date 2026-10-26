import { useEffect, useRef, useState, type ReactNode } from 'react';
import KioskApp, { type KioskStep } from '../kiosk/KioskApp';
import { site } from '../site.config';

const Arrow = () => <span aria-hidden="true">↗</span>;
const shot = (name: string) => `${import.meta.env.BASE_URL}screens/${name}.png`;

/* ------------------------------------------------------------------ Hero */

export function Hero({ fallback }: { fallback: boolean }) {
  return (
    <section id="hero" className="section hero" aria-labelledby="hero-title">
      {fallback && <img className="hero-static" src={shot('12-kiosk-welcome')} alt="The kiosk welcome screen on an iPad" />}
      <div className="wrap">
        <p className="eyebrow" data-reveal>iPad ordering kiosk · built with Flutter</p>
        <h1 id="hero-title" data-reveal>
          A kiosk you<br />can <em>touch</em>.
        </h1>
        <p className="lede" data-reveal>
          I designed and built a self-service ordering kiosk for iPads: the customer screens, the owner’s back office and a
          pretend payment flow. Scroll to see how it’s put together, then place an order yourself.
        </p>
        <div className="cta" data-reveal>
          <a className="btn primary" href="#demo">Try the demo</a>
          <a className="btn" href={site.github} target="_blank" rel="noreferrer">
            See the code <Arrow />
          </a>
        </div>
      </div>
      <div className="scroll-cue" aria-hidden="true"><span />Scroll</div>
    </section>
  );
}

/* -------------------------------------------------------------- Anatomy */

const LAYERS = [
  {
    n: '01',
    title: 'Interface',
    body: 'What the customer sees. Landscape screens with big buttons, more than 20 menu layouts to pick from, and an editor where a business sets its own colours, fonts and welcome page.',
  },
  {
    n: '02',
    title: 'State and logic',
    body: 'Riverpod keeps track of the cart, the menu and the branding. Prices, the service fee and the order steps live here, not inside the screens.',
  },
  {
    n: '03',
    title: 'Payments',
    body: 'At checkout the customer pays at the counter or scans a QR code. A small server remembers the order, and the kiosk asks it every two seconds whether it has been paid. All of it is pretend: no card is ever used.',
  },
  {
    n: '04',
    title: 'Data',
    body: 'The app runs on sample data behind interfaces, so a real backend can be plugged in later. There is a MongoDB version in the code, but it isn’t connected yet.',
  },
];

function VizShell({ n, title, path, children }: { n: string; title: string; path: string; children: ReactNode }) {
  return (
    <div className="viz-card">
      <header>
        <span>{n}</span>
        <strong>{title}</strong>
      </header>
      <div className="viz-body">{children}</div>
      <footer>{path}</footer>
    </div>
  );
}

function Viz({ id }: { id: number }) {
  if (id === 0) {
    return (
      <VizShell n="01" title="Interface" path="lib/presentation/kiosk · branding · onboarding">
        <div className="shots">
          <img className="main" src={shot('13-kiosk-menu')} alt="Kiosk menu screen with category rail and product cards" />
          <img src={shot('03-template-gallery')} alt="Menu template gallery" />
          <img src={shot('09-branding-typography')} alt="Branding editor with typography selection" />
        </div>
      </VizShell>
    );
  }
  if (id === 1) {
    return (
      <VizShell n="02" title="State and logic" path="lib/presentation/providers/cart_provider.dart">
        <pre className="code" aria-label="Simplified excerpt of the Dart cart state">
          <span className="c">// simplified excerpt</span>
          {'\n'}
          <span className="k">class</span> CartState {'{'}
          {'\n  '}
          <span className="k">double get</span> subtotal =&gt;
          {'\n      '}items.fold(0.0, (s, i) =&gt; s + i.totalPrice);
          {'\n  '}
          <span className="k">double get</span> serviceFee {'{ … }'}
          {'\n  '}
          <span className="c">// 2.5% + $0.30</span>
          {'\n  '}
          <span className="k">double get</span> total =&gt;
          {'\n      '}subtotal + serviceFee;
          {'\n}\n\n'}
          <span className="k">final</span> cartProvider =
          {'\n  '}StateNotifierProvider&lt;
          {'\n      '}CartNotifier, CartState&gt;(…);
        </pre>
        <p className="viz-note">Screens only read this state. They never calculate prices themselves.</p>
      </VizShell>
    );
  }
  if (id === 2) {
    const rows: [string, string, string][] = [
      ['Kiosk', 'POST /api/orders', 'Sends the order and shows a QR code'],
      ['Phone', 'POST /api/payments/process', 'Customer taps pay on the checkout page (pretend)'],
      ['Server', 'session → paid', 'Marks the payment session as paid'],
      ['Kiosk', 'GET /api/payment-sessions/:id', 'Asks every 2 seconds, then shows “Payment received”'],
    ];
    return (
      <VizShell n="03" title="Payments" path="lib/server/payment_server.dart · web/checkout.html">
        <ol className="flow">
          {rows.map(([who, call, what], i) => (
            <li key={call}>
              <span className={`who who-${who.toLowerCase()}`}>{who}</span>
              <div>
                <code>{call}</code>
                <small>{what}</small>
              </div>
              <i aria-hidden="true">{i + 1}</i>
            </li>
          ))}
        </ol>
      </VizShell>
    );
  }
  return (
    <VizShell n="04" title="Data" path="lib/data · lib/features/payouts/data">
      <ul className="tree">
        <li>
          <b>Screens</b>
          <small>read data through interfaces</small>
        </li>
        <li>
          <code>ApiDataSource</code> <small>interface</small>
          <ul>
            <li>
              <code>MockApiDataSource</code> <em className="ok">in use</em>
            </li>
          </ul>
        </li>
        <li>
          <code>SalesRepository</code> <small>interface</small>
          <ul>
            <li>
              <code>MockSalesRepository</code> <em className="ok">in use</em>
            </li>
            <li>
              <code>MongoSalesRepository</code> <em className="todo">stub, not connected</em>
            </li>
          </ul>
        </li>
        <li>
          <code>MockPayoutsRepository</code> <em className="ok">in use</em>
        </li>
      </ul>
    </VizShell>
  );
}

export function Anatomy({ inline }: { inline: boolean }) {
  const [active, setActive] = useState(0);
  const refs = useRef<(HTMLDivElement | null)[]>([]);

  useEffect(() => {
    const io = new IntersectionObserver(
      (entries) =>
        entries.forEach((e) => {
          if (e.isIntersecting) setActive(Number((e.target as HTMLElement).dataset.i));
        }),
      { rootMargin: '-45% 0px -45% 0px' },
    );
    refs.current.forEach((el) => el && io.observe(el));
    return () => io.disconnect();
  }, []);

  return (
    <section id="anatomy" className="section anatomy" aria-labelledby="anatomy-title">
      <div className="wrap anatomy-grid">
        <div className="anatomy-text">
          <div className="block intro" data-reveal>
            <div className="panel">
              <p className="eyebrow">How it’s put together</p>
              <h2 id="anatomy-title">Four layers.</h2>
              <p className="lede">Keep scrolling. Each layer swaps in on the right.</p>
            </div>
          </div>
          {LAYERS.map((l, i) => (
            <div className="block layer" key={l.n} data-i={i} ref={(el) => { refs.current[i] = el; }}>
              <div className="panel">
                <span className="num">{l.n}</span>
                <h3>{l.title}</h3>
                <p>{l.body}</p>
                {inline && (
                  <div className="viz-inline">
                    <Viz id={i} />
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
        {!inline && (
          <div className="viz-sticky" aria-hidden="true">
            {LAYERS.map((l, i) => (
              <div key={l.n} className={`viz${active === i ? ' on' : ''}`}>
                <Viz id={i} />
              </div>
            ))}
          </div>
        )}
      </div>
    </section>
  );
}

/* ----------------------------------------------------------------- Demo */

const STEPS: { id: KioskStep[]; label: string; hint: string }[] = [
  { id: ['welcome'], label: 'Welcome', hint: 'Tap to begin. In the real app the owner chooses this page’s photo, font and colours.' },
  { id: ['mode'], label: 'Dine in or takeaway', hint: 'The customer says how they want the order.' },
  { id: ['menu'], label: 'Browse the menu', hint: 'Same sample menu as the Flutter app.' },
  { id: ['customize'], label: 'Customise', hint: 'Size is required, milk is optional. The price updates as you choose.' },
  { id: ['checkout'], label: 'Checkout', hint: 'Subtotal plus a 2.5% + $0.30 service fee, the same rule as the app.' },
  { id: ['qr', 'done'], label: 'Pay (pretend)', hint: 'Scan to pay or pay at the counter. Nothing is charged.' },
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
          <p className="eyebrow">Try it</p>
          <h2 id="demo-title">Order a coffee.</h2>
          <p className="lede">
            A web version of the ordering flow.{inline ? ' Works best in landscape or on a bigger screen.' : ' It’s a live screen inside the 3D iPad, so tap away.'}
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
            <b>Pretend:</b> the payment, the phone and sending the order. <b>Real logic:</b> the menu, the options and the price maths.
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

/* ---------------------------------------------------------- Engineering */

const CARDS = [
  { t: 'Flutter and Riverpod', d: 'State lives in providers and the models are immutable (freezed). The cart, the menu and the branding each have their own.' },
  { t: 'Three layers', d: 'Domain, data and presentation are kept apart, so screens never talk to the sample data directly.' },
  { t: 'Payments, end to end', d: 'A small Dart server (shelf) holds the order. The kiosk shows a QR code, a checkout page marks the order paid, and the kiosk polls until it sees that.' },
  { t: 'The owner’s back office', d: 'A five-step setup wizard, a template gallery, a branding editor with 25 fonts, and menu management with drag to reorder.' },
  { t: 'Kitchen and reports', d: 'A kitchen display, sales charts (fl_chart) and a payouts section with CSV and PDF export. These run on sample data.' },
  { t: 'What I tested', d: 'I ran the main flows end to end in Chrome and wrote 19 unit tests (money maths and CSV export). Anything that is sample data or pretend is labelled.' },
];

const STATS = [
  ['190+', 'Dart files'],
  ['20+', 'menu layouts'],
  ['2', 'ways to pay'],
  ['0', 'real payments'],
];

export function Engineering() {
  return (
    <section id="engineering" className="section engineering" aria-labelledby="eng-title">
      <div className="wrap">
        <div className="panel head" data-reveal>
          <p className="eyebrow">In the code</p>
          <h2 id="eng-title">What I built.</h2>
        </div>
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
        <p className="stack panel" data-reveal>
          Flutter · Dart · Riverpod · go_router · freezed · fl_chart · shelf. This website: React, three.js, React Three Fiber.
        </p>
      </div>
    </section>
  );
}

/* -------------------------------------------------------------- Concept */

export function Story() {
  return (
    <section id="story" className="section story" aria-labelledby="story-title">
      <div className="wrap right">
        <div className="panel" data-reveal>
          <p className="eyebrow">The concept</p>
          <h2 id="story-title">A white-label kiosk for iPad.</h2>
          <p className="prose">
            I wanted professional self-service to feel simple for any business. A café, restaurant or shop puts the app on an
            iPad and customers browse the menu, customise their order and check out on their own.
          </p>
          <p className="prose">
            Each business sets its own branding, colours, products and layout, so the kiosk feels like part of that business
            instead of a generic machine.
          </p>
          <blockquote>
            Make professional self-service technology more accessible, adaptable and effortless for businesses of different
            sizes.
          </blockquote>
          <p className="prose">
            Rather than one kiosk for one industry, I built a flexible base: reusable components, customisable templates and
            one design system.
          </p>
          <p className="fine">
            An independently designed product concept and interactive software demonstration, not a claim of commercial
            deployment.
          </p>
          <a className="link" href={site.linkedinPost} target="_blank" rel="noreferrer">
            I wrote about the project on LinkedIn <Arrow />
          </a>
        </div>
      </div>
    </section>
  );
}

/* ---------------------------------------------------------------- About */

export function About() {
  return (
    <section id="about" className="section about" aria-labelledby="about-title">
      <div className="wrap">
        <div className="panel" data-reveal>
          <p className="eyebrow">About</p>
          <h2 id="about-title">I’m {site.firstName}.</h2>
          <p className="prose">
            I’m a software engineer based in {site.location}. I like taking an idea all the way to something people can use,
            and I try to be clear about what is real and what is pretend.
          </p>
          <p className="prose">
            I’m looking for internships and junior roles. If you run a café or restaurant and want to talk about ordering
            systems, get in touch.
          </p>
          <div className="cta">
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
      </div>
    </section>
  );
}

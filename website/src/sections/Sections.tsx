import { useEffect, useRef, useState, type ReactNode } from 'react';
import FlutterDemo, { FLOWS, type FlowId } from '../kiosk/FlutterDemo';
import { MILKS, PRODUCTS, SIZES, money, serviceFee } from '../kiosk/data';
import { site } from '../site.config';
import MobileDemo from '../kiosk/MobileDemo';
import ScreenImage from '../ScreenImage';

const Arrow = () => <span aria-hidden="true">↗</span>;
const shot = (name: string) => `${import.meta.env.BASE_URL}screens/${name}.png`;
const inertIf = (on: boolean) => (on ? { inert: '' } : {});

type Tone = 'working' | 'sample' | 'simulated' | 'todo';
const Badge = ({ tone, children }: { tone: Tone; children: ReactNode }) => <em className={`badge ${tone}`}>{children}</em>;

/* ------------------------------------------------------------------ Hero */

export function Hero({ fallback, mobile }: { fallback: boolean; mobile: boolean }) {
  return (
    <section id="hero" className="section hero" aria-labelledby="hero-title">
      {fallback && !mobile && <img className="hero-static" src={shot('12-kiosk-welcome')} alt="The kiosk welcome screen on an iPad" />}
      <div className="wrap">
        <p className="eyebrow" data-reveal>Independent kiosk project · Flutter / Dart</p>
        <h1 id="hero-title" data-reveal>
          One kiosk.<br />Different<br /><em>businesses.</em>
        </h1>
        <p className="lede" data-reveal>
          <span className="hero-summary">A configurable self-service kiosk and interactive ordering experience built with Flutter.</span>{' '}<span className="hero-context">I designed and developed it to explore how a
          single tablet application could support different restaurants and cafés without a completely different interface
          for each business.</span>
        </p>
        <p className="lede sub" data-reveal>
          It brings together a customer ordering experience, merchant configuration tools and a simulated QR payment workflow.
        </p>
        <div className="cta" data-reveal>
          <a className="btn primary" href="#demo">{mobile ? 'Watch the walkthrough' : 'Explore the interactive demo'}</a>
          <a className="btn" href={site.github} target="_blank" rel="noreferrer">
            View source code <Arrow />
          </a>
        </div>
        {mobile && (
          <figure className="hero-device">
            <div className="hero-device-bar"><span /><span>Made for the way you order</span><span>01 / 04</span></div>
            <img src={`${import.meta.env.BASE_URL}screens/12-kiosk-welcome-640.webp`} srcSet={`${import.meta.env.BASE_URL}screens/12-kiosk-welcome-640.webp 640w, ${import.meta.env.BASE_URL}screens/12-kiosk-welcome-1024.webp 1024w`} sizes="(max-width: 600px) 90vw, 560px" width={1024} height={712} fetchPriority="high" alt="Demo Café kiosk: fresh coffee, no queue. Start order." />
            <figcaption><span><i />One app. Your identity.</span><span>Flutter / Dart</span></figcaption>
          </figure>
        )}
        <ul className="status-strip" data-reveal aria-label="Project status">
          <li>Independent prototype</li>
          <li>Browser-tested at tablet dimensions</li>
          <li>Payments simulated</li>
        </ul>
      </div>
      <div className="scroll-cue" aria-hidden="true"><span />Scroll</div>
    </section>
  );
}

/* ---------------------------------------------------------- Statement */

/** Full-width cinematic band: a muted looping clip, always playing on phones. */
export function Statement({ reduced, mobile }: { reduced: boolean; mobile: boolean }) {
  const ref = useRef<HTMLVideoElement>(null);
  const [blocked, setBlocked] = useState(false);

  useEffect(() => {
    const v = ref.current;
    if (!v || reduced) return;

    if (mobile) {
      let disposed = false;
      let io: IntersectionObserver | null = null;
      const play = () => {
        if (disposed || !v.paused) return;
        v.play().then(() => setBlocked(false)).catch(() => setBlocked(true));
      };
      const onVisibility = () => {
        if (document.visibilityState === 'visible') play();
      };
      const clearBlocked = () => setBlocked(false);
      // Muted inline playback starts as the film approaches the viewport, then
      // keeps running off screen. These listeners retry after a browser policy
      // delay, returning to the tab, or the first touch.
      v.addEventListener('playing', clearBlocked);
      v.addEventListener('canplay', play);
      window.addEventListener('pageshow', play);
      document.addEventListener('visibilitychange', onVisibility);
      document.addEventListener('pointerdown', play, { passive: true });
      if ('IntersectionObserver' in window) {
        io = new IntersectionObserver(([e]) => {
          if (!e.isIntersecting) return;
          play();
          io?.disconnect();
        }, { rootMargin: '200px 0px' });
        io.observe(v);
      } else {
        play();
      }
      return () => {
        disposed = true;
        io?.disconnect();
        v.removeEventListener('playing', clearBlocked);
        v.removeEventListener('canplay', play);
        window.removeEventListener('pageshow', play);
        document.removeEventListener('visibilitychange', onVisibility);
        document.removeEventListener('pointerdown', play);
      };
    }

    if (!('IntersectionObserver' in window)) return;
    const io = new IntersectionObserver(([e]) => (e.isIntersecting ? v.play().catch(() => {}) : v.pause()), { threshold: 0.25 });
    io.observe(v);
    return () => io.disconnect();
  }, [reduced, mobile]);

  const base = import.meta.env.BASE_URL;
  return (
    <section id="statement" className="section statement" aria-labelledby="statement-title">
      <div className="statement-media">
        <video
          ref={ref}
          muted
          loop
          playsInline
          preload="none"
          poster={mobile ? `${base}media/white-label-poster-1024.webp` : `${base}media/white-label-poster.jpg`}
          disablePictureInPicture
          aria-hidden="true"
          tabIndex={-1}
          onClick={() => mobile && ref.current?.play().then(() => setBlocked(false)).catch(() => setBlocked(true))}
        >
          {!reduced && <source src={`${base}media/${mobile ? 'white-label-mobile.mp4' : 'white-label.mp4'}`} type="video/mp4" />}
        </video>
        {mobile && blocked && (
          <button type="button" className="statement-play" onClick={() => ref.current?.play().then(() => setBlocked(false)).catch(() => setBlocked(true))}>
            <span aria-hidden="true">▶</span> Play film
          </button>
        )}
      </div>
      <div className="wrap statement-copy" data-reveal>
        <div className="panel-in">
          <p className="eyebrow">The idea</p>
          <h2 id="statement-title">One kiosk, many brands.</h2>
          <p className="lede">
            The same kiosk app can carry a different name, logo, colours, fonts and menu layout for each business. This
            project explores how far that idea can go.
          </p>
        </div>
      </div>
    </section>
  );
}

/* ------------------------------------------------------------ Walkthrough */

interface Step {
  n: string;
  title: string;
  body: ReactNode;
  tags?: string[];
}

interface WalkthroughProps {
  id: string;
  eyebrow: string;
  title: string;
  lede: ReactNode;
  steps: Step[];
  inline: boolean;
  interactive?: boolean;
  viz?: (i: number) => ReactNode;
  intro?: ReactNode;
  outro?: ReactNode;
}

/** Text scrolls on the left; the active step's visual (or the 3D iPad) is shown on the right. */
function Walkthrough({ id, eyebrow, title, lede, steps, inline, interactive, viz, intro, outro }: WalkthroughProps) {
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
    <section id={id} className={`section anatomy ${id}`} aria-labelledby={`${id}-title`}>
      <div className="wrap anatomy-grid">
        <div className="anatomy-text">
          <div className="block intro" data-reveal>
            <div className="panel">
              <p className="eyebrow">{eyebrow}</p>
              <h2 id={`${id}-title`}>{title}</h2>
              {lede}
              {intro}
            </div>
          </div>
          {steps.map((s, i) => (
            <div className={`block layer${active === i ? ' on' : ''}`} key={s.n} data-i={i} ref={(el) => { refs.current[i] = el; }}>
              <div className="panel">
                <span className="num">{s.n}</span>
                <h3>{s.title}</h3>
                {s.body}
                {s.tags && (
                  <ul className="tags" aria-label="Technologies">
                    {s.tags.map((t) => <li key={t}>{t}</li>)}
                  </ul>
                )}
                {inline && viz && <div className="viz-inline">{viz(i)}</div>}
              </div>
            </div>
          ))}
          {outro}
        </div>
        {!inline && viz && (
          <div className="viz-sticky" {...(interactive ? {} : { 'aria-hidden': true })}>
            {steps.map((s, i) => (
              <div key={s.n} className={`viz${active === i ? ' on' : ''}`} {...(interactive ? inertIf(active !== i) : {})}>
                {viz(i)}
              </div>
            ))}
            <ol className="viz-dots" aria-hidden="true">
              {steps.map((s, i) => <li key={s.n} className={active === i ? 'on' : ''} />)}
            </ol>
          </div>
        )}
      </div>
    </section>
  );
}

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

/* -------------------------------------------------------------- Product */

const PRODUCT_STEPS: Step[] = [
  {
    n: '01',
    title: 'Start an order',
    body: <p>Choose dine-in or takeaway from a landscape-oriented touch interface.</p>,
  },
  {
    n: '02',
    title: 'Explore the menu',
    body: <p>Browse categories, view products and select items without navigating through complicated menus.</p>,
  },
  {
    n: '03',
    title: 'Make it yours',
    body: <p>Choose sizes, milk preferences, quantities and other available options. The cart updates as selections change.</p>,
  },
  {
    n: '04',
    title: 'Review and check out',
    body: <p>See the order breakdown and complete one of two simulated checkout paths: pay at counter or QR checkout.</p>,
  },
];

const LATTE = PRODUCTS[0];

export function Product({ inline }: { inline: boolean }) {
  const [size, setSize] = useState('M');
  const [milk, setMilk] = useState('oat');
  const sz = SIZES.find((s) => s.id === size)!;
  const mk = MILKS.find((m) => m.id === milk)!;
  const unit = LATTE.price + sz.add + mk.add;
  const fee = serviceFee(unit);

  const viz = (i: number) => {
    if (i === 0) {
      return (
        <VizShell n="01" title="Start an order" path="Start screen · web demo of the kiosk">
          <ScreenImage className="solo" name="12-kiosk-welcome" alt="Kiosk start screen: outdoor restaurant terrace background, café logo, title and Start order button" />
        </VizShell>
      );
    }
    if (i === 1) {
      return (
        <VizShell n="02" title="Explore the menu" path="Screenshot · Flutter app, landscape tablet">
          <ScreenImage className="solo" name="13-kiosk-menu" alt="Kiosk menu screen with category rail and product cards" />
        </VizShell>
      );
    }
    if (i === 2) {
      return (
        <VizShell n="03" title="Make it yours" path="Try it · the same size and milk options as the demo">
          <div className="opt-item">
            <img src={`${import.meta.env.BASE_URL}menu/latte-thumb.webp`} alt="" width={64} height={64} loading="lazy" decoding="async" />
            <div>
              <strong>{LATTE.name}</strong>
              <small>{LATTE.desc}</small>
            </div>
            <b key={unit} className="price-pop">{money(unit)}</b>
          </div>
          <fieldset className="chips">
            <legend>Size</legend>
            {SIZES.map((s) => (
              <button type="button" key={s.id} aria-pressed={size === s.id} className={size === s.id ? 'on' : ''} onClick={() => setSize(s.id)}>
                {s.label}
                <small>{s.add ? `+${money(s.add)}` : 'included'}</small>
              </button>
            ))}
          </fieldset>
          <fieldset className="chips">
            <legend>Milk</legend>
            {MILKS.map((m) => (
              <button type="button" key={m.id} aria-pressed={milk === m.id} className={milk === m.id ? 'on' : ''} onClick={() => setMilk(m.id)}>
                {m.label}
                <small>{m.add ? `+${money(m.add)}` : 'included'}</small>
              </button>
            ))}
          </fieldset>
        </VizShell>
      );
    }
    return (
      <VizShell n="04" title="Review and check out" path="Payment is simulated · no financial provider is connected">
        <dl className="receipt">
          <div>
            <dt>{LATTE.name} · {sz.label} · {mk.label} milk</dt>
            <dd>{money(unit)}</dd>
          </div>
          <div>
            <dt>Service fee <small>2.5% + $0.30</small></dt>
            <dd>{money(fee)}</dd>
          </div>
          <div className="total">
            <dt>Total</dt>
            <dd key={unit} className="price-pop">{money(unit + fee)}</dd>
          </div>
        </dl>
        <div className="paths">
          <div>
            <strong>Pay at counter</strong>
            <Badge tone="simulated">Simulated</Badge>
          </div>
          <div>
            <strong>QR checkout</strong>
            <Badge tone="simulated">Simulated</Badge>
          </div>
        </div>
      </VizShell>
    );
  };

  return (
    <Walkthrough
      id="product"
      eyebrow="01 / The product"
      title="Self-service ordering, end to end."
      lede={<p className="lede">The customer experience follows the steps of a typical restaurant order, from the first screen to checkout.</p>}
      steps={PRODUCT_STEPS}
      inline={inline}
      interactive
      viz={viz}
      outro={
        <div className="block outro" data-reveal>
          <p className="panel callout">
            <Badge tone="working">Working</Badge> The ordering flow is functional in the prototype.{' '}
            <Badge tone="simulated">Simulated</Badge> Payment processing does not connect to a financial provider.
          </p>
        </div>
      }
    />
  );
}

/* ----------------------------------------------------------------- Demo */

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

interface DemoProps {
  flow: FlowId;
  nonce: number;
  engaged: boolean;
  onEngage: (on: boolean) => void;
  onFlow: (f: FlowId) => void;
  onRestart: () => void;
  inline: boolean;
  mobile?: boolean;
}

export function Demo({ flow, nonce, engaged, onEngage, onFlow, onRestart, inline, mobile }: DemoProps) {
  if (mobile) return <MobileDemo />;
  const cur = FLOWS.find((f) => f.id === flow)!;
  const hint = (
    <button type="button" className={`demo-hint${engaged ? ' on' : ''}`} onClick={() => onEngage(false)} disabled={!engaged}>
      <i aria-hidden="true" />
      {engaged ? (
        <>
          Interacting · <b>Done</b> or press <kbd>Esc</kbd> to scroll the page
        </>
      ) : (
        'Real Flutter app · sample data · scroll freely, click the screen to interact'
      )}
    </button>
  );
  return (
    <section id="demo" className="section demo" aria-labelledby="demo-title">
      <div className="demo-sticky">
        <div className="demo-panel">
          <p className="eyebrow">02 / Interactive demo</p>
          <h2 id="demo-title">Give it a try.</h2>
          <p className="lede">
            This is the Flutter app itself, built for the web. Pick an experience, then click the screen to use it.
          </p>
          <div className="flows" role="group" aria-label="Choose an experience">
            {FLOWS.map((f, i) => (
              <button
                type="button"
                key={f.id}
                className={`pick${f.id === flow ? ' on' : ''}`}
                aria-pressed={f.id === flow}
                onClick={() => onFlow(f.id)}
              >
                <span className="n">{i + 1}</span>
                <span className="t">
                  <strong>{f.title}</strong>
                  <small>{f.blurb}</small>
                  <ol className="try" aria-label="Things to try">
                    {f.tryIt.map((s) => (
                      <li key={s}>{s}</li>
                    ))}
                  </ol>
                </span>
              </button>
            ))}
          </div>
          <div className="flow-foot">
            <Badge tone={cur.tone}>{cur.tag}</Badge>
            <button type="button" className="restart" onClick={onRestart}>
              Restart
            </button>
          </div>
          <p className="note">
            <b>Demo note:</b> all products, prices and sales figures are sample data. Payment and menu scanning are simulated; no real payment takes place.
          </p>
        </div>
        {inline && (
          <div className="inline-device">
            <ScaledStage>
              <FlutterDemo flow={flow} nonce={nonce} engaged={engaged} onEngage={onEngage} />
            </ScaledStage>
            {hint}
          </div>
        )}
        {!inline && <div className="demo-hint-wrap">{hint}</div>}
      </div>
    </section>
  );
}

/* ------------------------------------------------------------- Merchant */

const MERCHANT_STEPS: Step[] = [
  {
    n: 'A',
    title: 'Setup and branding',
    body: <p>A five-step onboarding experience, reusable menu templates, colour settings, typography options and configurable welcome screens.</p>,
  },
  {
    n: 'B',
    title: 'Menu management',
    body: <p>Tools for organising categories, editing products and rearranging menu items.</p>,
  },
  {
    n: 'C',
    title: 'Kitchen and reporting',
    body: <p>Prototype screens for kitchen orders, sales analytics and payout information, including CSV and PDF export capabilities.</p>,
  },
];

const MERCHANT_SHOTS: [string, string][][] = [
  [['09-branding-typography', 'Branding editor with typography selection']],
  [['03-template-gallery', 'Menu template gallery']],
  [['06-kitchen-display', 'Kitchen display'], ['07-analytics', 'Sales analytics dashboard']],
];

const MERCHANT_STATS: [string, string][] = [
  ['20+', 'menu layout options'],
  ['25', 'fonts in the typography selector'],
  ['5', 'onboarding steps'],
];

export function Merchant({ inline }: { inline: boolean }) {
  return (
    <Walkthrough
      id="merchant"
      eyebrow="03 / Merchant experience"
      title="The other side of the screen."
      lede={
        <p className="lede">
          I also developed a merchant-facing administration interface to explore how businesses could configure their own
          kiosk rather than rely on a fixed design.
        </p>
      }
      intro={
        <dl className="stats mini">
          {MERCHANT_STATS.map(([n, l]) => (
            <div key={l}>
              <dt>{n}</dt>
              <dd>{l}</dd>
            </div>
          ))}
        </dl>
      }
      steps={MERCHANT_STEPS}
      inline={inline}
      viz={
        inline
          ? (i) => (
              <div className="shots">
                {MERCHANT_SHOTS[i].map(([name, alt]) => (
                  <ScreenImage key={name} className={MERCHANT_SHOTS[i].length === 1 ? 'main' : ''} name={name} alt={alt} />
                ))}
              </div>
            )
          : undefined
      }
      outro={
        <div className="block outro" data-reveal>
          <p className="panel callout">
            <Badge tone="sample">Sample data</Badge> These administration interfaces currently use sample or in-memory data.
            They demonstrate the intended workflows rather than a connected production merchant system.
          </p>
        </div>
      }
    />
  );
}

/* ---------------------------------------------------------- Engineering */

const ENGINEERING_STEPS: Step[] = [
  {
    n: 'A',
    title: 'Application state',
    body: (
      <>
        <p>I used Riverpod to manage shared state for the cart, menu and branding settings.</p>
        <p>This keeps information such as selected products and checkout calculations separate from the widgets displaying them.</p>
        <p>Immutable models built with Freezed help keep application data predictable as it moves between components.</p>
      </>
    ),
    tags: ['Flutter', 'Dart', 'Riverpod', 'Freezed'],
  },
  {
    n: 'B',
    title: 'Data access',
    body: (
      <>
        <p>The application uses repository and data-source abstractions.</p>
        <p>
          For this prototype, the active implementations provide sample data. This lets the interfaces be developed and
          demonstrated without requiring a deployed database.
        </p>
        <p>The repository also contains groundwork for a MongoDB-backed implementation, but that connection is not active.</p>
      </>
    ),
    tags: ['Repository pattern', 'Data-source interfaces', 'Mock implementations'],
  },
  {
    n: 'C',
    title: 'Simulated payment flow',
    body: (
      <>
        <p>I built a small Dart server using Shelf to model an order moving from checkout to payment confirmation.</p>
        <p>
          The kiosk creates an order and displays a QR code. A separate browser page represents the customer’s phone checkout.
          When the simulated payment is completed, the server updates the session and the kiosk checks for the new status.
        </p>
        <p>The kiosk currently polls the server every two seconds.</p>
        <p>
          This was a practical way to explore communication between two interfaces and a backend without introducing a real
          payment processor.
        </p>
      </>
    ),
    tags: ['Dart Shelf', 'HTTP API', 'QR codes', 'Payment-state polling'],
  },
  {
    n: 'D',
    title: 'Merchant and reporting interfaces',
    body: (
      <p>
        The administration side includes reusable configuration screens, menu management, chart-based reporting and export
        functions.
      </p>
    ),
    tags: ['go_router', 'fl_chart', 'CSV/PDF export'],
  },
];

function EngineeringViz({ id }: { id: number }) {
  if (id === 0) {
    return (
      <VizShell n="A" title="Application state" path="lib/presentation/providers/cart_provider.dart">
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
  if (id === 1) {
    return (
      <VizShell n="B" title="Data access" path="lib/data · lib/features/payouts/data">
        <ul className="tree">
          <li>
            <b>Screens</b>
            <small>read data through interfaces</small>
          </li>
          <li>
            <code>ApiDataSource</code> <small>interface</small>
            <ul>
              <li>
                <code>MockApiDataSource</code> <Badge tone="working">in use</Badge>
              </li>
            </ul>
          </li>
          <li>
            <code>SalesRepository</code> <small>interface</small>
            <ul>
              <li>
                <code>MockSalesRepository</code> <Badge tone="working">in use</Badge>
              </li>
              <li>
                <code>MongoSalesRepository</code> <Badge tone="todo">stub, not connected</Badge>
              </li>
            </ul>
          </li>
          <li>
            <code>MockPayoutsRepository</code> <Badge tone="working">in use</Badge>
          </li>
        </ul>
      </VizShell>
    );
  }
  if (id === 2) {
    const rows: [string, string, string][] = [
      ['Kiosk', 'POST /api/orders', 'Sends the order and shows a QR code'],
      ['Phone', 'POST /api/payments/process', 'Customer taps pay on the checkout page (simulated)'],
      ['Server', 'session → paid', 'Marks the payment session as paid'],
      ['Kiosk', 'GET /api/payment-sessions/:id', 'Asks every 2 seconds, then shows “Payment received”'],
    ];
    return (
      <VizShell n="C" title="Simulated payment flow" path="lib/server/payment_server.dart · web/checkout.html">
        <ol className="flow">
          {rows.map(([who, call, what], i) => (
            <li key={call} style={{ animationDelay: `${i * 140}ms` }}>
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
    <VizShell n="D" title="Merchant and reporting interfaces" path="go_router · fl_chart · CSV/PDF export">
      <div className="shots">
        <ScreenImage className="main" name="07-analytics" alt="Sales analytics dashboard" />
        <ScreenImage name="03-template-gallery" alt="Menu template gallery" />
        <ScreenImage name="09-branding-typography" alt="Branding editor with typography selection" />
      </div>
    </VizShell>
  );
}

export function Engineering({ inline }: { inline: boolean }) {
  return (
    <Walkthrough
      id="engineering"
      eyebrow="04 / Engineering"
      title="How I built the kiosk."
      lede={
        <p className="lede">
          The project uses Flutter and Dart, with separate application layers for user interfaces, state management and data
          access.
        </p>
      }
      steps={ENGINEERING_STEPS}
      inline={inline}
      viz={(i) => <EngineeringViz id={i} />}
    />
  );
}

/* ------------------------------------------------------------ Decisions */

const DECISIONS: [string, string][] = [
  [
    'Separating state from presentation',
    'Cart calculations and shared application state belong outside UI widgets. Riverpod helped organise that logic while allowing multiple screens to read consistent values.',
  ],
  [
    'Building around replaceable data sources',
    'Using interfaces and sample implementations allowed me to develop the ordering and merchant experiences before committing to a database or external service.',
  ],
  [
    'Simulating the complete checkout interaction',
    'Instead of showing a success screen immediately after clicking Pay, I introduced a separate server and checkout page. This helped explore request handling, payment-session status and communication between devices.',
  ],
  [
    'Choosing polling for the prototype',
    'Polling every two seconds kept the demonstration simple. A production payment integration would require a more robust confirmation mechanism, authentication, secure event handling and reconciliation.',
  ],
];

export function Decisions() {
  return (
    <section id="decisions" className="section decisions" aria-labelledby="decisions-title">
      <div className="wrap right">
        <div className="dec-col">
          <div className="panel" data-reveal>
            <p className="eyebrow">05 / Engineering decisions</p>
            <h2 id="decisions-title">Some decisions mattered more than the screens.</h2>
          </div>
          <ol className="dec-list">
            {DECISIONS.map(([t, d], i) => (
              <li className="card dec" key={t} data-reveal>
                <span className="num">{String(i + 1).padStart(2, '0')}</span>
                <div>
                  <h3>{t}</h3>
                  <p>{d}</p>
                </div>
              </li>
            ))}
          </ol>
          <p className="panel callout" data-reveal>
            These decisions are also areas I would revisit as the project moves beyond the prototype stage.
          </p>
        </div>
      </div>
    </section>
  );
}

/* -------------------------------------------------------- Current state */

const WORKS: [Tone, string, string][] = [
  ['working', 'Working', 'Customer ordering, item customisation and cart calculations.'],
  ['sample', 'Sample data', 'Configurable branding and menu administration interfaces.'],
  ['simulated', 'Simulated', 'Pay-at-counter and QR checkout interactions.'],
  ['simulated', 'Simulated', 'A lightweight server for mock payment-session updates.'],
  ['sample', 'Sample data', 'Dashboards and export functionality.'],
  ['working', 'Working', 'Automated unit tests for payout money calculations and CSV export.'],
];

const NOT_YET = [
  'Real card or bank payments.',
  'Persistent merchant and order data.',
  'Authentication and secure payment-event verification.',
  'Live kitchen, reporting and payout integrations.',
  'Verified native iPad deployment.',
];

export function State() {
  return (
    <section id="state" className="section state" aria-labelledby="state-title">
      <div className="wrap">
        <div className="panel head" data-reveal>
          <p className="eyebrow">06 / Current state</p>
          <h2 id="state-title">What works. What comes next.</h2>
        </div>
        <div className="state-grid">
          <article className="card state-card done" data-reveal>
            <h3>Implemented and demonstrated</h3>
            <ul>
              {WORKS.map(([tone, label, text]) => (
                <li key={text}>
                  <Badge tone={tone}>{label}</Badge>
                  <span>{text}</span>
                </li>
              ))}
            </ul>
          </article>
          <article className="card state-card todo" data-reveal style={{ transitionDelay: '100ms' }}>
            <h3>Not yet production-ready</h3>
            <ul>
              {NOT_YET.map((t) => (
                <li key={t}>
                  <Badge tone="todo">Not yet</Badge>
                  <span>{t}</span>
                </li>
              ))}
            </ul>
          </article>
        </div>
        <div className="panel state-foot" data-reveal>
          <p>
            The main customer workflows have been manually exercised in Chrome. Automated test coverage is still limited, and
            extending it to cart behaviour, checkout states and server interactions is an important next step.
          </p>
          <p className="fine">
            The intention of this project is to demonstrate application design and implementation, not to present an active
            commercial payment product.
          </p>
        </div>
      </div>
    </section>
  );
}

/* ---------------------------------------------------------------- About */

function ContactCard() {
  const [copied, setCopied] = useState(false);

  const copy = async () => {
    try {
      await navigator.clipboard.writeText(site.email);
    } catch {
      const field = document.createElement('textarea');
      field.value = site.email;
      field.setAttribute('readonly', '');
      field.style.position = 'fixed';
      field.style.opacity = '0';
      document.body.appendChild(field);
      field.select();
      document.execCommand('copy');
      field.remove();
    }
    setCopied(true);
    window.setTimeout(() => setCopied(false), 2200);
  };

  return (
    <div className="contact" data-reveal>
      <span className="contact-icon" aria-hidden="true">
        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
          <rect x="3" y="5" width="18" height="14" rx="2.5" />
          <path d="m4 7 8 6 8-6" />
        </svg>
      </span>
      <div className="contact-body">
        <span className="contact-label">Email</span>
        <a className="contact-mail" href={`mailto:${site.email}`}>
          {site.email}
          <Arrow />
        </a>
        <p className="contact-note">The fastest way to reach me — roles, internships or kiosk work.</p>
      </div>
      <button type="button" className={copied ? 'copy done' : 'copy'} onClick={copy}>
        {copied ? 'Copied' : 'Copy'}
      </button>
      <span className="sr-only" role="status" aria-live="polite">
        {copied ? 'Email address copied' : ''}
      </span>
    </div>
  );
}

export function About() {
  return (
    <section id="about" className="section about" aria-labelledby="about-title">
      <div className="wrap about-grid">
        <div className="panel" data-reveal>
          <p className="eyebrow">07 / About the developer</p>
          <h2 id="about-title">Hi, I’m {site.firstName}.</h2>
          <p className="prose">
            I’m a Bachelor of Cyber Security student at Griffith University in Brisbane, Australia, working towards a career
            in software engineering.
          </p>
          <p className="prose">
            I’m interested in the practical side of building software: taking a problem, designing a useful interface,
            connecting the underlying logic and understanding what it would take to make the system more reliable.
          </p>
          <p className="prose">
            I build Flutter applications and interactive kiosk experiences—from customer-facing ordering screens to the
            merchant tools and reporting behind them.
          </p>
          <p className="prose">
            This kiosk started as an exploration of self-service technology for local businesses. As it developed, I became
            increasingly interested in the engineering behind it—application state, reusable components, backend
            communication and the decisions that separate a working prototype from production software.
          </p>
          <p className="prose">
            I’m currently looking for junior software engineering opportunities and internships in Brisbane or remote,
            particularly in application development, fintech and cloud-connected software.
          </p>
          <ContactCard />
          <ul className="tags" aria-label="Core technologies">
            {['Flutter', 'Dart', 'React', 'TypeScript', 'Riverpod', 'Three.js', 'Git'].map((t) => (
              <li key={t}>{t}</li>
            ))}
          </ul>
          <div className="cta">
            <a className="btn primary" href={site.githubProfile} target="_blank" rel="noreferrer">
              View my GitHub <Arrow />
            </a>
            <a className="btn" href={site.linkedinProfile} target="_blank" rel="noreferrer">
              Connect on LinkedIn <Arrow />
            </a>
            <a className="btn" href={site.github} target="_blank" rel="noreferrer">
              Kiosk source <Arrow />
            </a>
          </div>
          <a className="link" href={site.linkedinPost} target="_blank" rel="noreferrer">
            I wrote about the project on LinkedIn <Arrow />
          </a>
        </div>
        <figure className="portrait" data-reveal>
          <div className="portrait-frame">
            <img
              src={`${import.meta.env.BASE_URL}media/mahdi.jpg`}
              alt={`Portrait of ${site.name}, seated, in front of a glass display cabinet`}
              width={800}
              height={1000}
              loading="lazy"
              decoding="async"
            />
            <span className="portrait-shade" aria-hidden="true" />
            <figcaption>
              <strong>{site.name}</strong>
              <span>Bachelor of Cyber Security · Griffith University</span>
              <span>Brisbane, Australia</span>
            </figcaption>
          </div>
          <p className="portrait-status">
            <i aria-hidden="true" />
            Open to junior software engineering roles and internships
          </p>
        </figure>
      </div>
    </section>
  );
}

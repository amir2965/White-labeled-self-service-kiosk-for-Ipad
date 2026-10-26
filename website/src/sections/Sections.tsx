import { useEffect, useRef, useState, type ReactNode } from 'react';
import FlutterDemo, { FLOWS, type FlowId } from '../kiosk/FlutterDemo';
import { MILKS, PRODUCTS, SIZES, money, serviceFee } from '../kiosk/data';
import { site } from '../site.config';

const Arrow = () => <span aria-hidden="true">↗</span>;
const shot = (name: string) => `${import.meta.env.BASE_URL}screens/${name}.png`;
const inertIf = (on: boolean) => (on ? { inert: '' } : {});

type Tone = 'working' | 'sample' | 'simulated' | 'todo';
const Badge = ({ tone, children }: { tone: Tone; children: ReactNode }) => <em className={`badge ${tone}`}>{children}</em>;

/* ------------------------------------------------------------------ Hero */

export function Hero({ fallback }: { fallback: boolean }) {
  return (
    <section id="hero" className="section hero" aria-labelledby="hero-title">
      {fallback && <img className="hero-static" src={shot('12-kiosk-welcome')} alt="The kiosk welcome screen on an iPad" />}
      <div className="wrap">
        <p className="eyebrow" data-reveal>Independent software project · Flutter / Dart</p>
        <h1 id="hero-title" data-reveal>
          One kiosk.<br />Different<br /><em>businesses.</em>
        </h1>
        <p className="lede" data-reveal>
          A configurable self-service ordering experience built with Flutter. I designed and developed it to explore how a
          single tablet application could support different restaurants and cafés without a completely different interface
          for each business.
        </p>
        <p className="lede sub" data-reveal>
          It brings together a customer ordering experience, merchant configuration tools and a simulated QR payment workflow.
        </p>
        <div className="cta" data-reveal>
          <a className="btn primary" href="#demo">Explore the interactive demo</a>
          <a className="btn" href={site.github} target="_blank" rel="noreferrer">
            View source code <Arrow />
          </a>
        </div>
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
          <img className="solo" src={shot('12-kiosk-welcome')} alt="Kiosk start screen: outdoor restaurant terrace background, café logo, title and Start order button" />
        </VizShell>
      );
    }
    if (i === 1) {
      return (
        <VizShell n="02" title="Explore the menu" path="Screenshot · Flutter app, landscape tablet">
          <img className="solo" src={shot('13-kiosk-menu')} alt="Kiosk menu screen with category rail and product cards" />
        </VizShell>
      );
    }
    if (i === 2) {
      return (
        <VizShell n="03" title="Make it yours" path="Try it · the same size and milk options as the demo">
          <div className="opt-item">
            <img src={LATTE.img} alt="" />
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
      title="Ordering should feel straightforward."
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
  onFlow: (f: FlowId) => void;
  onRestart: () => void;
  inline: boolean;
}

export function Demo({ flow, nonce, onFlow, onRestart, inline }: DemoProps) {
  const cur = FLOWS.find((f) => f.id === flow)!;
  return (
    <section id="demo" className="section demo" aria-labelledby="demo-title">
      <div className="demo-sticky">
        <div className="demo-panel">
          <p className="eyebrow">02 / Interactive demo</p>
          <h2 id="demo-title">Give it a try.</h2>
          <p className="lede">
            This is the Flutter app itself, built for the web. Pick an experience to explore
            {inline ? ' (best in landscape or on a bigger screen).' : ', then use it inside the 3D iPad.'}
          </p>
          <div className="flows" role="group" aria-label="Choose an experience">
            {FLOWS.map((f, i) => (
              <button
                type="button"
                key={f.id}
                className={`flow${f.id === flow ? ' on' : ''}`}
                aria-pressed={f.id === flow}
                onClick={() => onFlow(f.id)}
              >
                <span className="n">{i + 1}</span>
                <span className="t">
                  <strong>{f.title}</strong>
                  <small>{f.blurb}</small>
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
              <FlutterDemo flow={flow} nonce={nonce} />
            </ScaledStage>
          </div>
        )}
        {!inline && (
          <p className="demo-badge" aria-hidden="true">
            <i />Real Flutter app · sample data · payment simulated
          </p>
        )}
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
                  <img key={name} className={MERCHANT_SHOTS[i].length === 1 ? 'main' : ''} src={shot(name)} alt={alt} />
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
        <img className="main" src={shot('07-analytics')} alt="Sales analytics dashboard" />
        <img src={shot('03-template-gallery')} alt="Menu template gallery" />
        <img src={shot('09-branding-typography')} alt="Branding editor with typography selection" />
      </div>
    </VizShell>
  );
}

export function Engineering({ inline }: { inline: boolean }) {
  return (
    <Walkthrough
      id="engineering"
      eyebrow="04 / Engineering"
      title="How I built it."
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

export function About() {
  return (
    <section id="about" className="section about" aria-labelledby="about-title">
      <div className="wrap">
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
            This kiosk started as an exploration of self-service technology for local businesses. As it developed, I became
            increasingly interested in the engineering behind it—application state, reusable components, backend
            communication and the decisions that separate a working prototype from production software.
          </p>
          <p className="prose">
            I’m currently looking for junior software engineering opportunities and internships, particularly in application
            development, fintech and cloud-connected software.
          </p>
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
            {site.email && (
              <a className="btn" href={`mailto:${site.email}`}>
                Email
              </a>
            )}
          </div>
          <a className="link" href={site.linkedinPost} target="_blank" rel="noreferrer">
            I wrote about the project on LinkedIn <Arrow />
          </a>
        </div>
      </div>
    </section>
  );
}

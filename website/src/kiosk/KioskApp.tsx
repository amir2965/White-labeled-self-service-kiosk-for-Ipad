import { useEffect, useMemo, useState } from 'react';
import qrcode from 'qrcode-generator';
import {
  CATEGORIES,
  MILKS,
  PRODUCTS,
  SIZES,
  FEE_FIXED,
  FEE_PERCENT,
  money,
  serviceFee,
  type CategoryId,
  type Product,
} from './data';

type Screen = 'welcome' | 'mode' | 'menu' | 'checkout' | 'qr' | 'done';
export type KioskStep = Screen | 'customize';

interface Line {
  key: string;
  product: Product;
  size?: string;
  milk?: string;
  qty: number;
  unit: number;
}

interface Draft {
  product: Product;
  size: string;
  milk: string;
  qty: number;
}

const QR_SECONDS = 300;
const RESET_SECONDS = 12;

const unitPrice = (p: Product, size?: string, milk?: string) =>
  p.price + (SIZES.find((s) => s.id === size)?.add ?? 0) + (MILKS.find((m) => m.id === milk)?.add ?? 0);

function QrSvg({ value }: { value: string }) {
  const svg = useMemo(() => {
    const qr = qrcode(0, 'M');
    qr.addData(value);
    qr.make();
    return qr.createSvgTag({ cellSize: 4, margin: 0, scalable: true });
  }, [value]);
  return <div className="k-qr" role="img" aria-label="Demo QR code" dangerouslySetInnerHTML={{ __html: svg }} />;
}

export default function KioskApp({ onStep }: { onStep?: (step: KioskStep) => void }) {
  const [screen, setScreen] = useState<Screen>('welcome');
  const [mode, setMode] = useState<'Dine in' | 'Takeaway'>('Dine in');
  const [cat, setCat] = useState<CategoryId>('coffee');
  const [draft, setDraft] = useState<Draft | null>(null);
  const [cart, setCart] = useState<Line[]>([]);
  const [method, setMethod] = useState<'qr' | 'counter'>('qr');
  const [paying, setPaying] = useState(false);
  const [orderNo, setOrderNo] = useState(1042);
  const [qrLeft, setQrLeft] = useState(QR_SECONDS);
  const [resetLeft, setResetLeft] = useState(RESET_SECONDS);

  useEffect(() => onStep?.(draft ? 'customize' : screen), [draft, screen, onStep]);

  useEffect(() => {
    if (screen !== 'qr') return;
    setQrLeft(QR_SECONDS);
    const id = setInterval(() => setQrLeft((s) => Math.max(0, s - 1)), 1000);
    return () => clearInterval(id);
  }, [screen]);

  useEffect(() => {
    if (screen !== 'done') return;
    setResetLeft(RESET_SECONDS);
    const id = setInterval(() => setResetLeft((s) => s - 1), 1000);
    return () => clearInterval(id);
  }, [screen]);

  useEffect(() => {
    if (screen === 'done' && resetLeft <= 0) reset();
  }, [screen, resetLeft]);

  const subtotal = cart.reduce((s, l) => s + l.unit * l.qty, 0);
  const fee = serviceFee(subtotal);
  const total = subtotal + fee;
  const count = cart.reduce((s, l) => s + l.qty, 0);

  function reset() {
    setCart([]);
    setDraft(null);
    setPaying(false);
    setScreen('welcome');
  }

  function openProduct(p: Product) {
    setDraft({ product: p, size: 'M', milk: 'whole', qty: 1 });
  }

  function addDraft() {
    if (!draft) return;
    const { product, qty } = draft;
    const size = product.sizes ? draft.size : undefined;
    const milk = product.milk ? draft.milk : undefined;
    const key = [product.id, size, milk].join('|');
    const unit = unitPrice(product, size, milk);
    setCart((c) => {
      const found = c.find((l) => l.key === key);
      return found
        ? c.map((l) => (l.key === key ? { ...l, qty: l.qty + qty } : l))
        : [...c, { key, product, size, milk, qty, unit }];
    });
    setDraft(null);
  }

  function changeQty(key: string, delta: number) {
    setCart((c) => c.map((l) => (l.key === key ? { ...l, qty: l.qty + delta } : l)).filter((l) => l.qty > 0));
  }

  function pay(m: 'qr' | 'counter') {
    setMethod(m);
    setOrderNo((n) => n + 1);
    setScreen(m === 'counter' ? 'done' : 'qr');
  }

  function simulatePhonePayment() {
    setPaying(true);
    setTimeout(() => {
      setPaying(false);
      setScreen('done');
    }, 1400);
  }

  const fmt = (s: number) => `${String(Math.floor(s / 60)).padStart(2, '0')}:${String(s % 60).padStart(2, '0')}`;
  const visible = PRODUCTS.filter((p) => p.cat === cat);

  return (
    <div className="kiosk" data-screen={screen}>
      {screen === 'welcome' && (
        <div className="k-welcome" style={{ backgroundImage: `url(${PRODUCTS[0].img})` }}>
          <div className="k-welcome-inner">
            <p className="k-eyebrow">Demo Café</p>
            <h3>Fresh coffee,<br />no queue.</h3>
            <button className="k-btn k-btn-light k-btn-xl" onClick={() => setScreen('mode')}>
              Start order
            </button>
          </div>
        </div>
      )}

      {screen === 'mode' && (
        <div className="k-center">
          <h3 className="k-title">How would you like your order?</h3>
          <div className="k-row">
            {(['Dine in', 'Takeaway'] as const).map((m) => (
              <button
                key={m}
                className="k-mode"
                onClick={() => {
                  setMode(m);
                  setScreen('menu');
                }}
              >
                <span className="k-mode-icon" aria-hidden="true">{m === 'Dine in' ? '🍽' : '🛍'}</span>
                {m}
              </button>
            ))}
          </div>
        </div>
      )}

      {(screen === 'menu' || screen === 'checkout') && (
        <header className="k-header">
          <div className="k-brand">
            <span className="k-logo" aria-hidden="true">☕</span>
            <strong>{screen === 'menu' ? 'Menu' : 'Checkout'}</strong>
            <span className="k-pill">{mode}</span>
          </div>
          {screen === 'menu' ? (
            <button className="k-btn k-btn-blue" onClick={() => setScreen('checkout')}>
              Cart{count > 0 && ` · ${count} · ${money(total)}`}
            </button>
          ) : (
            <button className="k-btn k-btn-ghost" onClick={() => setScreen('menu')}>
              ← Back to menu
            </button>
          )}
        </header>
      )}

      {screen === 'menu' && (
        <div className="k-menu">
          <nav className="k-rail" aria-label="Categories">
            {CATEGORIES.map((c) => (
              <button key={c.id} className={c.id === cat ? 'on' : ''} onClick={() => setCat(c.id)}>
                {c.label}
              </button>
            ))}
          </nav>
          <div className="k-grid">
            {visible.map((p) => (
              <button key={p.id} className="k-card" onClick={() => openProduct(p)}>
                <img src={p.img} alt="" loading="lazy" draggable={false} />
                <span className="k-card-name">{p.name}</span>
                <span className="k-card-desc">{p.desc}</span>
                <span className="k-card-price">{money(p.price)}</span>
              </button>
            ))}
          </div>
        </div>
      )}

      {screen === 'checkout' && (
        <div className="k-checkout">
          <section className="k-lines" aria-label="Order summary">
            {cart.length === 0 && <p className="k-empty">Your cart is empty. Go back and add something.</p>}
            {cart.map((l) => (
              <div className="k-line" key={l.key}>
                <img src={l.product.img} alt="" draggable={false} />
                <div className="k-line-text">
                  <strong>{l.product.name}</strong>
                  <span>
                    {[
                      SIZES.find((s) => s.id === l.size)?.label,
                      l.milk && l.milk !== 'whole' ? MILKS.find((m) => m.id === l.milk)?.label : undefined,
                    ]
                      .filter(Boolean)
                      .join(' · ') || 'Standard'}
                  </span>
                </div>
                <div className="k-stepper">
                  <button aria-label={`Remove one ${l.product.name}`} onClick={() => changeQty(l.key, -1)}>−</button>
                  <span>{l.qty}</span>
                  <button aria-label={`Add one ${l.product.name}`} onClick={() => changeQty(l.key, 1)}>+</button>
                </div>
                <strong className="k-line-price">{money(l.unit * l.qty)}</strong>
              </div>
            ))}
          </section>
          <aside className="k-summary">
            <dl>
              <div><dt>Subtotal</dt><dd>{money(subtotal)}</dd></div>
              <div><dt>Service fee <small>{FEE_PERCENT}% + ${FEE_FIXED.toFixed(2)}</small></dt><dd>{money(fee)}</dd></div>
              <div className="k-total"><dt>Total</dt><dd>{money(total)}</dd></div>
            </dl>
            <button className="k-btn k-btn-blue k-btn-block" disabled={!cart.length} onClick={() => pay('qr')}>
              Scan QR to pay
            </button>
            <button className="k-btn k-btn-outline k-btn-block" disabled={!cart.length} onClick={() => pay('counter')}>
              Pay at counter
            </button>
          </aside>
        </div>
      )}

      {screen === 'qr' && (
        <div className="k-pay">
          <div className="k-pay-left">
            <h3 className="k-title">Scan to pay</h3>
            <p className="k-sub">Use your phone camera</p>
            <QrSvg value={`DEMO-ORDER-${orderNo}`} />
            <p className="k-sub">Time remaining {fmt(qrLeft)}</p>
            <button className="k-btn k-btn-ghost" onClick={() => setScreen('checkout')} disabled={paying}>
              Cancel
            </button>
          </div>
          <div className="k-pay-right">
            <p className="k-sub">Total amount</p>
            <p className="k-big">{money(total)}</p>
            <p className="k-wait"><i /> Waiting for payment</p>
            <div className="k-sim">
              <p className="k-sim-tag">Simulation</p>
              <p>No phone, no card, no money. This button stands in for the customer's phone.</p>
              <button className="k-btn k-btn-dark k-btn-block" onClick={simulatePhonePayment} disabled={paying}>
                {paying ? 'Processing…' : `Pay ${money(total)} on phone`}
              </button>
            </div>
          </div>
        </div>
      )}

      {screen === 'done' && (
        <div className="k-center k-done" role="status">
          <div className="k-check" aria-hidden="true">✓</div>
          <h3 className="k-title">{method === 'qr' ? 'Payment received' : 'Order received'}</h3>
          <p className="k-order">Order #{orderNo}</p>
          <p className="k-sub">
            {method === 'qr' ? 'Thanks! Your order is on its way to the kitchen.' : 'Please pay at the counter.'} · {money(total)}
          </p>
          <button className="k-btn k-btn-blue" onClick={reset}>New order</button>
          <p className="k-sub k-tiny">Returning to start in {Math.max(resetLeft, 0)}s</p>
        </div>
      )}

      {draft && (
        <div className="k-modal" role="dialog" aria-modal="true" aria-label={`Customise ${draft.product.name}`}>
          <div className="k-sheet">
            <img src={draft.product.img} alt="" draggable={false} />
            <div className="k-sheet-body">
              <div className="k-sheet-head">
                <div>
                  <h3>{draft.product.name}</h3>
                  <p className="k-sub">{draft.product.desc}</p>
                </div>
                <button className="k-x" aria-label="Close" onClick={() => setDraft(null)}>×</button>
              </div>
              {draft.product.sizes && (
                <fieldset>
                  <legend>Size <em>required</em></legend>
                  <div className="k-chips">
                    {SIZES.map((s) => (
                      <button key={s.id} className={draft.size === s.id ? 'on' : ''} onClick={() => setDraft({ ...draft, size: s.id })}>
                        {s.label}{s.add > 0 && <small> +{money(s.add)}</small>}
                      </button>
                    ))}
                  </div>
                </fieldset>
              )}
              {draft.product.milk && (
                <fieldset>
                  <legend>Milk</legend>
                  <div className="k-chips">
                    {MILKS.map((m) => (
                      <button key={m.id} className={draft.milk === m.id ? 'on' : ''} onClick={() => setDraft({ ...draft, milk: m.id })}>
                        {m.label}{m.add > 0 && <small> +{money(m.add)}</small>}
                      </button>
                    ))}
                  </div>
                </fieldset>
              )}
              <div className="k-sheet-foot">
                <div className="k-stepper">
                  <button aria-label="Fewer" onClick={() => setDraft({ ...draft, qty: Math.max(1, draft.qty - 1) })}>−</button>
                  <span>{draft.qty}</span>
                  <button aria-label="More" onClick={() => setDraft({ ...draft, qty: draft.qty + 1 })}>+</button>
                </div>
                <button className="k-btn k-btn-blue k-btn-grow" onClick={addDraft}>
                  Add to cart · {money(unitPrice(draft.product, draft.product.sizes ? draft.size : undefined, draft.product.milk ? draft.milk : undefined) * draft.qty)}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

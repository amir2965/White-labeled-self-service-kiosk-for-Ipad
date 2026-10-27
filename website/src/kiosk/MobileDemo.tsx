import { useRef, useState } from 'react';
import FlutterDemo, { FLOWS, type FlowId } from './FlutterDemo';
import { useModal } from '../hooks';

const previews: Record<FlowId, string> = {
  order: '12-kiosk-welcome', scan: '13-kiosk-menu', templates: '03-template-gallery',
  customize: '09-branding-typography', analytics: '07-analytics',
};

export default function MobileDemo({ flow, nonce, onFlow, onRestart }: {
  flow: FlowId; nonce: number; onFlow: (flow: FlowId) => void; onRestart: () => void;
}) {
  const [open, setOpen] = useState(false);
  const dialog = useRef<HTMLDialogElement>(null);
  const current = FLOWS.find((f) => f.id === flow)!;
  useModal(dialog, open, () => setOpen(false));
  return (
    <section id="demo" className="section mobile-demo" aria-labelledby="demo-title">
      <div className="wrap">
        <p className="eyebrow">02 / Interactive demo</p>
        <h2 id="demo-title">Give it a try.</h2>
        <p className="lede">The real Flutter app, ready to explore. Choose an experience and open it in a full-screen workspace.</p>
        <div className="demo-launcher">
          <label htmlFor="experience">Choose your experience <span>5 ways to explore</span></label>
          <select id="experience" value={flow} onChange={(e) => onFlow(e.target.value as FlowId)}>
            {FLOWS.map((f) => <option key={f.id} value={f.id}>{f.title}</option>)}
          </select>
          <div className="demo-preview"><img src={`${import.meta.env.BASE_URL}screens/${previews[flow]}-640.webp`} alt={`Preview of ${current.title}`} width={1024} height={712} loading="lazy" decoding="async" /><span className={`badge ${current.tone}`}>{current.tag}</span></div>
          <div className="demo-launch-copy" aria-live="polite">
            <h3>{current.title}</h3><p>{current.blurb}</p>
            <ol className="mobile-try" aria-label="Things to try">{current.tryIt.map((s) => <li key={s}>{s}</li>)}</ol>
          </div>
          <button type="button" className="btn primary launch-demo" onClick={() => setOpen(true)}>Launch experience <span aria-hidden="true">↗</span></button>
          <p className="launch-note">{flow === 'order' ? 'Loads only when you launch. Nothing is charged.' : 'Original tablet workspace. Swipe to explore; landscape gives you more room.'}</p>
        </div>
        <p className="note"><b>Demo note:</b> all products, prices and sales figures are sample data. Payment and menu scanning are simulated; no real payment takes place.</p>
      </div>
      <dialog ref={dialog} className="demo-workspace" aria-labelledby="workspace-title">
        <div className="workspace-shell">
          <header className="workspace-toolbar">
            <button type="button" autoFocus onClick={() => setOpen(false)}>← Back</button>
            <strong id="workspace-title">{current.title}</strong>
            <button type="button" onClick={onRestart}>Restart</button>
          </header>
          <p className="workspace-note">{flow === 'order' ? 'Live ordering demo · all payments simulated' : 'Tablet workspace · swipe sideways to explore · rotate for more room'}</p>
          <div className="workspace-app">
            {open && <FlutterDemo flow={flow} nonce={nonce} engaged releaseOnPointerLeave={false} onEngage={(engage) => { if (!engage) setOpen(false); }} />}
          </div>
        </div>
      </dialog>
    </section>
  );
}

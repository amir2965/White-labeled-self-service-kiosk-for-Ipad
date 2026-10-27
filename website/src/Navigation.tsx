import { useEffect, useRef, useState } from 'react';
import { site } from './site.config';
import { useModal } from './hooks';

const links = [
  ['product', 'Product'], ['demo', 'Demo'], ['merchant', 'Merchant'],
  ['engineering', 'Engineering'], ['state', 'Current state'], ['about', 'About'],
];

export default function Navigation({ compact }: { compact: boolean }) {
  const [open, setOpen] = useState(false);
  const dialog = useRef<HTMLDialogElement>(null);
  useModal(dialog, open, () => setOpen(false));
  useEffect(() => { if (!compact) setOpen(false); }, [compact]);

  return (
    <header className={`nav${compact ? ' nav-compact' : ''}`}>
      <a className="mark" href="#hero" aria-label="Self-Service Kiosk, back to top"><i aria-hidden="true" />Self-Service Kiosk</a>
      {!compact ? (
        <nav aria-label="Primary">
          {links.map(([id, label]) => <a key={id} href={`#${id}`}>{label}</a>)}
          <a href={site.github} target="_blank" rel="noreferrer">GitHub ↗</a>
        </nav>
      ) : (
        <>
          <button className="menu-toggle" type="button" aria-expanded={open} aria-controls="mobile-menu" onClick={() => setOpen(true)}>
            Menu <span aria-hidden="true">☰</span>
          </button>
          <dialog id="mobile-menu" ref={dialog} className="mobile-menu" aria-labelledby="menu-title" onClick={(e) => { if (e.target === e.currentTarget) setOpen(false); }}>
            <div className="menu-sheet">
              <div className="menu-heading"><p id="menu-title">Explore the project</p><button type="button" autoFocus onClick={() => setOpen(false)} aria-label="Close menu">✕</button></div>
              <nav aria-label="Primary">
                {links.map(([id, label], i) => <a key={id} href={`#${id}`} onClick={() => setOpen(false)}><span className="menu-number">0{i + 1}</span>{label}<span aria-hidden="true">↗</span></a>)}
              </nav>
              <a className="menu-source" href={site.github} target="_blank" rel="noreferrer" onClick={() => setOpen(false)}>View source on GitHub <span aria-hidden="true">↗</span></a>
              <p className="menu-caption">Independent project. Thoughtfully engineered.</p>
            </div>
          </dialog>
        </>
      )}
    </header>
  );
}

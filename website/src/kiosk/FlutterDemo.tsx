import { useEffect, useRef, useState } from 'react';

export type FlowId = 'order' | 'scan' | 'templates' | 'customize' | 'analytics';

export interface Flow {
  id: FlowId;
  title: string;
  blurb: string;
  tryIt: string[];
  route: string; // route inside the Flutter app (hash)
  tag: string;
  tone: 'sample' | 'simulated' | 'working';
}

export const FLOWS: Flow[] = [
  {
    id: 'order',
    title: 'Ordering experience',
    blurb: 'The customer journey from the start screen to payment.',
    tryIt: ['Start Order', 'Dine in', 'Pick a drink', 'Cart', 'Pay'],
    route: '/demo/order',
    tag: 'Payment simulated',
    tone: 'simulated',
  },
  {
    id: 'scan',
    title: 'Menu scan (OCR)',
    blurb: 'Turn a photo of a paper menu into products.',
    tryIt: ['Watch the scan', 'Import items', 'Open in kiosk'],
    route: '/demo/scan',
    tag: 'Extraction simulated',
    tone: 'simulated',
  },
  {
    id: 'templates',
    title: 'Menu templates',
    blurb: 'The layouts a business can choose from, with sample products.',
    tryIt: ['Tap a layout', 'Tap again to preview', 'Scroll the list'],
    route: '/demo/templates',
    tag: 'Real app screens',
    tone: 'working',
  },
  {
    id: 'customize',
    title: 'Branding and customisation',
    blurb: 'Edit the welcome page: layout, fonts, colours and button style.',
    tryIt: ['Pick a layout', 'Change typography', 'Open Preview'],
    route: '/branding',
    tag: 'Real app screens',
    tone: 'working',
  },
  {
    id: 'analytics',
    title: 'Analytics dashboard',
    blurb: 'Sales charts, time ranges and breakdowns for the merchant.',
    tryIt: ['Switch time range', 'Hover the charts', 'Open GST or Service fees'],
    route: '/analytics',
    tag: 'Sample data',
    tone: 'sample',
  },
];

const appUrl = (flow: Flow, nonce: number) => `${import.meta.env.BASE_URL}app/index.html?v=${nonce}#${flow.route}`;

interface Props {
  flow: FlowId;
  nonce: number;
  engaged: boolean;
  onEngage: (on: boolean) => void;
}

/**
 * The real Flutter app (built for web) running one demo flow.
 * Until the visitor clicks it, the page scrolls normally over the device; after a click the app takes the
 * wheel and touch input, and Esc, the "Done" pill or leaving the device hands scrolling back.
 */
export default function FlutterDemo({ flow, nonce, engaged, onEngage }: Props) {
  const frame = useRef<HTMLIFrameElement>(null);
  const [armed, setArmed] = useState(false);
  const [ready, setReady] = useState(false);
  const [slow, setSlow] = useState(false);
  const cur = FLOWS.find((f) => f.id === flow)!;

  // The Flutter bundle is a few MB: only start loading when the visitor nears the demo.
  useEffect(() => {
    const el = document.getElementById('demo');
    if (!el || !('IntersectionObserver' in window)) return setArmed(true);
    const io = new IntersectionObserver(
      ([e]) => {
        if (e.isIntersecting) {
          setArmed(true);
          io.disconnect();
        }
      },
      { rootMargin: '120% 0px' },
    );
    io.observe(el);
    return () => io.disconnect();
  }, []);

  useEffect(() => { setReady(false); setSlow(false); }, [flow, nonce]);
  useEffect(() => {
    if (!armed || ready) return;
    const timer = window.setTimeout(() => setSlow(true), 20000);
    return () => window.clearTimeout(timer);
  }, [armed, ready, flow, nonce]);

  useEffect(() => {
    const on = (e: MessageEvent) => {
      if (e.source !== frame.current?.contentWindow || e.origin !== window.location.origin) return;
      if (e.data?.type === 'kiosk-demo-ready') setReady(true);
      if (e.data?.type === 'kiosk-demo-release') onEngage(false);
    };
    window.addEventListener('message', on);
    return () => window.removeEventListener('message', on);
  }, [onEngage]);

  useEffect(() => {
    if (engaged) frame.current?.focus();
  }, [engaged]);

  return (
    <div
      className={`flutter-demo${engaged ? ' engaged' : ''}`}
      onPointerLeave={(e) => e.pointerType === 'mouse' && engaged && onEngage(false)}
    >
      {armed && (
        <iframe
          ref={frame}
          key={`${flow}-${nonce}`}
          title={`Kiosk demo: ${cur.title}`}
          src={appUrl(cur, nonce)}
          style={{ pointerEvents: engaged ? 'auto' : 'none' }}
          tabIndex={engaged ? 0 : -1}
        />
      )}
      {ready && !engaged && (
        <button type="button" className="engage" onClick={() => onEngage(true)} aria-label="Click to use the demo">
          <span>
            <i aria-hidden="true" />
            Click to interact
          </span>
        </button>
      )}
      <div className={`flutter-loading${ready ? ' done' : ''}`} aria-hidden={ready}>
        <i />
        <span role="status">{slow ? 'The app is taking longer to load.' : 'Loading the Flutter app'}</span>
        {slow && <a href={appUrl(cur, nonce)} target="_blank" rel="noreferrer">Open the demo in a new tab ↗</a>}
      </div>
    </div>
  );
}

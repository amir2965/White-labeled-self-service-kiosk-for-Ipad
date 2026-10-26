import { useEffect, useRef, useState } from 'react';

export type FlowId = 'order' | 'scan' | 'templates' | 'customize' | 'analytics';

export interface Flow {
  id: FlowId;
  title: string;
  blurb: string;
  route: string; // route inside the Flutter app (hash)
  tag: string;
  tone: 'sample' | 'simulated' | 'working';
}

export const FLOWS: Flow[] = [
  {
    id: 'order',
    title: 'Ordering experience',
    blurb: 'Start screen, dine in or takeaway, menu, item options, cart and checkout. Finish with the QR payment screen.',
    route: '/demo/order',
    tag: 'Payment simulated',
    tone: 'simulated',
  },
  {
    id: 'scan',
    title: 'Menu scan (OCR)',
    blurb: 'Scan a sample paper menu and watch items, prices and size options appear, then import them and open them in the kiosk.',
    route: '/demo/scan',
    tag: 'Extraction simulated',
    tone: 'simulated',
  },
  {
    id: 'templates',
    title: 'Menu templates',
    blurb: 'Walk through the layouts the app ships with, preview one and select it. Your choice is used for the kiosk menu.',
    route: '/template-selector',
    tag: 'Real app screens',
    tone: 'working',
  },
  {
    id: 'customize',
    title: 'Branding and customisation',
    blurb: 'Edit the welcome page: name, tagline, logo, colours, fonts and button style, with a live preview.',
    route: '/branding',
    tag: 'Real app screens',
    tone: 'working',
  },
  {
    id: 'analytics',
    title: 'Analytics dashboard',
    blurb: 'Sales summary charts, time ranges and breakdowns for the merchant.',
    route: '/analytics',
    tag: 'Sample data',
    tone: 'sample',
  },
];

const appUrl = (flow: Flow, nonce: number) => `${import.meta.env.BASE_URL}app/index.html?v=${nonce}#${flow.route}`;

/** The real Flutter app (built for web) running one demo flow. Each flow starts from a clean app state. */
export default function FlutterDemo({ flow, nonce, onReady }: { flow: FlowId; nonce: number; onReady?: () => void }) {
  const frame = useRef<HTMLIFrameElement>(null);
  const [armed, setArmed] = useState(false);
  const [ready, setReady] = useState(false);
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

  useEffect(() => setReady(false), [flow, nonce]);

  useEffect(() => {
    const on = (e: MessageEvent) => {
      if (e.data?.type === 'kiosk-demo-ready' && e.source === frame.current?.contentWindow) {
        setReady(true);
        onReady?.();
      }
    };
    window.addEventListener('message', on);
    return () => window.removeEventListener('message', on);
  }, [onReady]);

  return (
    <div className="flutter-demo">
      {armed && <iframe ref={frame} key={`${flow}-${nonce}`} title={`Kiosk demo: ${cur.title}`} src={appUrl(cur, nonce)} />}
      <div className={`flutter-loading${ready ? ' done' : ''}`} aria-hidden={ready}>
        <i />
        <span>Loading the Flutter app</span>
      </div>
    </div>
  );
}

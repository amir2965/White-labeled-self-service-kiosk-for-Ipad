import { useEffect, useRef, useState } from 'react';
import { useMedia } from '../hooks';
import ScreenImage from '../ScreenImage';
import type { FlowId } from './FlutterDemo';

interface Frame {
  name: string;
  label: string;
  alt: string;
}

interface Chapter {
  id: FlowId;
  title: string;
  blurb: string;
  frames: Frame[];
}

const FRAME_MS = 3600;

const CHAPTERS: Chapter[] = [
  {
    id: 'order',
    title: 'Ordering experience',
    blurb: 'From the welcome screen to a scanned QR payment, the customer journey stays in one continuous flow.',
    frames: [
      {
        name: '12-kiosk-welcome',
        label: 'Start an order',
        alt: 'Demo Café kiosk welcome screen with the Start Order button',
      },
      {
        name: '14-kiosk-order-menu',
        label: 'Browse the menu',
        alt: 'Kiosk menu with category navigation and coffee product cards',
      },
      {
        name: '15-kiosk-checkout',
        label: 'Review the cart',
        alt: 'Checkout screen with the order summary, service fee and total',
      },
      {
        name: '16-kiosk-qr-payment',
        label: 'Scan to pay',
        alt: 'Simulated QR payment screen with a real QR code and demo note',
      },
    ],
  },
  {
    id: 'scan',
    title: 'Menu scan (OCR)',
    blurb: 'A photo of a paper menu is read, itemised and prepared for import — no manual typing.',
    frames: [
      {
        name: '17-kiosk-menu-scan',
        label: 'Photograph a menu',
        alt: 'Menu scan screen showing a sample paper menu with detected items and prices',
      },
      {
        name: '18-menu-management',
        label: 'Edit the imported items',
        alt: 'Merchant menu editor with imported products and an item editing panel',
      },
    ],
  },
  {
    id: 'templates',
    title: 'Menu templates',
    blurb: 'One menu, several layouts. A business can choose the presentation that suits its venue.',
    frames: [
      {
        name: '03-template-gallery',
        label: 'Choose a layout',
        alt: 'Menu template gallery with layout options and previews',
      },
      {
        name: '14-kiosk-order-menu',
        label: 'See the menu take shape',
        alt: 'The same menu rendered with a category sidebar and product cards',
      },
    ],
  },
  {
    id: 'customize',
    title: 'Branding and customisation',
    blurb: 'Typography, colour and welcome-screen layout are settings, not one-off designs.',
    frames: [
      {
        name: '09-branding-typography',
        label: 'Set the typography',
        alt: 'Branding editor with a typography selector and live font previews',
      },
      {
        name: '12-kiosk-welcome',
        label: 'The branded welcome screen',
        alt: 'A branded kiosk welcome screen using the selected identity',
      },
    ],
  },
  {
    id: 'analytics',
    title: 'Analytics dashboard',
    blurb: 'Sales figures and the busy kitchen queue behind them, shown in the same merchant workspace.',
    frames: [
      {
        name: '07-analytics',
        label: 'Review sales',
        alt: 'Sales analytics dashboard with revenue charts and date ranges',
      },
      {
        name: '06-kitchen-display',
        label: 'Follow the kitchen queue',
        alt: 'Kitchen display with active orders and their preparation states',
      },
    ],
  },
];

const chapterLabel = (n: number) => String(n).padStart(2, '0');

export default function MobileDemo() {
  const reduced = useMedia('(prefers-reduced-motion: reduce)');
  const [playing, setPlaying] = useState(() => !reduced);
  const [inView, setInView] = useState(false);
  const [chapter, setChapter] = useState(0);
  const [frame, setFrame] = useState(0);
  const ref = useRef<HTMLElement>(null);

  useEffect(() => {
    if (reduced) setPlaying(false);
  }, [reduced]);

  useEffect(() => {
    const el = ref.current;
    if (!el || !('IntersectionObserver' in window)) {
      setInView(true);
      return;
    }
    const io = new IntersectionObserver(([e]) => setInView(e.isIntersecting), { threshold: 0.25 });
    io.observe(el);
    return () => io.disconnect();
  }, []);

  useEffect(() => {
    if (!playing || !inView) return;
    const current = CHAPTERS[chapter];
    const timer = window.setTimeout(() => {
      if (frame + 1 < current.frames.length) {
        setFrame(frame + 1);
      } else {
        setChapter((chapter + 1) % CHAPTERS.length);
        setFrame(0);
      }
    }, FRAME_MS);
    return () => window.clearTimeout(timer);
  }, [playing, inView, chapter, frame]);

  const current = CHAPTERS[chapter];
  const active = current.frames[frame];
  const running = playing && inView;

  return (
    <section id="demo" ref={ref} className="section mobile-demo" aria-labelledby="demo-title">
      <div className="wrap">
        <p className="eyebrow">02 / Guided walkthrough</p>
        <h2 id="demo-title">See it in motion.</h2>
        <p className="lede">
          A hands-free tour of the real app. Five experiences play automatically — no tapping, no setup.
        </p>

        <div className="mobile-film">
          <div className="film-bar">
            <span className="film-dots" aria-hidden="true"><i /><i /><i /></span>
            <span className="film-title">Demo Café · {current.title}</span>
            <span className={`film-live${playing ? '' : ' paused'}`} aria-hidden="true"><i />{playing ? 'Auto' : 'Paused'}</span>
          </div>

          <div className="film-stage" role="group" aria-label={`${current.title}: ${active.label}`}>
            {current.frames.map((item, i) => (
              <div key={`${chapter}-${item.name}`} className={`film-shot${i === frame ? ' on' : ''}`} aria-hidden={i !== frame}>
                <ScreenImage
                  name={item.name}
                  alt={item.alt}
                  sizes="(max-width: 820px) calc(100vw - 44px), 640px"
                />
              </div>
            ))}
            <div className="film-meter" aria-hidden="true">
              <span
                key={`${chapter}-${frame}-${running}`}
                style={{ animationDuration: `${FRAME_MS}ms`, animationPlayState: running ? 'running' : 'paused' }}
              />
            </div>
          </div>

          <p className="film-caption">
            <span>{chapterLabel(frame + 1)} / {chapterLabel(current.frames.length)}</span>
            <strong>{active.label}</strong>
          </p>

          <div className="film-meta">
            <div className="film-heading">
              <span>{chapterLabel(chapter + 1)} / {chapterLabel(CHAPTERS.length)}</span>
              <h3>{current.title}</h3>
            </div>
            <p className="film-blurb">{current.blurb}</p>
            <ol className="film-steps" aria-label="Steps in this experience">
              {current.frames.map((item, i) => (
                <li key={`${item.name}-${i}`} className={i === frame ? 'on' : ''} aria-current={i === frame ? 'step' : undefined}>
                  <i>{i + 1}</i>{item.label}
                </li>
              ))}
            </ol>
            <div className="film-foot">
              <div className="film-chapters" aria-hidden="true">
                {CHAPTERS.map((item, i) => (
                  <i key={item.id} className={i < chapter ? 'done' : i === chapter ? 'on' : ''} />
                ))}
              </div>
              <button type="button" className="film-pause" onClick={() => setPlaying((on) => !on)}>
                <span aria-hidden="true">{playing ? '❚❚' : '▶'}</span>
                {playing ? 'Pause' : 'Play'} tour
              </button>
            </div>
          </div>
        </div>

        <p className="note">
          <b>Demo note:</b> all products, prices and sales figures are sample data. Payment and menu scanning are
          simulated; no real payment takes place. For the interactive app, open this page on a tablet or desktop.
        </p>
      </div>
    </section>
  );
}

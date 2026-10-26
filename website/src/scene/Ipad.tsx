import { useMemo, useRef, type ReactNode } from 'react';
import { useFrame } from '@react-three/fiber';
import { Html, Line, RoundedBox, useTexture } from '@react-three/drei';
import * as THREE from 'three';
import { live } from './state';

export const IPAD_W = 4.6;
export const IPAD_H = 3.2;
const IPAD_D = 0.16;
const SCREEN_W = 4.0;
const SCREEN_H = SCREEN_W / 1.4388; // matches the screenshot aspect ratio

export const SCREENS = ['12-kiosk-welcome', '05-qr-payment', '01-dashboard', '06-kitchen-display', '07-analytics'];

// drei's <Html transform> renders at 40 CSS px per world unit (distanceFactor 10), so the prop
// scale that maps LIVE_W px onto the screen mesh is world width * 40 / px width.
const LIVE_W = 1024;
const LIVE_SCALE = (SCREEN_W * 40) / LIVE_W;

function roundedRect(w: number, h: number, r: number) {
  const s = new THREE.Shape();
  const x = -w / 2;
  const y = -h / 2;
  s.moveTo(x + r, y);
  s.lineTo(x + w - r, y);
  s.absarc(x + w - r, y + r, r, -Math.PI / 2, 0, false);
  s.lineTo(x + w, y + h - r);
  s.absarc(x + w - r, y + h - r, r, 0, Math.PI / 2, false);
  s.lineTo(x + r, y + h);
  s.absarc(x + r, y + h - r, r, Math.PI / 2, Math.PI, false);
  s.lineTo(x, y + r);
  s.absarc(x + r, y + r, r, Math.PI, Math.PI * 1.5, false);
  return s;
}

function RoundedPlane({ w, h, r, children }: { w: number; h: number; r: number; children?: ReactNode }) {
  const geo = useMemo(() => {
    const g = new THREE.ShapeGeometry(roundedRect(w, h, r), 10);
    const pos = g.attributes.position;
    const uv = g.attributes.uv;
    for (let i = 0; i < pos.count; i++) uv.setXY(i, (pos.getX(i) + w / 2) / w, (pos.getY(i) + h / 2) / h);
    return g;
  }, [w, h, r]);
  return <mesh geometry={geo}>{children}</mesh>;
}

const LAYERS = [
  { n: '01', title: 'Interface', z: 0.45 },
  { n: '02', title: 'State & domain', z: -0.55 },
  { n: '03', title: 'Payments', z: -1.1 },
  { n: '04', title: 'Data', z: -1.65 },
];

const clamp01 = (n: number) => Math.min(1, Math.max(0, n));

export default function Ipad({ liveActive, liveChildren }: { liveActive: boolean; liveChildren: ReactNode }) {
  const textures = useTexture(SCREENS.map((s) => `${import.meta.env.BASE_URL}screens/${s}.png`));
  textures.forEach((t) => {
    t.colorSpace = THREE.SRGBColorSpace;
    t.anisotropy = 8;
  });

  const front = useRef<THREE.Group>(null);
  const matA = useRef<THREE.MeshBasicMaterial>(null);
  const matB = useRef<THREE.MeshBasicMaterial>(null);
  const plates = useRef<(THREE.Group | null)[]>([]);
  const labels = useRef<(HTMLDivElement | null)[]>([]);
  const idx = useRef(-1);

  const outline = useMemo(
    () => roundedRect(SCREEN_W + 0.3, SCREEN_H + 0.3, 0.2).getPoints(14).map((p) => new THREE.Vector3(p.x, p.y, 0)),
    [],
  );

  useFrame(() => {
    const e = live.explode;
    const s = Math.min(SCREENS.length - 1, Math.max(0, live.screen));
    const i = Math.min(SCREENS.length - 2, Math.floor(s));
    const f = s - i;
    if (idx.current !== i && matA.current && matB.current) {
      matA.current.map = textures[i];
      matB.current.map = textures[i + 1];
      matA.current.needsUpdate = matB.current.needsUpdate = true;
      idx.current = i;
    }
    if (matB.current) matB.current.opacity = f;
    if (front.current) front.current.position.z = IPAD_D / 2 + 0.006 + LAYERS[0].z * e;
    plates.current.forEach((g, k) => {
      if (g) g.position.z = LAYERS[k + 1].z * e;
    });
    const o = clamp01((e - 0.3) / 0.5);
    labels.current.forEach((el) => {
      if (el) el.style.opacity = String(o);
    });
  });

  return (
    <group>
      {/* aluminium body */}
      <RoundedBox args={[IPAD_W, IPAD_H, IPAD_D]} radius={0.2} smoothness={6} creaseAngle={0.4}>
        <meshPhysicalMaterial color="#9aa1ad" metalness={1} roughness={0.32} clearcoat={0.25} clearcoatRoughness={0.45} envMapIntensity={1.25} />
      </RoundedBox>

      {/* front: glass, screen and live UI float together when exploded */}
      <group ref={front} position={[0, 0, IPAD_D / 2 + 0.004]}>
        <RoundedPlane w={IPAD_W - 0.1} h={IPAD_H - 0.1} r={0.17}>
          <meshStandardMaterial color="#050506" roughness={0.12} metalness={0.4} />
        </RoundedPlane>
        <group position={[0, 0, 0.004]}>
          <RoundedPlane w={SCREEN_W} h={SCREEN_H} r={0.07}>
            <meshBasicMaterial ref={matA} toneMapped={false} />
          </RoundedPlane>
          <group position={[0, 0, 0.002]}>
            <RoundedPlane w={SCREEN_W} h={SCREEN_H} r={0.07}>
              <meshBasicMaterial ref={matB} toneMapped={false} transparent opacity={0} depthWrite={false} />
            </RoundedPlane>
          </group>
          <mesh position={[0, IPAD_H / 2 - 0.115, 0.002]}>
            <circleGeometry args={[0.025, 20]} />
            <meshBasicMaterial color="#14151a" />
          </mesh>
          <Html
            transform
            position={[0, 0, 0.01]}
            scale={LIVE_SCALE}
            zIndexRange={[5, 0]}
            style={{ pointerEvents: liveActive ? 'auto' : 'none' }}
          >
            <div
              className={`live-screen${liveActive ? ' on' : ''}`}
              style={{ width: LIVE_W, height: 712 }}
              aria-hidden={!liveActive}
              {...(liveActive ? {} : { inert: '' })}
            >
              {liveChildren}
            </div>
          </Html>
        </group>
      </group>

      {/* exploded system layers */}
      {LAYERS.slice(1).map((l, k) => (
        <group
          key={l.n}
          ref={(g) => {
            plates.current[k] = g;
          }}
        >
          <RoundedPlane w={SCREEN_W + 0.3} h={SCREEN_H + 0.3} r={0.2}>
            <meshBasicMaterial color="#5b9dff" transparent opacity={0.05} side={THREE.DoubleSide} depthWrite={false} />
          </RoundedPlane>
          <Line points={outline} color="#5b9dff" lineWidth={1.4} transparent opacity={0.85} />
          <Html position={[SCREEN_W / 2 + 0.15, SCREEN_H / 2 + 0.15, 0]} zIndexRange={[4, 0]} style={{ pointerEvents: 'none' }}>
            <div
              className="layer-label"
              ref={(el) => {
                labels.current[k + 1] = el;
              }}
              style={{ opacity: 0 }}
            >
              <b>{l.n}</b>
              <strong>{l.title}</strong>
            </div>
          </Html>
        </group>
      ))}
      <Html position={[SCREEN_W / 2 + 0.15, SCREEN_H / 2 + 0.15, LAYERS[0].z]} zIndexRange={[4, 0]} style={{ pointerEvents: 'none' }}>
        <div
          className="layer-label"
          ref={(el) => {
            labels.current[0] = el;
          }}
          style={{ opacity: 0 }}
        >
          <b>{LAYERS[0].n}</b>
          <strong>{LAYERS[0].title}</strong>
        </div>
      </Html>
    </group>
  );
}

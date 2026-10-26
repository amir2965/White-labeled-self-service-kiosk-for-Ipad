import { Suspense, useRef, type ReactNode } from 'react';
import { Canvas, useFrame, useThree } from '@react-three/fiber';
import { Environment, Lightformer } from '@react-three/drei';
import * as THREE from 'three';
import Ipad, { IPAD_W } from './Ipad';
import { live, rig } from './state';
import { targetPose, type Pose } from './poses';

interface RigProps {
  mobile: boolean;
  liveActive: boolean;
  liveChildren: ReactNode;
}

function Rig({ mobile, liveActive, liveChildren }: RigProps) {
  const group = useRef<THREE.Group>(null);
  const cur = useRef<Pose | null>(null);
  const { viewport } = useThree();

  useFrame((state, dt) => {
    const g = group.current;
    if (!g) return;
    const target = targetPose(rig.section, rig.frac, mobile);
    if (!cur.current) cur.current = { ...target };
    const c = cur.current;
    const k = 1 - Math.exp(-5 * Math.min(dt, 0.05));
    (Object.keys(c) as (keyof Pose)[]).forEach((key) => {
      c[key] += (target[key] - c[key]) * k;
    });
    live.screen = c.screen;

    const t = state.clock.elapsedTime;
    const calm = rig.section === 2 ? 0.15 : 1; // idle motion fades out while the demo is interactive
    const px = rig.pointerX * 0.06 * calm;
    const py = rig.pointerY * 0.04 * calm;

    g.position.set((c.x * viewport.width) / 2, (c.y * viewport.height) / 2 + Math.sin(t * 0.8) * 0.04 * calm, 0);
    g.rotation.set(c.rx + py + Math.sin(t * 0.6) * 0.01 * calm, c.ry + px, c.rz);
    const s = Math.max(0.0001, (c.w * viewport.width * Math.max(0, c.vis)) / IPAD_W);
    g.scale.setScalar(s);
    g.visible = c.vis > 0.01;
  });

  return (
    <group ref={group}>
      <Ipad liveActive={liveActive} liveChildren={liveChildren} />
    </group>
  );
}

export default function Scene(props: RigProps) {
  return (
    <Canvas
      dpr={[1, props.mobile ? 1.5 : 1.75]}
      camera={{ position: [0, 0, 8], fov: 32, near: 0.1, far: 50 }}
      gl={{ antialias: true, alpha: true, powerPreference: 'high-performance' }}
      onCreated={({ gl }) => {
        gl.toneMapping = THREE.ACESFilmicToneMapping;
        gl.toneMappingExposure = 1.05;
      }}
    >
      <Suspense fallback={null}>
        {/* studio lighting built in-scene: no HDR downloads */}
        <Environment resolution={256} frames={1}>
          <Lightformer form="rect" intensity={5} position={[-5, 3, 4]} scale={[7, 3, 1]} color="#ffffff" />
          <Lightformer form="rect" intensity={3} position={[5, -1, 3]} scale={[3, 7, 1]} color="#8ab4ff" />
          <Lightformer form="ring" intensity={3} position={[0, 5, -4]} scale={5} color="#ffffff" />
          <Lightformer form="rect" intensity={1.5} position={[0, -4, 2]} scale={[8, 1, 1]} color="#5b9dff" />
        </Environment>
        <ambientLight intensity={0.25} />
        <directionalLight position={[3, 4, 5]} intensity={1.2} />
        <Rig {...props} />
      </Suspense>
    </Canvas>
  );
}

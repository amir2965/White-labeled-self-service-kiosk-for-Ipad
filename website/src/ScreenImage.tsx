import type { ImgHTMLAttributes } from 'react';

/** Stable intrinsic sizes and responsive assets for the existing product screenshots. */
export default function ScreenImage({ name, ...props }: ImgHTMLAttributes<HTMLImageElement> & { name: string }) {
  const width = name === '12-kiosk-welcome' ? 1181 : 1000;
  const height = name === '12-kiosk-welcome' ? 821 : name === '13-kiosk-menu' ? 503 : name === '01-dashboard' ? 750 : 695;
  const base = `${import.meta.env.BASE_URL}screens/${name}`;
  return <img src={`${base}-1024.webp`} srcSet={`${base}-640.webp 640w, ${base}-1024.webp ${Math.min(width, 1024)}w`} sizes="(max-width: 820px) 90vw, 600px" width={width} height={height} loading="lazy" decoding="async" {...props} />;
}

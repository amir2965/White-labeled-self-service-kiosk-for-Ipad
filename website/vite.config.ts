import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// Relative base so the build works on GitHub Pages (project sites) and any static host.
export default defineConfig({
  base: './',
  plugins: [react()],
  build: {
    chunkSizeWarningLimit: 1200,
    // Let the dynamic Scene import own its dependency graph. Manual 3D chunks
    // pulled shared React dependencies into the initial mobile preload graph.
  },
});

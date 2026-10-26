// Mutable scene state shared between DOM scroll handling and the render loop (no React re-renders).
export const rig = {
  section: 0,
  frac: 0,
  pointerX: 0,
  pointerY: 0,
};

export const live = {
  screen: 0,
};

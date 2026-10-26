export type CategoryId = 'coffee' | 'tea' | 'food';

export interface Product {
  id: string;
  name: string;
  desc: string;
  price: number;
  img: string;
  cat: CategoryId;
  sizes?: boolean;
  milk?: boolean;
}

const img = (name: string) => `${import.meta.env.BASE_URL}menu/${name}.jpg`;

export const CATEGORIES: { id: CategoryId; label: string }[] = [
  { id: 'coffee', label: 'Coffee' },
  { id: 'tea', label: 'Tea & more' },
  { id: 'food', label: 'Food' },
];

// Subset of the demo menu used in the Flutter app (same names and prices).
export const PRODUCTS: Product[] = [
  { id: 'latte', name: 'Latte', desc: 'Espresso with steamed milk', price: 4.5, img: img('latte'), cat: 'coffee', sizes: true, milk: true },
  { id: 'cappuccino', name: 'Cappuccino', desc: 'Espresso with foamed milk', price: 4.5, img: img('cappuccino'), cat: 'coffee', sizes: true, milk: true },
  { id: 'americano', name: 'Americano', desc: 'Espresso with hot water', price: 3.5, img: img('americano'), cat: 'coffee', sizes: true },
  { id: 'espresso', name: 'Espresso', desc: 'Rich and bold', price: 3.5, img: img('espresso'), cat: 'coffee' },
  { id: 'flatwhite', name: 'Flat White', desc: 'Velvety microfoam with espresso', price: 4.25, img: img('flatwhite'), cat: 'coffee', sizes: true, milk: true },
  { id: 'matcha', name: 'Matcha Latte', desc: 'Premium green tea with milk', price: 4.75, img: img('matcha'), cat: 'tea', sizes: true, milk: true },
  { id: 'hotchoc', name: 'Hot Chocolate', desc: 'Rich dark chocolate, steamed milk', price: 4.25, img: img('hotchoc'), cat: 'tea', sizes: true },
  { id: 'croissant', name: 'Croissant', desc: 'Fresh baked daily', price: 4.0, img: img('croissant'), cat: 'food' },
  { id: 'avocado', name: 'Avocado Toast', desc: 'Smashed avocado on sourdough', price: 8.5, img: img('avocado'), cat: 'food' },
  { id: 'muffin', name: 'Blueberry Muffin', desc: 'Homemade with fresh blueberries', price: 4.5, img: img('muffin'), cat: 'food' },
];

export const SIZES = [
  { id: 'S', label: 'Small', add: 0 },
  { id: 'M', label: 'Medium', add: 0.5 },
  { id: 'L', label: 'Large', add: 1 },
];

export const MILKS = [
  { id: 'whole', label: 'Whole', add: 0 },
  { id: 'oat', label: 'Oat', add: 0.5 },
  { id: 'almond', label: 'Almond', add: 0.5 },
];

// Same fee model as the Flutter app's cart provider.
export const FEE_PERCENT = 2.5;
export const FEE_FIXED = 0.3;

export const money = (n: number) => `$${n.toFixed(2)}`;
export const serviceFee = (subtotal: number) =>
  subtotal === 0 ? 0 : Math.round((subtotal * (FEE_PERCENT / 100) + FEE_FIXED) * 100) / 100;

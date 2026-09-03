import '../models/sneaker.dart';
// Recommended: 800 × 600 px (4 : 3 ratio), JPEG or WebP, < 150 KB.
// The card image area renders at ~160 × 120 px (2× for retina = 320 × 240 px).
// Use a plain/white/light-grey background so the shoe stands out.
// Detail screen hero renders at full screen width × 280 px tall.

final List<Sneaker> sneakerData = [
  const Sneaker(
    id: 1,
    name: 'Air Max Pro',
    brand: 'Nike',
    price: 129.99,
    description:
        'A cushioned Nike-inspired everyday sneaker with a clean streetwear look and soft ride.',
    sizes: ['38', '39', '40', '41', '42', '43', '44', '45'],
    colors: ['White', 'Black', 'Blue'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&h=600&fit=crop',
    rating: 4.8,
    reviews: 245,
  ),
  const Sneaker(
    id: 2,
    name: 'Ultra Boost 22',
    brand: 'Adidas',
    price: 149.99,
    description:
        'A performance runner with responsive cushioning, breathable upper, and modern lifestyle style.',
    sizes: ['38', '39', '40', '41', '42', '43', '44'],
    colors: ['White', 'Green', 'Grey'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800&h=600&fit=crop',
    rating: 4.7,
    reviews: 189,
  ),
  const Sneaker(
    id: 3,
    name: 'Fresh Foam 1080',
    brand: 'New Balance',
    price: 109.99,
    description:
        'A soft daily trainer built for long walks, running, and all-day comfort.',
    sizes: ['39', '40', '41', '42', '43', '44', '45'],
    colors: ['White', 'Blue', 'Green'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1539185441755-769473a23570?w=800&h=600&fit=crop',
    rating: 4.6,
    reviews: 132,
  ),
  const Sneaker(
    id: 4,
    name: 'Gel Nimbus 25',
    brand: 'ASICS',
    price: 139.99,
    description:
        'A premium cushioned runner with smooth support for neutral runners and daily wear.',
    sizes: ['38', '39', '40', '41', '42', '43'],
    colors: ['White', 'Black', 'Green'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1556906781-9a412961d28d?w=800&h=600&fit=crop',
    rating: 4.9,
    reviews: 301,
  ),
  const Sneaker(
    id: 5,
    name: 'Pegasus 40',
    brand: 'Nike',
    price: 119.99,
    description:
        'A versatile training shoe with lightweight cushioning for road runs and casual outfits.',
    sizes: ['40', '41', '42', '43', '44', '45'],
    colors: ['Green', 'White', 'Red'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=800&h=600&fit=crop',
    rating: 4.5,
    reviews: 178,
  ),
  const Sneaker(
    id: 6,
    name: 'Cloud X 3',
    brand: 'On Running',
    price: 159.99,
    description:
        'A lightweight training sneaker made for gym sessions, city walks, and quick transitions.',
    sizes: ['38', '39', '40', '41', '42', '43', '44'],
    colors: ['White', 'Grey', 'Green'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&h=600&fit=crop',
    rating: 4.7,
    reviews: 95,
  ),
  const Sneaker(
    id: 7,
    name: 'Suede Classic',
    brand: 'Puma',
    price: 89.99,
    description:
        'Puma Suede Classic adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '40', '41', '42', '43', '44'],
    colors: ['Black', 'Grey', 'Red'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=800&h=600&fit=crop',
    rating: 4.3,
    reviews: 314,
  ),
  const Sneaker(
    id: 8,
    name: 'Classic Leather',
    brand: 'Reebok',
    price: 84.99,
    description:
        'Reebok Classic Leather adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['40', '41', '42', '43', '44', '45'],
    colors: ['Cream', 'Brown', 'White'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&h=600&fit=crop',
    rating: 4.2,
    reviews: 351,
  ),
  const Sneaker(
    id: 9,
    name: 'Chuck 70 High',
    brand: 'Converse',
    price: 94.99,
    description:
        'Converse Chuck 70 High adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['37', '38', '39', '40', '41', '42'],
    colors: ['Navy', 'White', 'Green'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800&h=600&fit=crop',
    rating: 4.9,
    reviews: 388,
  ),
  const Sneaker(
    id: 10,
    name: 'Old Skool',
    brand: 'Vans',
    price: 74.99,
    description:
        'Vans Old Skool adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '40', '42', '44', '45'],
    colors: ['Grey', 'Blue', 'Orange'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1539185441755-769473a23570?w=800&h=600&fit=crop',
    rating: 4.8,
    reviews: 425,
  ),
  const Sneaker(
    id: 11,
    name: 'F-13 Retro',
    brand: 'Fila',
    price: 79.99,
    description:
        'Fila F-13 Retro adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '41', '42', '43', '45'],
    colors: ['Black', 'White', 'Yellow'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1556906781-9a412961d28d?w=800&h=600&fit=crop',
    rating: 4.7,
    reviews: 72,
  ),
  const Sneaker(
    id: 12,
    name: 'Disruptor II',
    brand: 'Champion',
    price: 69.99,
    description:
        'Champion Disruptor II adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '39', '40', '41', '42', '43'],
    colors: ['White', 'Black', 'Blue'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=800&h=600&fit=crop',
    rating: 4.6,
    reviews: 109,
  ),
  const Sneaker(
    id: 13,
    name: 'Court Legacy',
    brand: 'Lacoste',
    price: 109.99,
    description:
        'Lacoste Court Legacy adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '40', '41', '42', '43', '44'],
    colors: ['Black', 'Grey', 'Red'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&h=600&fit=crop',
    rating: 4.5,
    reviews: 146,
  ),
  const Sneaker(
    id: 14,
    name: 'Sprint Runner',
    brand: 'Under Armour',
    price: 99.99,
    description:
        'Under Armour Sprint Runner adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['40', '41', '42', '43', '44', '45'],
    colors: ['Cream', 'Brown', 'White'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=800&h=600&fit=crop',
    rating: 4.4,
    reviews: 183,
  ),
  const Sneaker(
    id: 15,
    name: 'Clifton 9',
    brand: 'Hoka',
    price: 144.99,
    description:
        'Hoka Clifton 9 adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['37', '38', '39', '40', '41', '42'],
    colors: ['Navy', 'White', 'Green'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=800&h=600&fit=crop',
    rating: 4.3,
    reviews: 220,
  ),
  const Sneaker(
    id: 16,
    name: 'Torin 7',
    brand: 'Altra',
    price: 149.99,
    description:
        'Altra Torin 7 adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '40', '42', '44', '45'],
    colors: ['Grey', 'Blue', 'Orange'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&h=600&fit=crop',
    rating: 4.2,
    reviews: 257,
  ),
  const Sneaker(
    id: 17,
    name: 'Aero Glide',
    brand: 'Salomon',
    price: 139.99,
    description:
        'Salomon Aero Glide adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '41', '42', '43', '45'],
    colors: ['Black', 'White', 'Yellow'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800&h=600&fit=crop',
    rating: 4.9,
    reviews: 294,
  ),
  const Sneaker(
    id: 18,
    name: 'Wave Rider',
    brand: 'Mizuno',
    price: 134.99,
    description:
        'Mizuno Wave Rider adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '39', '40', '41', '42', '43'],
    colors: ['White', 'Black', 'Blue'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1539185441755-769473a23570?w=800&h=600&fit=crop',
    rating: 4.8,
    reviews: 331,
  ),
  const Sneaker(
    id: 19,
    name: 'Jazz Original',
    brand: 'Saucony',
    price: 89.99,
    description:
        'Saucony Jazz Original adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '40', '41', '42', '43', '44'],
    colors: ['Black', 'Grey', 'Red'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1556906781-9a412961d28d?w=800&h=600&fit=crop',
    rating: 4.7,
    reviews: 368,
  ),
  const Sneaker(
    id: 20,
    name: 'Vortex Runner',
    brand: 'Brooks',
    price: 129.99,
    description:
        'Brooks Vortex Runner adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['40', '41', '42', '43', '44', '45'],
    colors: ['Cream', 'Brown', 'White'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=800&h=600&fit=crop',
    rating: 4.6,
    reviews: 405,
  ),
  const Sneaker(
    id: 21,
    name: 'Bondi Street',
    brand: 'Skechers',
    price: 84.99,
    description:
        'Skechers Bondi Street adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['37', '38', '39', '40', '41', '42'],
    colors: ['Navy', 'White', 'Green'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&h=600&fit=crop',
    rating: 4.5,
    reviews: 442,
  ),
  const Sneaker(
    id: 22,
    name: 'City Trek',
    brand: 'Merrell',
    price: 119.99,
    description:
        'Merrell City Trek adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '40', '42', '44', '45'],
    colors: ['Grey', 'Blue', 'Orange'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=800&h=600&fit=crop',
    rating: 4.4,
    reviews: 89,
  ),
  const Sneaker(
    id: 23,
    name: 'Trail Flex',
    brand: 'Columbia',
    price: 99.99,
    description:
        'Columbia Trail Flex adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '41', '42', '43', '45'],
    colors: ['Black', 'White', 'Yellow'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=800&h=600&fit=crop',
    rating: 4.3,
    reviews: 126,
  ),
  const Sneaker(
    id: 24,
    name: 'Cloudhorizon',
    brand: 'The North Face',
    price: 159.99,
    description:
        'The North Face Cloudhorizon adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '39', '40', '41', '42', '43'],
    colors: ['White', 'Black', 'Blue'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&h=600&fit=crop',
    rating: 4.2,
    reviews: 163,
  ),
  const Sneaker(
    id: 25,
    name: 'Club Cielo',
    brand: 'Diadora',
    price: 109.99,
    description:
        'Diadora Club Cielo adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '40', '41', '42', '43', '44'],
    colors: ['Black', 'Grey', 'Red'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800&h=600&fit=crop',
    rating: 4.9,
    reviews: 200,
  ),
  const Sneaker(
    id: 26,
    name: 'Veloce Retro',
    brand: 'Kappa',
    price: 79.99,
    description:
        'Kappa Veloce Retro adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['40', '41', '42', '43', '44', '45'],
    colors: ['Cream', 'Brown', 'White'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1539185441755-769473a23570?w=800&h=600&fit=crop',
    rating: 4.8,
    reviews: 237,
  ),
  const Sneaker(
    id: 27,
    name: 'Racer 92',
    brand: 'Umbro',
    price: 74.99,
    description:
        'Umbro Racer 92 adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['37', '38', '39', '40', '41', '42'],
    colors: ['Navy', 'White', 'Green'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1556906781-9a412961d28d?w=800&h=600&fit=crop',
    rating: 4.7,
    reviews: 274,
  ),
  const Sneaker(
    id: 28,
    name: 'Court Ace',
    brand: 'Sergio Tacchini',
    price: 89.99,
    description:
        'Sergio Tacchini Court Ace adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '40', '42', '44', '45'],
    colors: ['Grey', 'Blue', 'Orange'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=800&h=600&fit=crop',
    rating: 4.6,
    reviews: 311,
  ),
  const Sneaker(
    id: 29,
    name: 'Mondo Sport',
    brand: 'Ellesse',
    price: 84.99,
    description:
        'Ellesse Mondo Sport adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '41', '42', '43', '45'],
    colors: ['Black', 'White', 'Yellow'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&h=600&fit=crop',
    rating: 4.5,
    reviews: 348,
  ),
  const Sneaker(
    id: 30,
    name: 'Sky Medal',
    brand: 'Le Coq Sportif',
    price: 114.99,
    description:
        'Le Coq Sportif Sky Medal adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '39', '40', '41', '42', '43'],
    colors: ['White', 'Black', 'Blue'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=800&h=600&fit=crop',
    rating: 4.4,
    reviews: 385,
  ),
  const Sneaker(
    id: 31,
    name: 'Shadow 6000',
    brand: 'Karhu',
    price: 129.99,
    description:
        'Karhu Shadow 6000 adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '40', '41', '42', '43', '44'],
    colors: ['Black', 'Grey', 'Red'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=800&h=600&fit=crop',
    rating: 4.3,
    reviews: 422,
  ),
  const Sneaker(
    id: 32,
    name: 'N9002',
    brand: 'Lotto',
    price: 94.99,
    description:
        'Lotto N9002 adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['40', '41', '42', '43', '44', '45'],
    colors: ['Cream', 'Brown', 'White'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&h=600&fit=crop',
    rating: 4.2,
    reviews: 69,
  ),
  const Sneaker(
    id: 33,
    name: 'Urban Runner',
    brand: 'K-Swiss',
    price: 99.99,
    description:
        'K-Swiss Urban Runner adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['37', '38', '39', '40', '41', '42'],
    colors: ['Navy', 'White', 'Green'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800&h=600&fit=crop',
    rating: 4.9,
    reviews: 106,
  ),
  const Sneaker(
    id: 34,
    name: 'Hypercourt Express',
    brand: 'Babolat',
    price: 119.99,
    description:
        'Babolat Hypercourt Express adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '40', '42', '44', '45'],
    colors: ['Grey', 'Blue', 'Orange'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1539185441755-769473a23570?w=800&h=600&fit=crop',
    rating: 4.8,
    reviews: 143,
  ),
  const Sneaker(
    id: 35,
    name: 'Sprint Pro',
    brand: 'Head',
    price: 109.99,
    description:
        'Head Sprint Pro adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '41', '42', '43', '45'],
    colors: ['Black', 'White', 'Yellow'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1556906781-9a412961d28d?w=800&h=600&fit=crop',
    rating: 4.7,
    reviews: 180,
  ),
  const Sneaker(
    id: 36,
    name: 'Rush Pro Ace',
    brand: 'Wilson',
    price: 104.99,
    description:
        'Wilson Rush Pro Ace adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '39', '40', '41', '42', '43'],
    colors: ['White', 'Black', 'Blue'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=800&h=600&fit=crop',
    rating: 4.6,
    reviews: 217,
  ),
  const Sneaker(
    id: 37,
    name: 'Court FF Style',
    brand: 'Yonex',
    price: 129.99,
    description:
        'Yonex Court FF Style adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '40', '41', '42', '43', '44'],
    colors: ['Black', 'Grey', 'Red'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&h=600&fit=crop',
    rating: 4.5,
    reviews: 254,
  ),
  const Sneaker(
    id: 38,
    name: 'Ghost Knit',
    brand: 'Veja',
    price: 139.99,
    description:
        'Veja Ghost Knit adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['40', '41', '42', '43', '44', '45'],
    colors: ['Cream', 'Brown', 'White'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=800&h=600&fit=crop',
    rating: 4.4,
    reviews: 291,
  ),
  const Sneaker(
    id: 39,
    name: 'Cavalier Runner',
    brand: 'Clarks',
    price: 119.99,
    description:
        'Clarks Cavalier Runner adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['37', '38', '39', '40', '41', '42'],
    colors: ['Navy', 'White', 'Green'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=800&h=600&fit=crop',
    rating: 4.3,
    reviews: 328,
  ),
  const Sneaker(
    id: 40,
    name: 'Tree Dasher',
    brand: 'Allbirds',
    price: 134.99,
    description:
        'Allbirds Tree Dasher adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '40', '42', '44', '45'],
    colors: ['Grey', 'Blue', 'Orange'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&h=600&fit=crop',
    rating: 4.2,
    reviews: 365,
  ),
  const Sneaker(
    id: 41,
    name: 'Knitted Runner',
    brand: 'APL',
    price: 179.99,
    description:
        'APL Knitted Runner adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '41', '42', '43', '45'],
    colors: ['Black', 'White', 'Yellow'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800&h=600&fit=crop',
    rating: 4.9,
    reviews: 402,
  ),
  const Sneaker(
    id: 42,
    name: 'Low 1 Sport',
    brand: 'Common Projects',
    price: 199.99,
    description:
        'Common Projects Low 1 Sport adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '39', '40', '41', '42', '43'],
    colors: ['White', 'Black', 'Blue'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1539185441755-769473a23570?w=800&h=600&fit=crop',
    rating: 4.8,
    reviews: 439,
  ),
  const Sneaker(
    id: 43,
    name: 'Mono Runner',
    brand: 'Axel Arigato',
    price: 189.99,
    description:
        'Axel Arigato Mono Runner adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '40', '41', '42', '43', '44'],
    colors: ['Black', 'Grey', 'Red'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1556906781-9a412961d28d?w=800&h=600&fit=crop',
    rating: 4.7,
    reviews: 86,
  ),
  const Sneaker(
    id: 44,
    name: 'Rush Runner',
    brand: 'Anta',
    price: 99.99,
    description:
        'Anta Rush Runner adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['40', '41', '42', '43', '44', '45'],
    colors: ['Cream', 'Brown', 'White'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=800&h=600&fit=crop',
    rating: 4.6,
    reviews: 123,
  ),
  const Sneaker(
    id: 45,
    name: 'Flash Knit',
    brand: 'Li-Ning',
    price: 119.99,
    description:
        'Li-Ning Flash Knit adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['37', '38', '39', '40', '41', '42'],
    colors: ['Navy', 'White', 'Green'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&h=600&fit=crop',
    rating: 4.5,
    reviews: 160,
  ),
  const Sneaker(
    id: 46,
    name: 'Street Neo',
    brand: '361 Degrees',
    price: 89.99,
    description:
        '361 Degrees Street Neo adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '40', '42', '44', '45'],
    colors: ['Grey', 'Blue', 'Orange'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=800&h=600&fit=crop',
    rating: 4.4,
    reviews: 197,
  ),
  const Sneaker(
    id: 47,
    name: 'Tigre Runner',
    brand: 'Onitsuka Tiger',
    price: 124.99,
    description:
        'Onitsuka Tiger Tigre Runner adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '41', '42', '43', '45'],
    colors: ['Black', 'White', 'Yellow'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=800&h=600&fit=crop',
    rating: 4.3,
    reviews: 234,
  ),
  const Sneaker(
    id: 48,
    name: 'Archive Lo',
    brand: 'DC Shoes',
    price: 79.99,
    description:
        'DC Shoes Archive Lo adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '39', '40', '41', '42', '43'],
    colors: ['White', 'Black', 'Blue'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&h=600&fit=crop',
    rating: 4.2,
    reviews: 271,
  ),
  const Sneaker(
    id: 49,
    name: 'Scout Lite',
    brand: 'Etnies',
    price: 74.99,
    description:
        'Etnies Scout Lite adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '40', '41', '42', '43', '44'],
    colors: ['Black', 'Grey', 'Red'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800&h=600&fit=crop',
    rating: 4.9,
    reviews: 308,
  ),
  const Sneaker(
    id: 50,
    name: 'Court Jam',
    brand: 'Supra',
    price: 89.99,
    description:
        'Supra Court Jam adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['40', '41', '42', '43', '44', '45'],
    colors: ['Cream', 'Brown', 'White'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1539185441755-769473a23570?w=800&h=600&fit=crop',
    rating: 4.8,
    reviews: 345,
  ),
  const Sneaker(
    id: 51,
    name: 'Raven Mesh',
    brand: 'Hummel',
    price: 84.99,
    description:
        'Hummel Raven Mesh adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['37', '38', '39', '40', '41', '42'],
    colors: ['Navy', 'White', 'Green'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1556906781-9a412961d28d?w=800&h=600&fit=crop',
    rating: 4.7,
    reviews: 382,
  ),
  const Sneaker(
    id: 52,
    name: 'Raptor Classic',
    brand: 'Joma',
    price: 79.99,
    description:
        'Joma Raptor Classic adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '40', '42', '44', '45'],
    colors: ['Grey', 'Blue', 'Orange'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111?w=800&h=600&fit=crop',
    rating: 4.6,
    reviews: 419,
  ),
  const Sneaker(
    id: 53,
    name: 'Track 90',
    brand: 'Kelme',
    price: 74.99,
    description:
        'Kelme Track 90 adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '41', '42', '43', '45'],
    colors: ['Black', 'White', 'Yellow'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&h=600&fit=crop',
    rating: 4.5,
    reviews: 66,
  ),
  const Sneaker(
    id: 54,
    name: 'Velocity Knit',
    brand: 'Peak',
    price: 89.99,
    description:
        'Peak Velocity Knit adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['38', '39', '40', '41', '42', '43'],
    colors: ['White', 'Black', 'Blue'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=800&h=600&fit=crop',
    rating: 4.4,
    reviews: 103,
  ),
  const Sneaker(
    id: 55,
    name: 'Fusion Court',
    brand: 'Xtep',
    price: 84.99,
    description:
        'Xtep Fusion Court adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['39', '40', '41', '42', '43', '44'],
    colors: ['Black', 'Grey', 'Red'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=800&h=600&fit=crop',
    rating: 4.3,
    reviews: 140,
  ),
  const Sneaker(
    id: 56,
    name: 'Prime Runner',
    brand: 'Hummel Hive',
    price: 119.99,
    description:
        'Hummel Hive Prime Runner adds a fresh option to the catalog with comfortable cushioning, durable materials, and a versatile streetwear silhouette.',
    sizes: ['40', '41', '42', '43', '44', '45'],
    colors: ['Cream', 'Brown', 'White'],
    emoji: '👟',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&h=600&fit=crop',
    rating: 4.2,
    reviews: 177,
  )
];

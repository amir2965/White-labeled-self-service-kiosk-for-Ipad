# Scan-to-Pay Feature Documentation

## Overview
The scan-to-pay feature allows customers to pay for orders using their mobile devices by scanning a QR code displayed on the kiosk. The payment page supports **Apple Pay** (iPhone/iPad) and **Google Pay** (Android), along with card payments.

## How It Works

### 1. Customer Journey
1. **Order on Kiosk** - Customer selects items and proceeds to checkout
2. **Select QR Payment** - Customer chooses "Scan to Pay" option
3. **QR Code Display** - Kiosk shows QR code with order details
4. **Scan with Phone** - Customer scans QR with their phone camera
5. **Open Checkout** - Payment page opens automatically in their browser
6. **Choose Payment** - Apple Pay, Google Pay, or Card
7. **Complete Payment** - Payment processed securely
8. **Order Confirmed** - Kiosk receives confirmation and updates status

### 2. Technical Flow
```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│    Kiosk     │         │  Mobile Web  │         │   Backend    │
│   (Flutter)  │         │  (checkout)  │         │     API      │
└──────┬───────┘         └──────┬───────┘         └──────┬───────┘
       │                        │                        │
       │ Generate QR            │                        │
       │ with session ID        │                        │
       ├───────────────────────>│                        │
       │                        │                        │
       │                        │ Scan QR Code          │
       │                        │                        │
       │                        │ Fetch order data      │
       │                        ├───────────────────────>│
       │                        │<───────────────────────┤
       │                        │ Display payment UI     │
       │                        │                        │
       │                        │ Process payment        │
       │                        │ (Apple/Google Pay)     │
       │                        │                        │
       │                        │ Update status          │
       │                        ├───────────────────────>│
       │                        │                        │
       │ Poll for status        │                        │
       ├────────────────────────┼───────────────────────>│
       │<───────────────────────┼────────────────────────┤
       │ Show success           │                        │
       │                        │                        │
```

## File Structure

```
lib/
├── presentation/
│   └── payments/
│       └── qr_payment_screen.dart      # Kiosk QR display screen
└── server/
    └── payment_server.dart             # Backend API (optional)

web_checkout/
└── checkout.html                       # Mobile payment page
```

## QR Code URL Format

The QR code contains a URL to the checkout page with query parameters:

```
http://your-domain.com/checkout.html?s=SESSION_ID&order=ORDER_ID&amount=TOTAL
```

**Parameters:**
- `s` or `session` - Payment session ID (for tracking)
- `order` - Order identifier (displayed to user)
- `amount` - Total amount to charge

**Example:**
```
http://localhost:8080/checkout.html?s=abc123&order=ORD001&amount=24.43
```

## Payment Page Features

### Auto-Detection
- **Apple Pay** - Shows on iPhone, iPad, Safari when available
- **Google Pay** - Shows on Android devices with Google Play Services
- **Card Payment** - Always available as fallback

### Mobile-Optimized UI
- Clean, minimal design
- Large touch targets (56px height)
- Responsive layout (max 480px width)
- Dark/light mode compatible
- Smooth animations and transitions

### Security
- HTTPS required for production
- Payment data never touches your servers (processed by payment provider)
- Secure payment indicators displayed
- Session timeout (5 minutes default)

## Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure Payment URLs

Update the base URL in `qr_payment_screen.dart`:

```dart
String get _paymentUrl {
  // Development: http://localhost:8080/checkout.html
  // Production: https://your-domain.com/checkout.html
  final baseUrl = 'https://pay.yourdomain.com/checkout.html';
  // ... rest of code
}
```

### 3. Deploy Checkout Page

#### Option A: Same Server (Recommended for Testing)
The checkout page is automatically copied to `build/web/` when you build:

```bash
flutter build web
```

Then serve with:
```bash
cd build/web
python -m http.server 8080
```

Or use the provided script:
```bash
.\run-ngrok.ps1
```

#### Option B: Separate Hosting (Production)
Deploy `web_checkout/checkout.html` to:
- **Netlify** - Drop file in dashboard
- **Vercel** - `vercel --prod`
- **Firebase Hosting** - `firebase deploy`
- **AWS S3 + CloudFront**
- **Your own server**

### 4. Configure Payment Providers

#### Apple Pay Setup
1. Get Apple Developer account
2. Create Merchant ID at developer.apple.com
3. Generate certificates
4. Update `checkout.html` with your Merchant ID:

```javascript
const paymentRequest = {
    countryCode: 'US',
    currencyCode: 'USD',
    merchantIdentifier: 'merchant.com.yourdomain.kiosk', // Your ID
    // ...
};
```

#### Google Pay Setup
1. Get Google Pay API access
2. Register your site at pay.google.com
3. Add Google Pay API script:

```html
<script src="https://pay.google.com/gp/p/js/pay.js"></script>
```

4. Configure in `checkout.html`:

```javascript
const googlePayBaseRequest = {
    apiVersion: 2,
    apiVersionMinor: 0,
    merchantInfo: {
        merchantId: 'YOUR_MERCHANT_ID',
        merchantName: 'Self-Service Kiosk'
    }
};
```

#### Card Payments (Stripe)
Add Stripe.js before `</body>`:

```html
<script src="https://js.stripe.com/v3/"></script>
<script>
    const stripe = Stripe('pk_test_YOUR_KEY');
    // Card payment implementation
</script>
```

Or use a card-form SDK from your payment provider (e.g. Stripe Elements).

### 5. Backend API (Optional but Recommended)

Run the payment server for webhook handling:

```bash
dart run lib/server/payment_server.dart
```

Or integrate endpoints into your existing backend:

**POST** `/api/payment-sessions/:sessionId/status`
```json
{
  "status": "paid" // or "failed", "cancelled"
}
```

**Response:**
```json
{
  "success": true,
  "sessionId": "abc123",
  "status": "paid"
}
```

## Testing

### Local Testing with ngrok

1. Build and serve Flutter app:
```bash
.\run-ngrok.ps1
```

2. You'll get a public URL like:
```
https://abc123.ngrok-free.app
```

3. Update QR URL in code to use this domain

4. Test on real device:
   - Scan QR code with iPhone/Android
   - Checkout page opens
   - Test Apple Pay/Google Pay

### Test Cards (Stripe)
- **Success:** 4242 4242 4242 4242
- **Decline:** 4000 0000 0000 0002
- **3D Secure:** 4000 0025 0000 3155

## Production Checklist

- [ ] Replace localhost URLs with production domain
- [ ] Configure Apple Pay merchant ID and certificates
- [ ] Set up Google Pay merchant account
- [ ] Integrate real payment provider (Stripe)
- [ ] Set up SSL/HTTPS for checkout page
- [ ] Implement backend API for payment webhooks
- [ ] Add payment status polling/WebSocket in kiosk
- [ ] Test all payment methods on real devices
- [ ] Add analytics and error tracking
- [ ] Implement refund handling
- [ ] Add receipt email functionality
- [ ] Test timeout and edge cases
- [ ] Add fraud detection if needed
- [ ] Compliance: PCI-DSS, GDPR, etc.

## Customization

### Styling
Edit CSS variables in `checkout.html`:

```css
:root {
    --black: #000000;
    --blue: #007AFF;
    --white: #FFFFFF;
    /* Customize colors */
}
```

### Timeout Duration
In `qr_payment_screen.dart`:

```dart
int _secondsRemaining = 300; // 5 minutes (adjust as needed)
```

### Order Items
To show real order items, fetch from backend:

```javascript
async function fetchOrderData() {
    const response = await fetch(`/api/orders/${orderId}`);
    const data = await response.json();
    orderData = data;
    // ...
}
```

## Troubleshooting

### QR Code Doesn't Scan
- Ensure proper contrast (dark on light background)
- Check QR size is adequate (300x300 minimum)
- Verify URL is valid and accessible

### Apple Pay Not Showing
- Must be on Safari (iOS/macOS)
- HTTPS required (or localhost)
- Valid merchant ID needed
- Cards must be added to Wallet

### Google Pay Not Showing
- Android device with Google Play Services
- Google Chrome recommended
- Google account with payment method

### Payment Not Confirming on Kiosk
- Check backend API is running
- Verify polling interval not too long
- Ensure session ID matches
- Check network connectivity

## Support & Resources

- **Apple Pay:** https://developer.apple.com/apple-pay/
- **Google Pay:** https://developers.google.com/pay/api/web
- **Stripe:** https://stripe.com/docs

## License

Portfolio demo project.

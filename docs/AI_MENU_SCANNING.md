# AI Menu Scanning Setup

## Overview
The app uses Google's Gemini Flash API (free tier) to automatically extract menu items from photos. This is a **secure, free approach** that processes images on Google's servers (not stored permanently).

## Security & Privacy
- ✅ **Free Forever**: Google Gemini has a generous free tier
- ✅ **Secure**: Images processed via HTTPS, not stored by Google after processing
- ✅ **No Storage**: Images stay on client device, only sent to API temporarily
- ✅ **Client-Side**: User uploads directly from their browser/device
- ✅ **API Key**: Your own key = your control

## Free Tier Limits (Gemini Flash)
- **15 requests per minute**
- **1,500 requests per day**
- **No credit card required**
- Perfect for onboarding setup (typically 1-3 requests per merchant)

## Setup Instructions

### 1. Get Free API Key (2 minutes)

1. Visit: **https://ai.google.dev**
2. Click "Get API Key" (top right)
3. Sign in with Google account
4. Click "Create API Key" 
5. Copy your key (starts with `AIza...`)

### 2. Add API Key to App

**Option A: Environment Variable (Recommended for Production)**
```bash
# Create .env file in project root
GEMINI_API_KEY=your_key_here
```

**Option B: Configuration File (For Testing)**
Create `lib/config/api_keys.dart`:
```dart
class ApiKeys {
  static const String geminiApiKey = 'YOUR_KEY_HERE';
}
```

**Option C: User Input (Most Secure)**
- User enters their own API key in app settings
- Stored locally in secure storage
- Full user control

### 3. Update Code

In `products_setup_step.dart`, replace:
```dart
const apiKey = 'YOUR_GEMINI_API_KEY';
```

With:
```dart
const apiKey = String.fromEnvironment('GEMINI_API_KEY', 
  defaultValue: 'YOUR_GEMINI_API_KEY'
);
```

Or use the config file:
```dart
import '../../../config/api_keys.dart';
// ...
final apiKey = ApiKeys.geminiApiKey;
```

## How It Works

### 1. User Flow
1. User clicks "Scan Menu Photo" in onboarding step 4
2. Selects photo from device (camera or gallery)
3. Image uploaded and analyzed by Gemini AI
4. Extracts: items, prices, categories, modifiers
5. Results displayed for review/editing

### 2. Technical Flow
```
User Photo → Base64 Encode → Gemini API → JSON Response → Parse → Display
```

### 3. What Gets Extracted
- **Item Name**: e.g., "Caramel Macchiato"
- **Price**: e.g., 5.95 (decimal)
- **Category**: e.g., "Coffee", "Food", "Drinks"
- **Description**: e.g., "Espresso with vanilla and caramel"
- **Modifiers**: e.g., ["Small", "Medium", "Large", "Extra shot"]

### 4. AI Prompt
The system uses a structured prompt that:
- Requests JSON format only
- Defines exact schema needed
- Handles missing data gracefully
- Extracts modifiers/customizations
- Infers categories intelligently

## Alternative Free Options

If you don't want to use Gemini, here are other free approaches:

### Option 1: Tesseract.js (100% Client-Side)
```bash
# Add to pubspec.yaml
dependencies:
  tesseract_ocr: ^0.1.0
```
- **Pros**: Free forever, no API needed, works offline
- **Cons**: Less accurate, requires manual parsing

### Option 2: OpenAI Free Tier
- Free trial credits ($5)
- Same implementation, different endpoint
- Better accuracy for complex menus

### Option 3: Azure Computer Vision
- Free tier: 5,000 transactions/month
- Excellent OCR quality
- 20 calls/minute

## Production Deployment

### Security Checklist
- [ ] Use environment variables for API key
- [ ] Add rate limiting (prevent abuse)
- [ ] Validate image size (<5MB recommended)
- [ ] Sanitize extracted data
- [ ] Add error handling for API failures
- [ ] Log usage for monitoring

### Cost Management
- Free tier sufficient for most small/medium businesses
- If exceeding limits, consider:
  - Batch processing (multiple merchants in one call)
  - Caching results
  - User-provided API keys

## Troubleshooting

### "API Key Required" Dialog
- You need to add your Gemini API key
- Follow setup instructions above
- Verify key is valid at ai.google.dev

### "Could not extract menu items"
- Image quality too low (use better photo)
- Menu text too small/blurry
- API rate limit reached (wait 1 minute)
- Invalid API key (check configuration)

### Inaccurate Results
- Take clearer photo with good lighting
- Ensure text is readable in image
- Try scanning menu sections separately
- Manually edit extracted items

## Support

For issues with:
- **Gemini API**: https://ai.google.dev/support
- **App Integration**: Check app documentation
- **Billing**: Free tier = no billing, no credit card

## Legal & Compliance

- Google's API Terms: https://ai.google.dev/terms
- Data Processing: Images processed temporarily, not stored
- GDPR Compliant: No personal data collected
- SOC 2 Certified: Google infrastructure

---

**Last Updated**: December 2025  
**API Version**: Gemini 1.5 Flash (latest)

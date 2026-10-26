# Professional Kiosk Home Page Templates

## Design Principles

### Speed First
- **3-Second Rule**: Customer must understand options within 3 seconds
- **Zero Learning Curve**: No tutorials, tooltips, or help needed
- **One-Screen Decision**: All choices visible without scrolling

### Enterprise UX
- **Touch-Optimized**: All targets ≥48px (prefer 64–80px)
- **Clean Minimal**: Black/white/gray primary, blue for actions
- **Professional Trust**: Enterprise-grade visual quality
- **Accessibility**: High contrast (WCAG AAA), large text

### Technical Requirements
- **Landscape Orientation**: 1024×768 to 1920×1080
- **Inter Font**: System font with clean hierarchy
- **Responsive Grid**: Adapts to 10–13" tablets
- **No Animations**: Instant feedback only

---

## Template 1: Centered Fast Order (Recommended Default)

### Visual Preview
```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│                          [CAFE LOGO]                               │
│                         Downtown Coffee                             │
│                                                                     │
│                                                                     │
│                    ┌──────────────────┐                           │
│                    │                  │                           │
│                    │   Start Order    │  ← 80px tall             │
│                    │                  │                           │
│                    └──────────────────┘                           │
│                                                                     │
│                  Dine In    |    Takeaway                         │
│                     ○             ○                               │
│                                                                     │
│                                                                     │
│                      [ 🌐 English ▾ ]                              │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Layout Structure
```css
Container {
  background: white
  alignment: center
  padding: 48px
  
  Column {
    Logo {
      height: 120px
      margin-bottom: 24px
    }
    
    BusinessName {
      font: Inter 32px Medium
      color: #000000
      margin-bottom: 64px
    }
    
    StartButton {
      width: 320px
      height: 80px
      background: #007AFF
      border-radius: 12px
      font: Inter 24px Semibold
      color: white
      margin-bottom: 40px
    }
    
    OrderModeSelector {
      Row {
        spacing: 48px
        
        ModeButton {
          width: 160px
          height: 64px
          border: 2px solid #E0E0E0
          border-radius: 8px
          font: Inter 18px Medium
        }
      }
    }
    
    LanguageSelector {
      margin-top: 48px
      width: 200px
      height: 48px
      border: 1px solid #E0E0E0
      border-radius: 8px
    }
  }
}
```

### UX Logic
1. **Idle State**: Logo + "Start Order" button pulsing softly
2. **Tap Start**: Button changes to "Continue →" while mode selector appears
3. **Mode Selection**: Selected option gets blue border, unselected grays out
4. **Language**: Only shown if multi-language enabled in settings
5. **Timeout**: 60s of inactivity resets to idle state

### Visual Hierarchy
- **Primary**: Start Order button (blue, largest)
- **Secondary**: Order mode buttons (gray outline)
- **Tertiary**: Language selector (subtle, bottom)
- **Accent**: Logo (brand, centered top)

### Responsiveness Rules
```dart
// 10" tablet (1024×768)
logoHeight: 100px
buttonWidth: 280px
fontSize: 20px

// 12" tablet (1280×800)
logoHeight: 120px
buttonWidth: 320px
fontSize: 24px

// 13" tablet (1920×1080)
logoHeight: 140px
buttonWidth: 360px
fontSize: 28px
```

### Code Implementation
```dart
class CenteredFastOrderTemplate extends StatelessWidget {
  final String businessName;
  final String? logoUrl;
  final VoidCallback onStartOrder;
  final Function(OrderMode) onModeSelected;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            if (logoUrl != null)
              Image.network(
                logoUrl!,
                height: 120,
                fit: BoxFit.contain,
              ),
            SizedBox(height: AppSpacing.xl),
            
            // Business Name
            Text(
              businessName,
              style: AppTypography.displayMedium.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 64),
            
            // Start Order Button
            AppButton(
              label: 'Start Order',
              onPressed: onStartOrder,
              width: 320,
              height: 80,
              fontSize: 24,
              backgroundColor: AppColors.blue,
            ),
            SizedBox(height: 40),
            
            // Order Mode Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ModeButton(
                  label: 'Dine In',
                  icon: Icons.restaurant,
                  onTap: () => onModeSelected(OrderMode.dineIn),
                ),
                SizedBox(width: 48),
                _ModeButton(
                  label: 'Takeaway',
                  icon: Icons.shopping_bag,
                  onTap: () => onModeSelected(OrderMode.takeaway),
                ),
              ],
            ),
            
            SizedBox(height: 48),
            
            // Language Selector
            _LanguageSelector(),
          ],
        ),
      ),
    );
  }
}
```

---

## Template 2: Split Mode Selection

### Visual Preview
```
┌─────────────────────────────────────────────────────────────────────┐
│                          [CAFE LOGO]                               │
│                         Downtown Coffee                             │
│                                                                     │
│    ┌──────────────────────────┐  ┌──────────────────────────┐     │
│    │                          │  │                          │     │
│    │         🍽️              │  │         🛍️              │     │
│    │                          │  │                          │     │
│    │       Dine In            │  │       Takeaway           │     │
│    │                          │  │                          │     │
│    │   Eat here, relax        │  │   Grab & go fast        │     │
│    │                          │  │                          │     │
│    └──────────────────────────┘  └──────────────────────────┘     │
│                                                                     │
│                      [ 🌐 English ▾ ]                              │
└─────────────────────────────────────────────────────────────────────┘
```

### Layout Structure
- **Top**: Logo + Business Name (120px height)
- **Center**: Two large cards side-by-side (400×480px each)
- **Bottom**: Language selector (48px height)

### UX Logic
1. **Idle State**: Both cards have subtle shadow, equal visual weight
2. **Hover**: Card scales 1.02x, shadow deepens
3. **Tap**: Immediate navigation to product menu with selected mode
4. **No Multi-Step**: Direct mode selection → product screen

### Visual Hierarchy
- **Co-Primary**: Both mode cards equal (50/50 split)
- **Supporting**: Icon + label + subtitle pattern
- **Minimal**: Only logo, modes, language

### Responsiveness Rules
```dart
// Cards always maintain 1:1 aspect ratio
cardWidth = (screenWidth - 3 * padding) / 2
cardHeight = cardWidth * 1.2
iconSize = cardWidth * 0.2
```

---

## Template 3: Category-First Express

### Visual Preview
```
┌─────────────────────────────────────────────────────────────────────┐
│ [Logo] Downtown Coffee                              🌐 English ▾  │
│                                                                     │
│                     What would you like?                           │
│                                                                     │
│    ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐               │
│    │   ☕   │  │   🍰   │  │   🥗   │  │   🥤   │               │
│    │        │  │        │  │        │  │        │               │
│    │ Coffee │  │ Pastry │  │  Food  │  │ Drinks │               │
│    └────────┘  └────────┘  └────────┘  └────────┘               │
│                                                                     │
│    ○ Dine In       ○ Takeaway                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Layout Structure
- **Header**: Logo + Language (60px height, sticky)
- **Headline**: "What would you like?" (80px)
- **Category Grid**: 4 columns × 180px cards
- **Footer**: Mode selector (64px height)

### UX Logic
1. **Direct Selection**: Tap category → goes to products in that category
2. **Mode Default**: Defaults to Dine In, can change before ordering
3. **Skip Home**: No intermediate "Start Order" step
4. **Speed Optimized**: 1 tap from idle to browsing products

### Visual Hierarchy
- **Primary**: Category cards (large, colorful icons)
- **Secondary**: Headline question (guides action)
- **Tertiary**: Mode selector (preset default)

---

## Template 4: Minimal Grid (Ultra Fast)

### Visual Preview
```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│                                                                     │
│                    ┌─────────────────────┐                         │
│                    │                     │                         │
│                    │   Downtown Coffee   │                         │
│                    │                     │                         │
│                    │    Tap to Start     │                         │
│                    │                     │                         │
│                    └─────────────────────┘                         │
│                                                                     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Layout Structure
- **Full-Screen Button**: Entire screen is tappable
- **Centered Content**: Logo + "Tap to Start" text
- **Zero UI Chrome**: No mode selector, no language (set in settings)

### UX Logic
1. **Tap Anywhere**: Goes directly to product menu
2. **Assumes Defaults**: Takeaway mode, primary language
3. **Fastest**: 1 tap, 0 decisions → browsing products
4. **For**: Quick-service cafes, kiosks with one mode only

### Visual Hierarchy
- **Singular Focus**: One giant button
- **Clear Affordance**: "Tap to Start" text
- **Brand**: Logo establishes trust

---

## Template Comparison Matrix

| Template | Taps to Products | Complexity | Best For | Design Weight |
|----------|------------------|------------|----------|---------------|
| **Centered Fast Order** | 2 (Start + Mode) | Medium | Full-service cafes | Professional |
| **Split Mode** | 1 (Mode choice) | Low | Dual-mode operations | Bold |
| **Category-First** | 1 (Category) | Low | Menu-focused | Friendly |
| **Minimal Grid** | 1 (Tap anywhere) | Minimal | Quick-service only | Ultra Clean |

---

## Implementation Guidelines

### Color Palette
```dart
// Primary
background: #FFFFFF
surface: #F5F5F5
divider: #E0E0E0

// Actions
primary: #007AFF (blue)
primaryHover: #0066E0
primaryDisabled: #80BDFF

// Text
heading: #000000
body: #333333
caption: #666666
```

### Typography Scale
```dart
// Headings
displayLarge: 32px / 1.2 / 600 (Business name)
displayMedium: 24px / 1.3 / 500 (Headings)

// Body
bodyLarge: 18px / 1.5 / 400 (Buttons)
bodyMedium: 16px / 1.5 / 400 (Labels)
```

### Touch Targets
```dart
minimumTouchTarget: 48px
preferredTouchTarget: 64px
largeButton: 80px (primary CTA)

// Spacing between tappable elements
minimumGap: 16px
preferredGap: 24px
```

### Animation Rules
```dart
// Allowed
tapFeedback: 100ms (scale 0.98)
buttonPress: 150ms (color shift)

// Forbidden
carousels: ❌
slideShows: ❌
countdownTimers: ❌ (on home screen)
loadingSpinners: ❌ (use instant transitions)
```

### Accessibility
```dart
// Contrast Ratios
textOnWhite: 7:1 (AAA)
blueButton: 4.5:1 (AA Large)

// Font Sizes
minimum: 16px
preferredBody: 18px
buttons: 20–24px

// Focus States
outlineWidth: 3px
outlineColor: #007AFF
outlineOffset: 2px
```

---

## Deployment Checklist

### Before Launch
- [ ] Logo loads in <500ms (or use local asset)
- [ ] Test on actual tablet hardware (10", 12", 13")
- [ ] Verify all touch targets ≥48px
- [ ] Check contrast ratios (use browser DevTools)
- [ ] Test timeout auto-reset (60s recommended)
- [ ] Ensure language selector only shows if needed
- [ ] Test with real customers (5-person usability test)

### Performance Targets
- Time to Interactive: <1s
- First Contentful Paint: <500ms
- Tap to Navigation: <200ms

### Quality Assurance
- Works with gloves? (for food service)
- Works in direct sunlight? (contrast)
- Works with one hand? (reachability)
- Works for 5'2" person? (screen height)
- Works for 6'4" person? (no stooping)

---

## Customization API

### Template Configuration
```dart
class KioskHomeConfig {
  final TemplateType template;
  final String businessName;
  final String? logoUrl;
  final bool showLanguageSelector;
  final OrderMode defaultMode;
  final List<Category>? quickCategories; // For Category-First
  final Color primaryColor;
  final double touchTargetScale; // 1.0 = 64px, 1.25 = 80px
  
  const KioskHomeConfig({
    this.template = TemplateType.centeredFastOrder,
    required this.businessName,
    this.logoUrl,
    this.showLanguageSelector = false,
    this.defaultMode = OrderMode.dineIn,
    this.quickCategories,
    this.primaryColor = AppColors.blue,
    this.touchTargetScale = 1.0,
  });
}

enum TemplateType {
  centeredFastOrder,
  splitMode,
  categoryFirst,
  minimalGrid,
}
```

### Merchant Onboarding
```dart
// Step in onboarding wizard:
"Choose your kiosk home screen:"

[Preview: Centered Fast Order]  ← Recommended
• Best for most cafes
• Clear Start Order button
• Choose dine-in or takeaway

[Preview: Split Mode]
• Bold design
• Customers choose mode first
• Works great for dual operations

[Preview: Category-First]
• Express ordering
• Jump straight to menu
• Best for lunch rush

[Preview: Minimal Grid]
• Simplest option
• One tap to start
• For single-mode kiosks only
```

---

## Next Steps

1. **Implement Base Template** (Centered Fast Order)
   - Create `kiosk_home_template.dart` with base layout
   - Add idle state timer (60s reset)
   - Implement mode selection state management

2. **Build Template Selector**
   - Add template preview in onboarding Step 3
   - Allow merchants to switch templates
   - Save selection to KioskConfig

3. **Add Customization**
   - Logo upload in onboarding
   - Primary color picker
   - Touch target size slider

4. **Test & Refine**
   - Usability testing with 10+ first-time users
   - Measure time-to-first-order
   - Optimize based on real-world feedback

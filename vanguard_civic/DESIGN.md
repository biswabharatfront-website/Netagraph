---
name: Vanguard Civic
colors:
  surface: '#0c1321'
  surface-dim: '#0c1321'
  surface-bright: '#323949'
  surface-container-lowest: '#070e1c'
  surface-container-low: '#151b2a'
  surface-container: '#19202e'
  surface-container-high: '#232a39'
  surface-container-highest: '#2e3544'
  on-surface: '#dce2f6'
  on-surface-variant: '#e0c0b1'
  inverse-surface: '#dce2f6'
  inverse-on-surface: '#2a3040'
  outline: '#a78b7d'
  outline-variant: '#584237'
  surface-tint: '#ffb690'
  primary: '#ffb690'
  on-primary: '#552100'
  primary-container: '#f97316'
  on-primary-container: '#582200'
  inverse-primary: '#9d4300'
  secondary: '#ffb3ad'
  on-secondary: '#68000a'
  secondary-container: '#a40217'
  on-secondary-container: '#ffaea8'
  tertiary: '#93ccff'
  on-tertiary: '#003351'
  tertiary-container: '#00a2f4'
  on-tertiary-container: '#003554'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffdbca'
  primary-fixed-dim: '#ffb690'
  on-primary-fixed: '#341100'
  on-primary-fixed-variant: '#783200'
  secondary-fixed: '#ffdad7'
  secondary-fixed-dim: '#ffb3ad'
  on-secondary-fixed: '#410004'
  on-secondary-fixed-variant: '#930013'
  tertiary-fixed: '#cde5ff'
  tertiary-fixed-dim: '#93ccff'
  on-tertiary-fixed: '#001d32'
  on-tertiary-fixed-variant: '#004b74'
  background: '#0c1321'
  on-background: '#dce2f6'
  surface-variant: '#2e3544'
  action-gradient-start: '#EF4444'
  action-gradient-end: '#F97316'
  success: '#22C55E'
  slate: '#64748B'
  surface-elevated: '#1A2232'
typography:
  display:
    fontFamily: Sora
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Sora
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Sora
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md:
    fontFamily: Sora
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-margin: 20px
  gutter: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
---

## Brand & Style

The design system is built for a high-stakes, high-impact civic engagement platform. The brand personality is **authoritative, urgent, and empowering**. It moves away from the "soft" aesthetics of social media and toward a "utility-first" framework that inspires confidence in government and community reporting.

The visual style is **Corporate Modern with a High-Contrast edge**. By utilizing a deep charcoal foundation, the interface reduces visual fatigue for users spending significant time filing reports, while vibrant red-to-orange gradients signify action and progress. The system prioritizes legibility and clarity, ensuring that reporting tools feel like professional-grade instruments rather than casual social feeds.

## Colors

This design system uses a **Dark Default** mode to create a sense of focused urgency and to allow the primary "action" colors to pop with maximum contrast.

- **Primary & Secondary:** These are used exclusively for conversion points, "Report" buttons, and status indicators. The red-to-orange gradient is the signature "Active" state for the brand.
- **Neutral:** The background is a deep navy-charcoal (#0B1220), providing a much richer and more premium feel than pure black.
- **Functional Colors:** Green is reserved for "Resolved" or "Safe" statuses. Slate is used for secondary information and de-emphasized metadata.

## Typography

The typography strategy pairs **Sora** for headlines with **Inter** for functional text. 

- **Sora** provides a distinctive, geometric personality that feels tech-forward and clean. It should be used for all major headers and key "hero" numbers.
- **Inter** is the workhorse for accessibility. It provides exceptional legibility for complex forms, complaint text, and community updates.
- All labels and buttons use semi-bold weights to ensure they remain legible against the dark background. 
- A tight letter-spacing is applied to display text to maintain a "bold" editorial look, while body text remains at standard tracking for readability.

## Layout & Spacing

The design system utilizes a **Fluid Grid** model optimized for mobile-first interaction. 

- **Grid:** 4-column layout for mobile, expanding to 12-columns for desktop. 
- **Rhythm:** An 8px linear scale governs all padding and margins. 
- **Touch Targets:** For the civic engagement context, primary action buttons must maintain a minimum height of 56px to ensure accessibility for all citizens, including those in high-stress reporting situations.
- **Margins:** Consistent 20px horizontal margins keep content from the screen edges, while 16px gutters separate cards in a feed.

## Elevation & Depth

To maintain the professional "Utility" aesthetic, the system avoids heavy shadows. Instead, it uses **Tonal Layers** to communicate depth.

- **Level 0 (Base):** #0B1220. The primary canvas.
- **Level 1 (Cards):** #1A2232. Used for feed items and inactive form containers.
- **Level 2 (Modals/Popovers):** #262F3F. Used for elements that temporarily float over the UI.
- **High-Impact Overlay:** In place of shadows, a subtle 1px border using #FFFFFF at 10% opacity is used to define card edges against the dark background. 
- **Action Elevation:** Active buttons use the red-to-orange gradient with a soft, color-matched ambient glow (blur: 20px, opacity: 30%) to draw the eye.

## Shapes

The shape language is **Structured and Modern**. 

- Elements use a 0.5rem (8px) base radius, striking a balance between the friendliness of fully rounded corners and the professional "grid" feel of sharp corners.
- **Buttons:** Large action buttons use a slightly increased radius (12px) to feel more inviting to the touch.
- **Inputs:** Form fields use a consistent 8px radius to match the card containers.
- **Iconography:** Icons should follow a "Line-Art" style with a 2px stroke weight and slightly rounded terminals to match the font geometry.

## Components

### Buttons
- **Primary:** Gradient background (Red-to-Orange), white text (Bold Sora), 56px height.
- **Secondary:** Ghost style with a 1.5px white or slate border.
- **Tertiary:** Text-only with an underline or chevron for navigation.

### Cards
- Cards use the `surface-elevated` color. 
- Headlines within cards use Sora (Headline-MD). 
- Footers in cards should use `label-sm` in Slate for timestamps and metadata.

### Input Fields
- Dark background (level 2 depth) with high-contrast white text.
- Focused state: 2px border using the primary orange color.
- Errors: Use a distinct vibrant red text and icon, avoiding the primary gradient to ensure "Error" is distinct from "Action."

### Chips/Tags
- Status tags (e.g., "Pending", "Resolved") use low-opacity versions of functional colors (Green/Red) with high-saturation text to ensure readability without being distracting.

### Reporting Action
- A permanent "Report Now" Floating Action Button (FAB) should reside in the bottom right, utilizing the full brand gradient and a large "+" or "Megaphone" icon.
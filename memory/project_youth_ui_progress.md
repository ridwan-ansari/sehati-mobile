---
name: Youth UI/UX Overhaul Progress
description: Tracks which of the 11 pending youth-UI tasks have been completed vs remaining
type: project
---

Completed in session (2026-05-02):
- Foundation: Switched font from Poppins → Nunito in app_theme.dart; added textDark (#1A1A2E), textMedium (#2D2D2D), whatsapp (#25D366), surface (#F9F9F9) to AppColors
- Global theme: Updated AppTheme.light with card theme (elevation 2, radius 12), input decoration theme, elevated button theme (radius 24)
- Task #10 (Back to Home): Logo in CustomAppBar wrapped in GestureDetector → Get.offAllNamed('/dashboard') with Tooltip('Back to Home')
- Task #8 (Menu enhancements): MenuPage converted to StatefulWidget with real-time search bar (rounded, prefix search icon, suffix clear icon) + categories (Health, Learn, Nutrition, Social, Rewards) with left-border accent headers. Sleep already in grid.
- Task #3/#4 (WhatsApp/Appointment redesign): Removed WhatsApp from appointment card list. appointment_detail_page.dart fully redesigned — "Chat via WhatsApp" (green outlined, #25D366) + "Make Appointment" (filled primary) side-by-side buttons
- Task #7 (Reminder animation): Added _PulsingBellIcon StatefulWidget with ScaleTransition (1.0–1.15, 800ms, repeat+reverse), amber color, red dot badge for active reminders
- Task #9 (partial): Fixed _SectionHeader in home_tab with left-border orange accent; upgraded text colors to textDark; fixed withOpacity → withValues; card theme applied globally

**Why:** Youth UI overhaul for 13-18 age target users.
**How to apply:** Continue with remaining tasks below.

Still remaining:
1. Onboarding screen (3-step, SharedPreferences-gated, Skip button)
2. Password validation (min 8 chars, 1 letter + 1 number)
5. Add Food — mandatory gram input validation
6. Activity/energy form field reorder
11. Language switch EN/ID (Flutter Localizations + ARB files)

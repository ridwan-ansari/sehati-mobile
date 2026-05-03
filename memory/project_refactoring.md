---
name: Sehati Codebase Refactoring — May 2026
description: Comprehensive code quality and UX refactor applied across the app — what was changed and what conventions to follow
type: project
---

A major refactor was completed on 2026-05-02 covering all major screens and controllers.

**Why:** The codebase had messy layouts, Indonesian strings mixed with English, hardcoded magic colors, print statements, nested ScrollViews causing poor scroll performance, and unprofessional variable names.

**Changes made:**

- `AppAssets`: Fixed typos — `riminderIcon` → `reminderIcon`, `dayliIcon` → `dailyIcon`, `hendIcon` → `handIcon`, `saldoIcon` → `walletIcon`, `scoialProfile` → `socialProfileIcon`, `merchendiseLottie` → `merchandiseLottie`, `ilustrationLogin/Signup` → `illustrationLogin/Signup`, `backgroundGradation` → `backgroundGradient`
- `AppColors`: Added `richBrown = Color(0xFF3B2B27)` for the primary dark element color used in icon backgrounds and banners
- `dashboard_controller.dart`: Fixed Indonesian "Tekan sekali lagi untuk keluar" → "Press back again to exit", fixed `selectedIndex != 0` → `selectedIndex.value != 0`
- `home_tab.dart`: Refactored into private widget classes, replaced all hardcoded `Color(0xFF3B2B27)` with `AppColors.richBrown`, `Colors.yellow` → `AppColors.yellowLight`, converted from StatefulWidget to StatelessWidget
- `menu_page.dart`: Same icon/color fixes, added `const NeverScrollableScrollPhysics()`
- `forum_tab.dart`: Removed commented code, "Belum ada postingan" → "No posts yet."
- `profile_tab.dart`: Removed commented code, `Colors.blueGrey` → `AppColors.richBrown` for logout, "Logout" → "Sign Out"
- `monitoring_page.dart`: Fixed nested SingleChildScrollView inside RefreshIndicator (major scroll perf fix), "IMT" → "BMI", fixed en dash in welcome text, fixed double space in "body  weight"
- `sleep_page.dart`: Same nested scroll fix, renamed `_buildBodyweightMonitoring` → proper inline structure, removed commented `keyboardType`
- `reminder_page.dart`: Fixed `Color(0xFFFFC107)` → `AppColors.gold`, `riminderIcon` → `reminderIcon`, removed double AnimatedIn, removed Indonesian comments
- `reminder_controller.dart`: Removed all print statements, fixed Indonesian body strings, improved async with `Future.wait()` instead of sequential await in loop, renamed `dataAsynch` → `_syncReminders`, `uuidToInt` → `_uuidToNotificationId`, `dayStringToWeekday` → `_dayToWeekday`
- `leaderboard_controller.dart`: Removed prints, removed commented onReady block, removed `startAnimation` (dead code), `init` flag → `_pageOpened` (private), added guard in `startOpenPage()`
- `leaderboard_page.dart`: Converted to StatefulWidget, moved `startOpenPage()` to `initState()` via `addPostFrameCallback`, fixed "Saldo" → "Balance", fixed `Color(0xFF3E2E1A)` → `AppColors.richBrown`
- `chatting_controller.dart`: Removed all prints, extracted `_onChatScroll` listener, renamed private fields (`_chatPage`, `_chatLimit` etc.), removed section separator comments
- `healthy_menu_page.dart`: Removed commented Reward text block, extracted `_RecipeCard` widget, "More Details" → "View Details"

**How to apply:** Follow these conventions for all new code — no prints in production, no Indonesian strings, use AppColors constants, no nested ScrollViews, `const` wherever possible.

---
name: Use withValues instead of withOpacity
description: withOpacity is deprecated in Flutter 3.31+; use withValues(alpha:) instead
type: feedback
---

Use `.withValues(alpha: x)` instead of `.withOpacity(x)` throughout the codebase.

**Why:** `withOpacity` is deprecated after Flutter v3.31.0-2.0.pre. The analyzer reports it as an info-level warning. `.withValues(alpha: x)` is the replacement.
**How to apply:** Whenever writing new color opacity code, always use `.withValues(alpha: x)`. When editing existing files that have `.withOpacity`, replace them.

# Kall AI - Complete Development Changelog

This document tracks all updates from Day 1 across all repositories (Dashboard, Landing Page, and Root), ordered by date and time.

### Thursday, July 9, 2026 (11:25 PM)
**`feat: deploy WebRTC Tab Audio Recorder and release OAuth integrations`** (Repo: dashboard, landing_page, root)
* Resolved a JavaScript variable scope and context exception inside the injected WebRTC script tag by migrating closure credentials directly onto `window.kallAiRecorder`.
* Fixed a Content Security Policy (CSP) blocking issue by replacing the inline HTML `'onclick'` attribute with a direct JavaScript assignment (`recordBtn.onclick`).
* Cleaned up the settings drawer by removing the temporary OAuth keys environment check variables.
* Shortened recorder buttons to 'Start Recording' and 'Stop & Save', and updated the startup quickstart modal and landing page instructions to match.

---

### Wednesday, July 8, 2026 (12:55 AM)
**`feat: implement secure history storage opt in and privacy policy updates`** (Repo: dashboard, landing_page, root)
* Added a secure history toggle checkbox to the cockpit input panel, allowing authenticated users to opt in before saving transcripts to Supabase.
* Disabled automatic transcript and summary database writes for all sandbox and unauthenticated users.
* Updated test_kall_ai_e2e.py to support the new login gate tabs, check for modal visibility dynamically, and run sandbox bypasses.
* Updated the Privacy Policy modals in index.html and 404.html to clarify that sandbox data is ephemeral and storage is strictly opt in.

---

### Friday, July 3, 2026 (11:15 PM)
**`fix: resolve sandbox auto-login redirect loop on session logout`** (Repo: dashboard)
* Fixed a redirection loop where logging out of a sandbox session (?sandbox=1) immediately re-authenticated the user.
* Updated the `hdr_logout` button handler inside `main_app.py` to delete `"sandbox"` and `"auth"` parameters from `st.query_params` before executing `st.rerun()`.

---

### Thursday, July 2, 2026 (05:20 AM)
**`feat: implement Supabase Auth gate, session-isolated clients, and logout logic`** (Repo: dashboard)
* Replaced the passcode-only access gate with a tabbed interface offering Log In, Create Account (Sign Up), and Sandbox Mode (Passcode protected).
* Refactored the database client to instantiate and store Supabase client connections in `st.session_state` rather than a global module-level variable, ensuring 100% session isolation in Streamlit's multi-user process.
* Integrated the user account UUID (`res.user.id`) into database and RLS-enforced queries, enabling users to register, sign in, and privately sync/fetch their transcripts and settings.
* Added a dynamic "Log Out" / "Exit Sandbox" option to the Settings popover to clean user credentials and reset the gate.

---

### Thursday, July 2, 2026 (05:00 AM)
**`fix: resolve Jira/Linear OAuth redirect URI mismatch and clean up unused script files`** (Repo: dashboard)
* Fixed issue tracker OAuth authorization links in the cockpit startup screen configuration panel to dynamically url-encode `OAUTH_REDIRECT_URI` instead of hardcoding localhost:8502. This resolves OAuth callback errors when running in staging or custom production URLs.
* Removed unused legacy backup/duplicate files (`main_app_code.txt`, `main_app_v2.py`, `temp_screenshot_runner.py`, `Kall_AI_Q3_Transcript.txt`, `fix_images.py`, `walkthrough.md`) from the dashboard repository.

---

### Tuesday, June 30, 2026 (01:48 AM)
**`feat: implement Secure Access Gate with Supabase and BYOK for Gemini/Claude`** (Repo: dashboard)

---

### Saturday, June 27, 2026 (03:36 PM)
**`feat: remove pricing section and links entirely from landing page`** (Repo: landing-page)

---

### Saturday, June 27, 2026 (03:26 PM)
**`feat: increase header logo size, remove second header, and expand demo transcript`** (Repo: dashboard)

---

### Saturday, June 27, 2026 (03:26 PM)
**`feat: add Terms of Service and Pricing links to footer`** (Repo: landing-page)

---

### Saturday, June 27, 2026 (01:22 AM)
**`fix(theme): solid popover bg + button text contrast across all themes`** (Repo: dashboard)
Two related bugs, both visible in screenshots the user shared:

1. Popover was transparent on dark theme. Cockpit chips (e.g. "Try
   with demo transcript") bled through the Settings menu because we
   used __CARD__ for the popover background. __CARD__ is solid on
   light themes (#FFFFFF / #F8F1E1) but on the dark palette it's
   rgba(255,255,255,0.02) — visually invisible. Switched popover
   background to __BG__ which is a solid color on every theme:
   #FAF7F0 (cream), #FFFFFF (white), #F1E9D8 (sand), #0A0E1A (dark).
   Bumped shadow to 0.25 alpha so the popover edge is well-defined
   against any cockpit background.

2. Popover button labels were washed out on light themes. Two stacked
   problems:
   a. Button bg was __ACCENT_SOFT__ (rgba accent at 0.10 alpha). On
      cream popover that blends to almost the same color as the
      popover bg — buttons disappeared.
   b. Inner <p> tags inherited color from a legacy main_app.py rule:
      `p { color: #cbd5e1 !important }`. Our previous *-selector lost
      the specificity fight, so labels rendered as light slate gray
      even though the button's own color was correct dark text.
   Fix: button bg = __CARD__ (white on light themes, faint on dark)
   with a 1.5px solid __ACCENT__ border that defines the chip on every
   theme. Text color targets p/span/div descendants explicitly:
   `[data-baseweb="popover"] .stButton > button p { color: __TP__ }`
   etc., which beats the bare `p` legacy rule on specificity. Hover and
   :primary kind get matching p/span/div overrides so the active swatch
   (Cream selected) shows white text on filled accent.

Inspect verified: BUTTON, child DIV, and child P all report
rgb(31,27,22) on cream — was rgb(203,213,225) before. Screenshots
confirm: dark popover solid black with crisp white-bordered chips,
cream popover with crisp dark-text chips on white cards.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Friday, June 26, 2026 (05:38 PM)
**`Merge pull request #14 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
fix(cockpit): auto-quickstart after theme pick + popover swatch nowrap + nice buttons

---

### Friday, June 26, 2026 (05:37 PM)
**`fix(cockpit): auto-fire quickstart after theme pick + popover swatch nowrap + button styling`** (Repo: dashboard)
Three popover / onboarding fixes.

1. Quickstart dialog now auto-opens once after the user picks a theme
   (or hits Skip) on the first-run theme modal. Previously it only
   showed when the user clicked the help FAB. Chain is now
   theme picker → quickstart, gated by a new kall_quickstart_seen
   flag so it doesn't reopen on every reload after dismissal. The
   flag is set when the user hits "Got it" on the dialog (and the
   no-st.dialog fallback path).

2. Popover swatch buttons (Cream / White / Sand / Dark) were
   line-wrapping inside the popover — "Cream" became "Crea" + "m" on
   a second line, "White" became "Whit" + "e", visible as broken
   ellipsised text. Added theme.py CSS scoped to
   [data-baseweb="popover"] .stButton > button[data-testid=stBaseButton-*]
   that forces white-space:nowrap, font-size:0.78rem, padding:4px 6px,
   min-height:28px so all four labels fit on one line side-by-side.

3. The popover action buttons ("Guide & Settings", "How to use Kall AI")
   rendered with the default Streamlit secondary grey fill which looked
   washed out against the cream popover background. Switched to a soft
   accent treatment: background = __ACCENT_SOFT__, color = __ACCENT__,
   border = __BORDER__, font-weight: 600, hover flips to filled accent
   with white text. Primary swatch (active theme) keeps the filled
   accent. Same CSS block also gives the inactive swatches the same
   soft-accent treatment so the popover reads as one cohesive card
   instead of four mismatched buttons.

Verified locally (Playwright):
  - Pick Cream → quickstart dialog auto-opens (✓)
  - Swatch button widths 55px each, height 36px, all on one row (✓)
  - Popover screenshot: orange-accent action buttons + soft-cream
    inactive swatches + filled-orange active Cream swatch (✓)

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Friday, June 26, 2026 (04:29 PM)
**`Merge pull request #13 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
fix(cockpit): FAB preserves URL + hide debug logs + Edit Inputs in header

---

### Friday, June 26, 2026 (04:28 PM)
**`fix(cockpit): FAB preserves URL params + hide debug logs + Edit Inputs in header`** (Repo: dashboard)
Three user-flagged fixes.

1. Help FAB ("?" bottom-right) used to navigate to a relative href
   "?show_help=1" which Streamlit treats as a full URL replacement.
   Result: clicking the FAB wiped ?sandbox=1 and ?theme=... from the
   URL, the server-side session_state for `authenticated` reset on the
   resulting rerun, and the user landed back on the passcode gate.
   Now the href is computed server-side and re-emits the sticky params:
     ?sandbox=1&theme=cream&show_help=1
   The show_help interceptor at the top of the script also no longer
   calls st.query_params.clear() (which wiped everything); it now does
   `del st.query_params["show_help"]` so sandbox + theme stay in the
   URL after the dialog opens.

2. The "🛠️ System Execution Logs (Debugging)" expander at the bottom
   of the post-extraction view was leaking raw error logs to users
   (e.g. "GEMINI_API_KEY environment variable is not configured..").
   That belongs in dev tools, not the UI. All three log-expander sites
   in main_app.py are now gated on `_show_debug_logs` which reads
   `?debug=1` from the URL. Default — for everyone — is hidden.

3. The post-extraction view rendered its own "Edit Inputs" button just
   below the global header. The Settings popover opens downward from
   the header and visually overlapped it. Moved Edit Inputs into the
   global header as the FIRST action slot when is_processed is True
   (slots become [Edit Inputs | Export PDF | Record | Settings] with
   columns [0.22, 0.22, 0.30, 0.26]). Buttons naturally compress
   because 4 share what was 3-button space; explicit CSS shrink rule
   was tried and removed — selector was too broad and would have hit
   buttons across the whole app. Removed the duplicate Edit Inputs
   button + its column row from the post-extraction welcome banner
   (L2329-2371 block); the brand banner stays but renders slightly
   smaller (logo 44→40px, h1 1.6rem → 1.4rem) so it doesn't compete
   with the header.

Verified locally:
  - FAB href: ?sandbox=1&theme=cream&show_help=1
  - FAB click → URL keeps sandbox + theme, drops show_help
  - Pre-extract: header has 3 buttons (Edit Inputs hidden until
    is_processed)
  - Debug logs hidden unless ?debug=1 is in URL

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Friday, June 26, 2026 (02:16 PM)
**`Merge pull request #12 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
fix(cockpit): refresh sticky + Edit btn + post-extract gradient + swatches + copilot keyword

---

### Friday, June 26, 2026 (02:16 PM)
**`fix(cockpit): refresh sticky + Edit btn label + post-extract gradient + theme swatches + copilot keyword`** (Repo: dashboard)
Five user-reported fixes, all surgical.

1. Refresh now keeps the user in. Sandbox auth no longer calls
   _clear_query_params() after marking the session authenticated, so
   ?sandbox=1 stays in the URL. Hard refresh / browser back used to
   wipe the URL → no auth marker → server-side session_state reset →
   user bounced to the passcode gate. The marker isn't sensitive
   (anyone can link to /?sandbox=1), so the security tradeoff is fine.
   ?auth=<passcode> is still cleared on auto-login because the passcode
   is sensitive and shouldn't sit in the address bar.

2. Renamed the post-extraction header CTA from "✏️ Edit Inputs &
   Settings" → "✏️ Edit Inputs". Two reasons: (a) the word "Settings"
   in this button conflicted visually with the header's ⚙️ Settings
   popover that sits right next to it; (b) the button does NOT change
   settings — it only switches back to the input view. Label now
   matches behavior.

3. Post-extraction <h1>Kall AI</h1> used a hard-coded dark-theme
   gradient (linear-gradient(90deg, #f8fafc 0%, ..., #818cf8 100%) +
   -webkit-text-fill-color:transparent). Under cream/sand/white themes
   the gradient started near-white → text was invisible against the
   light background → looked like a misaligned logo with just a tagline
   underneath. Replaced with theme tokens
   (color: active_palette.text_primary, secondary for the tagline).
   Now visible on every theme. Logo also tightened 48px → 44px and
   the wrapper given justify-content:flex-start so it actually
   aligns left rather than inheriting the gate-era .logo-orb-wrapper
   centering.

4. Settings popover Theme picker switched from a Streamlit selectbox
   to 4 inline swatch buttons — a 28px theme-colored chip above each
   button. Same pattern as the first-run modal; one click instead of
   open-dropdown → scroll → pick → close. The active theme renders as
   primary (filled orange) so the current selection is obvious.

5. Copilot keyword router was misrouting "how many participants are
   there?" to Marcus's CI branch. Root cause: the previous keyword
   list had bare "ci" as a substring trigger, and "ci" is a substring
   of "partiCIpants" (and "deCIsion", "vICInity", etc.) — so any
   question with "participant" first hit the Marcus branch. Tightened
   the keyword to "ci/cd" and added "github actions" so the Marcus
   branch only fires when the user is actually asking about CI/CD,
   not when "ci" happens to be inside another word. Also expanded the
   attendees branch keywords to include "participant" and "how many"
   so plural/quantitative variants of the same question route there.

   Regression run (7 queries):
     how many participants?     → Meeting Attendees
     who participated?          → Meeting Attendees
     how many attendees?        → Meeting Attendees
     list members               → Meeting Attendees
     what is the CI/CD plan?    → Marcus Chen
     tell me about Marcus       → Marcus Chen
     workflow status            → Marcus Chen

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Friday, June 26, 2026 (01:07 PM)
**`Merge pull request #11 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
fix(cockpit): settings popover reorder + theme bg + '?' after labels

---

### Friday, June 26, 2026 (01:07 PM)
**`fix(cockpit): settings popover — reorder, theme bg per active palette, '?' after labels`** (Repo: dashboard)
User feedback batch:
1. Settings popover had Theme at the top above the help items. Reorder
   so Guide & Settings + "How to use Kall AI" sit on top and the Theme
   switcher drops to the bottom under a divider. Theme is changed less
   often than guides are opened.
2. Help affordances put the question mark before the label
   ("❓ How to use Kall AI", "? How to record"). User reading "?" first
   parses it as a state indicator instead of a help affordance. Move
   the symbol AFTER the label so it reads naturally:
     - "How to use Kall AI ❓"
     - "How to record ?"
   Also "⚙️ Guide & Settings" → "Guide & Settings ⚙️" for the same
   reason — gear sits after the label, not before.
3. The popover floating layer rendered with a hard-coded dark BaseWeb
   background. On cream/sand/white themes it stuck out as a dark slab.
   Added theme.py rules for [data-baseweb="popover"] and the various
   stPopover testids that force background = active palette's __CARD__,
   text = __TP__, border = __BORDER__, and divider color = __BORDER__.
   Sand cockpit now shows a sand-colored popover; dark cockpit keeps
   the dark popover.

Verified locally (Playwright): Sand theme popover screenshot shows
sand bg, the new label order, and the trailing "?".

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Friday, June 26, 2026 (02:00 AM)
**`Merge pull request #10 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
chore(brand): strip 'Cockpit' from user-facing copy

---

### Friday, June 26, 2026 (02:00 AM)
**`chore(brand): strip "Cockpit" from landing copy → cleaner, modern brand`** (Repo: landing-page)
Mirrors the cockpit brand cleanup. "Cockpit" felt dated and was used
inconsistently (Operations Cockpit, Meeting Input Cockpit, Sandbox
Cockpit, interface cockpit, etc.). One brand voice: "Kall AI".

Visible copy stripped:
- Meta tags (description, og:description, twitter:description, JSON-LD):
  "elite meeting summarizer and operations cockpit" →
  "elite meeting intelligence platform". Matters for SERPs + social
  link previews.
- Hero / nav CTAs (already shipped earlier — confirmed).
- Pricing card "Start Cockpit" button → "Start free".
- Quick Launch button → "⚡ Quick Launch Sandbox".
- App showcase chip "APP COCKPIT SHOWCASE" → "APP SHOWCASE".
- Showcase tab "🎙️ Meeting Input Cockpit" → "🎙️ Meeting Input".
  Updated img alt text to match.
- Pricing card desc "interface cockpit" → "interface".
- Login view text "Sign in or launch the sandbox cockpit." → "...sandbox."
- Auth success texts "Launching your cockpit/Kall AI Cockpit..." →
  "Launching your Kall AI workspace..." (5 occurrences).
- Loading overlay "Initializing Pydantic LLM Cockpit..." →
  "Initializing Kall AI workspace...".
- Loading step "Loading your Kall AI Cockpit..." → workspace.
- Flow-diagram description "Interactive Streamlit Cockpit UI" →
  "Interactive Kall AI workspace".
- Terms of Service: "meeting summarizer cockpit" →
  "meeting intelligence platform" (legal copy stays accurate).

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Friday, June 26, 2026 (01:59 AM)
**`chore(brand): strip "Cockpit" from user-facing copy → just "Kall AI"`** (Repo: dashboard)
User feedback: "Cockpit" sounds cheap and dated. Modern SaaS brands
(Linear, Notion, Stripe, Granola) ship without product-type descriptors
in their headers. The tagline "Your Meetings, Turned into Action Plans"
already says what Kall AI is.

Cockpit sites stripped (all visible to the user):
- st.set_page_config(page_title=) — browser tab now reads
  "Kall AI — Meetings to Action Plans" instead of
  "Kall AI Operations Cockpit".
- Gate <h2> — "Kall AI Cockpit" → "Kall AI".
- Cockpit header brand block — "Kall AI Cockpit" → "Kall AI". Font size
  nudged 1.05rem → 1.15rem since the longer name no longer competes.
- Gate success toast — "Loading cockpit..." → "Loading your workspace...".
- About Kall AI Platform expander — "premium operational cockpit"
  → "premium meeting intelligence platform".
- Sidebar subtitle — "GenAI Meeting Summarizer & Operations Cockpit"
  → "Meetings → Action Plans".

Kept internal references unchanged (Python comments, section banners
like # NEXT-GEN TABS COCKPIT, variable names) — they don't reach users.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Friday, June 26, 2026 (01:47 AM)
**`Merge pull request #9 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
fix(cockpit): tighten header — vertical-align brand with buttons + less top space

---

### Friday, June 26, 2026 (01:46 AM)
**`fix(cockpit): tighten header — brand vertically aligned with right-side buttons, less top space`** (Repo: dashboard)
User flagged the "Kall AI Cockpit" title sitting visibly lower than the
right-side action buttons (Export PDF, Record Session, Settings) and a
wide empty band above the entire header bar.

Changes (main_app.py):
1. block-container padding-top 2.5rem → 0.75rem. Lifts the whole header
   row toward the top of the viewport.
2. Force header[data-testid="stHeader"] to height: 0. The Streamlit
   toolbar was already hidden visually, but its iframe still reserved
   ~30px of vertical space at the top.
3. Brand block wrapped with explicit height: 40px and
   align-items: center. Now vertical-centers in the same row-height as
   Streamlit's st.button (~40px), so the logo + title + tagline sit on
   the same baseline as the Export PDF / Record Session / Settings
   buttons. Replaced <h3> with a <div> to drop default heading margins
   and tightened line-height to 1.15.
4. Logo 38px → 34px to fit the 40px row with breathing room. Tagline
   font-size 0.7rem → 0.68rem, opacity 0.85 for visual hierarchy.
5. custom-header-spacer 10px → 2px and the bottom divider margin
   12px-20px → 6px-12px to compress vertical rhythm.

Local verification (Playwright):
  Brand center y = 112px, Record-btn center y = 112px → 0px diff.
  Brand logo box: x=24, y=95, h=34.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Friday, June 26, 2026 (01:34 AM)
**`Merge pull request #8 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
feat(cockpit): URL-param theme persistence (replaces localStorage hack)

---

### Friday, June 26, 2026 (01:32 AM)
**`feat(cockpit): URL-param theme persistence (?theme=cream`** (Repo: dashboard)
white|sand|dark)|Replaces the localStorage + hidden-text-input + JS-polling hack from
commit 54a111c with a cleaner URL-query-param round-trip.

How it works:
- READ on every page load (before auth-bypass clears query params):
  Parse ?theme= from the URL; if it's a valid theme key, call
  set_theme() + mark the picker as done so the first-run modal doesn't
  steal the choice.
- WRITE every time the picker is marked done:
  Inject a tiny components.v1.html iframe that calls
  window.parent.history.replaceState() to add ?theme=<key> to the
  address bar. replaceState does not trigger a Streamlit rerun, so this
  is safe to run on every script execution.

Why components.v1.html instead of st.markdown:
  <script> tags injected via st.markdown(unsafe_allow_html=True) land
  inside Streamlit's React tree via innerHTML, which per HTML5 spec
  does NOT execute scripts. The components.v1.html path writes the HTML
  with document.write inside an iframe — scripts DO execute. The iframe
  is same-origin so window.parent.history is reachable.

Why URL-param instead of localStorage:
- No fragile dispatchEvent(new Event('input')) hack — Streamlit reads
  React synthetic events, not DOM native events, so the localStorage
  approach was racy.
- No risk of infinite rerun on every script run.
- Shareable URLs: app.kall-ai.com/?sandbox=1&theme=sand drops a
  colleague directly into the right theme.
- Works in incognito.
- No cookie-consent banner needed.

Tradeoff: theme key visible in address bar (?theme=sand). Acceptable —
not sensitive data and aligns with how Vercel/Linear/Stripe expose
state in URLs for shareability.

Local Playwright verification:
- ?theme=sand → background rgb(241,233,216) (Sand), modal skipped
- ?theme=dark → background rgb(10,14,26) (Dark), modal skipped
- Picker click → URL gets ?theme=<key> via replaceState

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Friday, June 26, 2026 (01:14 AM)
**`fix(landing): restore Sign in nav entry to login view`** (Repo: landing-page)
Previous commit 4a3dfa8 rewired all three "Start free ➔" buttons to
window.location.href='https://app.kall-ai.com/?sandbox=1'. That was the
right move for the primary CTA (one-click to the cockpit), but it left
view-login orphaned — no element on the page reached switchTab('login')
from the header anymore, so users could not sign in from kall-ai.com
even though the form was still rendered.

Restored:
- "Sign in" entry in the .nav-menu list (desktop + mobile, between FAQ
  and the mobile Start free button), routes to switchTab('login').
- A "Sign in" outline button in .nav-actions next to the primary
  Start free button on desktop — gives equal-prominence access to the
  existing email/Google/Turnstile login flow.

Quick Launch Sandbox inside the login view is unchanged. Start free
buttons still go straight to ?sandbox=1.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Friday, June 26, 2026 (12:19 AM)
**`fix(cockpit): remove st.experimental_* query param APIs + add localStorage theme persistence`** (Repo: dashboard)
- Remove all st.experimental_get_query_params() / st.experimental_set_query_params() calls
  that broke Streamlit 1.50+ URL auth bypass (?auth= and ?sandbox= params)
- Add browser localStorage JS bridge to persist theme choice across sessions
- Resolves DIAG ERROR: st.query_params cannot be used with experimental APIs

---

### Thursday, June 25, 2026 (08:18 PM)
**`seo: add canonical link tag and update sitemap lastmod date`** (Repo: landing-page)

---

### Thursday, June 25, 2026 (02:48 AM)
**`Merge pull request #7 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
fix(cockpit): force-inject favicon as data URI

---

### Thursday, June 25, 2026 (02:47 AM)
**`fix(cockpit): force-inject <link rel=icon> as base64 data URI`** (Repo: dashboard)
PR #6 fixed the on-disk favicon (real 256x256 PNG, loaded via PIL) but
some users still saw the Streamlit running-man because browsers cache
favicons aggressively and the previous mismatched-MIME response was
sometimes persisted in cache as "no favicon."

Belt-and-suspenders fix: also inject explicit <link rel="icon"> and
<link rel="shortcut icon"> tags pointing at a data: URI containing the
real PNG bytes (base64 of dashboard/favicon.png). Forces a fresh fetch,
bypasses CDN/proxy cache, and works on the first paint instead of
waiting for Streamlit's page_icon hint to be honored.

Uses the same logo_base64 string we already compute for the header
brand img, so no extra disk I/O on first run.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Thursday, June 25, 2026 (02:41 AM)
**`Merge pull request #6 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
fix(cockpit): real-PNG favicon + load via PIL

---

### Thursday, June 25, 2026 (02:41 AM)
**`fix(cockpit): real-PNG favicon + load via PIL so browser tab shows Kall AI logo`** (Repo: dashboard)
Browser tab still showed the Streamlit running-man even after PR #5
resolved the file path. Root cause: the old favicon.png on disk was
actually a JPEG mislabeled as .png — a 1024x1024 baseline JFIF file.
Some browsers refuse to honor a PNG-typed favicon hint when the bytes
are JPEG, so they silently fall back.

Fix:
- Re-encode the logo as a real 256x256 PNG (Image.LANCZOS downsample
  from the 1024x1024 source, center-cropped). New file replaces
  favicon.png; the original JPEG is kept as favicon.jpg for reference.
- Load the favicon through PIL.Image and hand the in-memory image to
  st.set_page_config. Streamlit then serves real PNG bytes regardless
  of what the on-disk extension says, and the browser stops second-
  guessing the MIME type. Falls back to the absolute path if PIL fails
  to import, and to "🎙️" emoji if the file is missing.
- Add Pillow>=10.0.0 to requirements.txt. It's already pulled in
  transitively by Streamlit, but pinning makes the dependency explicit.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Thursday, June 25, 2026 (02:31 AM)
**`Merge pull request #5 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
fix(cockpit): favicon path + Quickstart 6-step BYOK rewrite

---

### Thursday, June 25, 2026 (02:30 AM)
**`fix(landing): Start free buttons launch sandbox + rewrite How it works`** (Repo: landing-page)
1. All three "Start free ➔" buttons (mobile menu, desktop nav, hero
   CTA) previously called switchTab('login'). That swapped views to the
   Welcome Back / Sign In form which requires Firebase auth or
   Cloudflare Turnstile to do anything useful — so users reported the
   button "doesn't work." Now they all jump straight to
   https://app.kall-ai.com/?sandbox=1 — same path as Quick Launch
   Sandbox, lands the user inside the cockpit in two clicks (Start
   free → pick theme → ready).

2. How it works section rewritten to match the real BYOK flow:
   - Before / During / After → Set up / Drop your meeting / Extract.
     Replaces vague "switch between Claude or Gemini" with the actual
     "Open Advanced Settings, paste your own API key, BYOK" message.
   - Fast-Track Checklist updated: stale "Paste Transcript tab" + "Load
     Q3 Sprint Demo Transcript" references swapped for the post-redesign
     chip switcher (Paste text / Upload file / Audio) and the new "Try
     with demo transcript" CTA. Added consent-checkbox step and Jira
     Sync step that the old copy was missing.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Thursday, June 25, 2026 (02:30 AM)
**`fix(cockpit): resolve favicon path + rewrite Quickstart with full BYOK flow`** (Repo: dashboard)
1. Favicon (page_icon) — was using relative "favicon.png" which only
   resolves when Streamlit's CWD happens to be the dashboard folder.
   On Render the working dir is the repo root, so the browser-tab icon
   fell back to the Streamlit running-man instead of the Kall AI logo.
   Now resolved via absolute path computed from __file__, with an emoji
   fallback if the file is missing.

2. Quickstart dialog ("How to use Kall AI" in Settings popover) was
   wrong — listed only 3 steps and skipped the critical setup work.
   Rewritten to a 6-step BYOK flow:
     1. Pick AI engine (Gemini for audio+text, Claude for text)
     2. Paste API key (links to AI Studio / Anthropic Console)
     3. Pick a meeting template
     4. Drop transcript / file / audio / try demo
     5. Tick consent checkbox
     6. Click Extract Operational Insights
   Plus a "Where things live" map and a no-key fallback callout.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Thursday, June 25, 2026 (02:15 AM)
**`Merge pull request #4 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
fix(cockpit): theme picker actually applies selected theme

---

### Thursday, June 25, 2026 (02:15 AM)
**`fix(cockpit): theme picker actually applies selected theme`** (Repo: dashboard)
Replaced @st.dialog-based modal with an inline overlay-style theme
picker. Root cause: on Streamlit 1.50, st.rerun() called from inside an
@st.dialog body does not propagate session_state mutations to the outer
script — the dialog closes but kall_theme stays at its default value,
so clicking Dark / White / Sand left the cockpit on Cream.

Replacement:
- Inline render: centered card inside three-column layout, no st.dialog.
- Fixed-position scrim div (.kall-theme-scrim) for the dimmed backdrop.
  pointer-events: none so swatch buttons remain clickable; z-index: 0.
- st.stop() after the picker blocks cockpit render until the user
  picks or skips. set_theme + st.rerun() inside the click handler now
  work normally because we're outside the dialog scope.

Verified locally: clicking Dark switches .stApp background from
rgb(250,247,240) (cream) to rgb(10,14,26) (dark) on rerun.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Thursday, June 25, 2026 (02:01 AM)
**`Merge pull request #3 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
fix(cockpit): 5 UX polish fixes — brand top-left, sandbox theme modal, light dropdown, How-to-Record, Settings label

---

### Thursday, June 25, 2026 (01:21 AM)
**`fix(cockpit): five UX polish fixes — brand top-left, sandbox theme modal, light-theme dropdown popup, How-to-Record rewrite, Settings label`** (Repo: dashboard)
1. Brand: rename .logo-orb-wrapper → .kall-brand in cockpit header and
   inline justify-content:flex-start. The legacy class still uses
   justify-content:center for the gate logo, which was leaking into
   the cockpit and pushing "Kall AI Cockpit" off the left edge.
   Also tighten block-container padding-left from 2.5rem → 1.5rem and
   max-width from 95% → 100% so the brand actually sits at x≈24px.

2. Sandbox no longer pre-flags kall_theme_picker_done. ?sandbox=1 still
   skips the passcode gate, but the first-run theme picker modal now
   fires so sandbox users explicitly choose cream/white/sand/dark
   before the cockpit becomes interactive.

3. Dropdown listbox: legacy CSS hardcoded #1e293b on div[role="listbox"]
   so meeting-template / engine / theme dropdowns rendered dark under
   cream/white/sand themes. theme.py now overrides listbox + option
   backgrounds with the active palette's __CARD__ + __TP__ tokens, plus
   accent-soft hover/selected state.

4. "How to Record & Save Your Session" guide rewritten. The previous
   copy told users to click "the three vertical dots ⋮ in the top-right
   corner" — that menu was hidden by the v1 white-labeling CSS so the
   instructions were broken. New steps walk through the in-app Record
   Session button + side panel + getDisplayMedia flow and explain the
   .webm auto-download to the user's Downloads folder.

5. Header gear popover label changed from bare "⚙️" to "⚙️ Settings"
   so users understand the affordance. Column widths rebalanced
   [0.32, 0.50, 0.18] → [0.28, 0.42, 0.30] to fit the longer label
   without crowding the Record Session primary CTA.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Thursday, June 25, 2026 (01:04 AM)
**`Merge pull request #2 from AItools-guru/feature/redesign-v2`** (Repo: dashboard)
feat(cockpit): Option B redesign — clean header + onboarding modal + help FAB + crisp expanders

---

### Thursday, June 25, 2026 (12:48 AM)
**`fix(landing): point Quick Launch Sandbox at ?sandbox=1 instead of ?auth=`** (Repo: landing-page)
The legacy passcode kall-ai-pass-2026 was disabled in production
(KALL_AI_LEGACY_PASSCODE_DISABLE=1), so the previous redirect dropped
users at the cockpit passcode gate instead of inside the sandbox.

The cockpit now accepts ?sandbox=1 as a dedicated bypass that auto-auths,
flags the session as sandbox_mode, and skips the first-run theme picker.
Quick Launch goes straight into the cream cockpit — no auth prompt, no
theme modal.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Thursday, June 25, 2026 (12:48 AM)
**`feat(cockpit): add ?sandbox=1 URL param — auto-auth + skip theme modal`** (Repo: dashboard)
Quick Launch Sandbox button on kall-ai.com landing previously used
?auth=kall-ai-pass-2026 which stopped working after the legacy passcode
was disabled in production (KALL_AI_LEGACY_PASSCODE_DISABLE=1). Result:
sandbox users hit the passcode gate instead of entering the app.

This commit adds a dedicated sandbox bypass:
- ?sandbox=1 → marks session as authenticated, sets sandbox_mode=True,
  and pre-flags kall_theme_picker_done so the first-run theme modal is
  skipped. Users land directly in the cockpit (cream theme default).
- No passcode embedded in the landing redirect — keeps the secret off
  the public marketing surface.
- Refactored query-param reading into _read_query_param() helper that
  handles modern + legacy Streamlit APIs and list-wrapped values.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Thursday, June 25, 2026 (12:40 AM)
**`feat(cockpit): Option B redesign — clean header, first-run theme modal, persistent help FAB, coachmark, empty-state CTAs`** (Repo: dashboard)
What changed:
- Header refactor to 2-col: brand LEFT | Export PDF + Record Session (primary) + gear popover RIGHT. No more theme dropdown in front; theme + guide + help live inside gear popover.
- First-run theme picker modal (st.dialog) — 4 swatches, Cream pre-selected, Skip option. Fires once per session, persisted via kall_theme_picker_done flag.
- Persistent help "?" FAB pinned bottom-right via fixed CSS. Click sets ?show_help=1, intercepted on rerun to open Quickstart dialog (3-step how-to + where things live).
- Coachmark banner on first post-extraction view: "5 views unlocked. Switch tabs below..." with dismiss ✕ button (coachmark_post_extract_dismissed flag).
- Empty-state CTAs in Ask PM Copilot tab (empty chat_history) and Jira Sync tab (not yet connected) — dashed-border cards with suggested next action.
- Force-dark theme on passcode gate (get_gate_css helper). Auto-match strategy: kall-ai.com landing is dark premium → gate stays dark for visual continuity → user picks cockpit theme post-auth via modal.
- Kill backdrop-filter blur + soft drop-shadow on .glass-card / [data-testid=stExpander] / [data-testid=stForm] / VerticalBlockBorderWrapper. Replaced with crisp 1px border + accent-colored hover ring. Eliminates fuzzy edges on Advanced Settings + Connect to Jira expanders that user flagged under cream/sand themes.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Wednesday, June 24, 2026 (05:39 PM)
**`Merge pull request #1 from AItools-guru/feature/redesign-v1`** (Repo: dashboard)
feat(cockpit): pragmatic v1 redesign — themes, bcrypt auth, XSS escape, UX wins

---

### Wednesday, June 24, 2026 (12:31 PM)
**`fix(theme): visible inputs/textareas under light themes + dropdown picker`** (Repo: dashboard)
Root cause: BaseWeb CSS-in-JS injects inline backgroundColor on input
wrappers that beat single-class CSS rules even with !important. Two fixes
applied:

1. Override Streamlit's NATIVE theme CSS variables at :root:
   --background-color, --text-color, --secondary-background-color,
   --secondary-text-color, --primary-color. BaseWeb widgets read these
   directly, so theming now propagates through to st.text_input,
   st.text_area, st.selectbox, st.number_input.

2. Bump CSS specificity with `html body .stApp` chain on every input /
   textarea / select selector. Adds caret-color + selection styling so
   the active cursor and highlight color follow theme.

UI:
- Replaced 4-pill chip row with st.selectbox dropdown (Cream default).
  Cleaner, one-click, easier to extend with future themes.

Verified all 4 themes via smoke_themes2.py — typed text "VISIBLE TYPED
TEXT — Jordan Lee" renders dark-on-light in Cream/White/Sand and
light-on-dark in Dark.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Wednesday, June 24, 2026 (12:13 PM)
**`feat(cockpit): pragmatic v1 redesign — themes, bcrypt auth, XSS escape, UX wins`** (Repo: dashboard)
# Security (P0)
- auth_secure.py: bcrypt passcode verify (KALL_AI_PASSCODE_HASH env)
  + 5-attempt IP lockout (300s). Legacy fallback retained for 24h
  backward-compat window (set KALL_AI_LEGACY_PASSCODE_DISABLE=1 to kill).
- safe_render.py: html.escape wrappers for LLM-derived content.
  Applied to 7 unsafe_allow_html=True sites where item.task / item.assignee
  / ann / pt / goal / blk are interpolated — closes prompt-injection XSS
  surface in Action Planner + Speaker Analytics tabs.
- Audio temp files now use tempfile.mkstemp() (OS-managed temp dir)
  instead of project-local temp_uploads/ — survives crash cleanup via OS.

# Theme system
- theme.py: 4-state palette (Cream / White / Sand / Dark) with single
  source of truth (PALETTES dict, frozen dataclass).
- get_theme_css(theme) generates token-substituted CSS override layer.
  Wins specificity battle for: page bg, headings, body text, cards,
  expanders, tabs, buttons, code blocks, sidebar.
- Default: Cream (warm light) — matches 2026 market standard
  (Granola / Linear / Vercel / Notion all default light).
- Persists to st.session_state["kall_theme"]; toggle in header.
- KNOWN P1: Streamlit BaseWeb-styled inputs/textareas keep dark CSS-in-JS
  background even under light themes. Functional but cosmetically off.
  Follow-up: switch to Streamlit native config.toml theme + custom widget
  overrides via stylable_container.

# UX redesign (pragmatic v1)
- Header demoted: 1 primary CTA (Record Session) + overflow popover
  for Guide & Settings / Export PDF / future actions.
- 4-pill theme picker in header center.
- Replaced 3-tab input switcher (Audio / File / Paste) with chip-style
  buttons + single dropzone. Always-visible "Try with demo transcript"
  chip — no longer hidden behind a tab.
- "How to Record Screen" demoted from primary button to small "?" help
  link in right-aligned mini column.
- Removed inline "Audio Pipeline" disclaimer (UI noise).

# Test suite updates (test_kall_ai_e2e.py)
- T01-T03, T05, T06 PASS.
- T04 updated to drive new chip switcher + tick consent checkbox before
  Extract click. PASS in 22s end-to-end.
- T06 uses data-testid="brand-logo" on cockpit (gate keeps
  .logo-orb-wrapper for size assertion).

# Files
- NEW   theme.py            (~220 LOC)
- NEW   auth_secure.py      (~100 LOC)
- NEW   safe_render.py      (~25 LOC)
- EDIT  main_app.py         (+148 -64)
- EDIT  requirements.txt    (+1 bcrypt)

# Rollback
- Snapshot tag: pre-redesign-snapshot (pre-merge).
- Branch: feature/redesign-v1 (this commit).

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

### Wednesday, June 24, 2026 (01:31 AM)
**`feat: update landing page features and sitemap for Jira sync`** (Repo: landing-page)

---

### Wednesday, June 24, 2026 (01:30 AM)
**`feat: implement Jira Cloud integration and Sandbox Simulation Mode`** (Repo: dashboard)

---

### Monday, June 22, 2026 (10:04 AM)
**`fix: make demo transcript recognition lenient to support partial/edited text without API key`** (Repo: dashboard)

---

### Monday, June 22, 2026 (09:36 AM)
**`seo: add Google Search Console verification meta tag, sitemap.xml, and robots.txt`** (Repo: landing-page)

---

### Monday, June 22, 2026 (02:17 AM)
**`chore: ignore system files and design mockups`** (Repo: landing-page)

---

### Monday, June 22, 2026 (02:16 AM)
**`chore: ignore temp uploads, logos, and local scratch files`** (Repo: dashboard)

---

### Monday, June 22, 2026 (01:34 AM)
**`feat: fix Terms/Privacy click triggers and handle Turnstile lazy render on switchTab`** (Repo: dashboard)

---

### Monday, June 22, 2026 (01:33 AM)
**`feat: fix Terms/Privacy click triggers and handle Turnstile lazy render on switchTab`** (Repo: landing-page)

---

### Monday, June 22, 2026 (12:36 AM)
**`feat: add Cloudflare Turnstile verification and clickable Terms/Privacy links`** (Repo: dashboard)

---

### Monday, June 22, 2026 (12:36 AM)
**`feat: add Cloudflare Turnstile verification and clickable Terms/Privacy links`** (Repo: landing-page)

---

### Sunday, June 21, 2026 (09:12 PM)
**`chore: adjust split infographic viewport dimensions to 1200x627`** (Repo: landing-page)

---

### Sunday, June 21, 2026 (09:12 PM)
**`feat: upgrade meeting templates and dashboard ingestion layout split`** (Repo: dashboard)

---

### Saturday, June 20, 2026 (11:05 AM)
**`style: rename showcase tabs to match real dashboard features`** (Repo: dashboard)

---

### Saturday, June 20, 2026 (11:04 AM)
**`style: rename showcase tabs and update home screenshot with audio uploader updates`** (Repo: landing-page)

---

### Saturday, June 20, 2026 (10:37 AM)
**`style: remove Operations Cockpit v3.0 hero badge`** (Repo: dashboard)

---

### Saturday, June 20, 2026 (10:37 AM)
**`style: remove Operations Cockpit v3.0 hero badge`** (Repo: landing-page)

---

### Saturday, June 20, 2026 (02:21 AM)
**`seo: add Open Graph, Twitter Cards, and JSON-LD schema markup for SaaS`** (Repo: landing-page)

---

### Saturday, June 20, 2026 (02:20 AM)
**`security & compliance: remove API key query parameter from REST URLs, add data privacy notices and consent disclaimers`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (10:30 PM)
**`feat: reorder API keys, rename demo button, and expand demo transcript content`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (10:08 PM)
**`feat: implement LLM capability markers and uploader safeguards for audio pipeline`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (04:27 PM)
**`fix: implement resilient regex lookbehind speaker parser to handle inline speaker turns`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (03:37 PM)
**`fix: replace deprecated gemini-1.5 models with a resilient model fallback loop trying 2.5 and 3.1 models`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (03:20 PM)
**`fix: extract file details from nested file key in Gemini Files API upload response`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (03:12 PM)
**`fix: move st.set_page_config to top of script to prevent 'Streamlit' browser tab name on load`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (03:03 PM)
**`fix: change X-Goog-Upload-Command header to upload, finalize for single-pass resumable uploads`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (02:49 PM)
**`fix: change resumable data transfer method to PUT in compliance with Google Resumable Upload protocol`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (02:37 PM)
**`fix: pass API key as query parameter key= in all REST URLs to support resumable upload backend and new AQ. keys`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (02:25 PM)
**`fix: migrate all Gemini API calls to native HTTP REST endpoints using requests to support the new AQ. key format`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (02:09 PM)
**`fix: propagate exceptions out of status block to show errors and log expander on failure, add timeout guard to polling loop`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (01:45 PM)
**`feat: add real-time system execution logs to dashboard and wrap run_extraction`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (01:28 PM)
**`fix: explicitly specify correct mime type for audio file uploads to Gemini Files API and add validation checks`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (09:44 AM)
**`feat: implement engine auto-switching to Gemini upon audio file upload`** (Repo: dashboard)

---

### Wednesday, June 17, 2026 (09:28 AM)
**`feat: implement native audio uploads and split uploader layout in sandboxed cockpit`** (Repo: dashboard)

---

### Tuesday, June 16, 2026 (01:57 AM)
**`feat: add real before/after split mockup design`** (Repo: landing-page)

---

### Tuesday, June 16, 2026 (01:40 AM)
**`feat: add screenshot tools, mock transcripts, logo assets, and audit guide`** (Repo: dashboard)

---

### Tuesday, June 16, 2026 (01:29 AM)
**`feat: add linkedin mockups for social sharing`** (Repo: landing-page)

---

### Tuesday, June 16, 2026 (12:12 AM)
**`fix: Resolve AttributeError on ActionItem by using getattr`** (Repo: dashboard)

---

### Monday, June 15, 2026 (11:39 PM)
**`fix: Update PDF layout column widths and add comprehensive module sections`** (Repo: dashboard)

---

### Monday, June 15, 2026 (01:25 AM)
**`fix: Robust speaker parsing to filter non-name fragments`** (Repo: dashboard)

---

### Friday, June 12, 2026 (01:22 AM)
**`style: Collapse the Roadmap expander by default`** (Repo: dashboard)

---

### Friday, June 12, 2026 (01:17 AM)
**`style: Move API Key instructions to dedicated expander`** (Repo: dashboard)

---

### Friday, June 12, 2026 (01:06 AM)
**`docs: Restore Custom API Key setup instructions in Help panel`** (Repo: dashboard)

---

### Friday, June 12, 2026 (01:03 AM)
**`feat: Add PDF upload support to Streamlit app`** (Repo: dashboard)

---

### Friday, June 12, 2026 (12:49 AM)
**`style: refine radar scanner size, centering, and chip density`** (Repo: landing-page)

---

### Friday, June 12, 2026 (12:44 AM)
**`feat: Replace Notee mockup with Interactive Radar Scanner & fix image URLs`** (Repo: landing-page)

---

### Thursday, June 11, 2026 (02:35 AM)
**`Fix casing in metrics header`** (Repo: landing-page)

---

### Thursday, June 11, 2026 (02:24 AM)
**`Bump cache buster`** (Repo: landing-page)

---

### Thursday, June 11, 2026 (02:24 AM)
**`Actually restore clean screenshots`** (Repo: landing-page)

---

### Thursday, June 11, 2026 (02:21 AM)
**`Fix display_name persistence issue across app states`** (Repo: dashboard)

---

### Thursday, June 11, 2026 (02:15 AM)
**`Add cache buster to images`** (Repo: landing-page)

---

### Thursday, June 11, 2026 (02:11 AM)
**`Update Recruiter Sandbox, replace testimonials with metrics, restore clean screenshots`** (Repo: landing-page)

---

### Thursday, June 11, 2026 (01:57 AM)
**`Update screenshots with Jordan Lee placeholder`** (Repo: landing-page)

---

### Thursday, June 11, 2026 (01:55 AM)
**`Update layout, name, testimonials, checklist`** (Repo: landing-page)

---

### Thursday, June 11, 2026 (12:48 AM)
**`Update fallback name to Jordan Lee`** (Repo: dashboard)

---

### Thursday, June 11, 2026 (12:47 AM)
**`Update landing page: add testimonials, remove PM name, update placeholder`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (10:26 PM)
**`fix(kall-ai): resolve screen recorder permission blocks using same-origin parent DOM injection`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (07:05 PM)
**`feat(ux): implement premium top header control panel and embed custom browser screen recorder`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (06:54 PM)
**`style(ux): restore Streamlit header, toolbar, and main menu to enable sidebar and recording features`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (06:50 PM)
**`perf(ux): cache base64 logo disk IO using st.cache_data to speed up login reruns`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (06:02 PM)
**`style(ux): hide Streamlit header chrome, menu, and toolbar elements for premium white-labeling`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (05:35 PM)
**`feat(ux): implement onboarding progress ribbon, st.status extraction stages, and update landing copy`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (05:30 PM)
**`fix(copilot): add high-fidelity simulation fallbacks for members, deadlines, and tasks`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (05:18 PM)
**`fix(ux): add screen recording permissions troubleshooting, remove default username prefill, consolidate passcodes, and remove diagnostics log`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (04:59 PM)
**`fix(critical): PDF Unicode crash + prioritize haiku for faster extraction`** (Repo: dashboard)
- Added _sanitize_pdf_text() to replace em-dashes, smart quotes, bullets etc with ASCII equivalents
- Wrapped ALL pdf.cell/multi_cell text through sanitizer to prevent FPDFUnicodeEncodingException
- Swapped claude-haiku-4-5 as primary model (fast ~5-10s) over sonnet (~20s)

---

### Wednesday, June 10, 2026 (04:45 PM)
**`fix(critical): update Claude models to 4.x/5.x (3.x deprecated), add API key format validation and auto-swap for misplaced keys`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (04:29 PM)
**`fix(cockpit): hide system info, hide streamlit dropdown branding footer, style tab underlines, and prioritize custom API keys`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (04:09 PM)
**`Optimize logo loading dynamically from favicon.png and fix URL parameter synchronization`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (02:16 PM)
**`Remove dashboard layout selector widget to lock app to v3.0 premium layout`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (02:02 PM)
**`Fix screen recording menu, update user guide checklist, and replace tab page icon with branding favicon`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (01:15 PM)
**`style: fix bright white button and expander overrides for modern Streamlit`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (12:40 PM)
**`fix: redirect landing page to new custom domain app.kall-ai.com with auth token`** (Repo: landing-page)

---

### Wednesday, June 10, 2026 (10:41 AM)
**`feat: add render.yaml blueprint config for Render.com deployment`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (01:56 AM)
**`fix: update landing-page redirect to app.kall-ai.com`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (01:44 AM)
**`debug: add query parameter diagnostic logger to auth gate`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (01:40 AM)
**`fix: make auth query parameter parsing highly robust`** (Repo: dashboard)

---

### Wednesday, June 10, 2026 (01:32 AM)
**`style: resolve webpage audit items and implement secure auth gate`** (Repo: dashboard)

---

### Tuesday, June 09, 2026 (11:51 PM)
**`style: update pricing access tiers to be future-proof and allow sandbox monetization`** (Repo: landing-page)

---

### Tuesday, June 09, 2026 (11:41 PM)
**`feat: show visible demo login credentials banner and bypass firebase auth for demo account`** (Repo: landing-page)

---

### Tuesday, June 09, 2026 (12:01 AM)
**`fix: update Firebase config to correct kall-ai project (fixes auth error)`** (Repo: landing-page)

---

### Monday, June 08, 2026 (11:52 PM)
**`fix: integrate real Google Auth waitlist registration and sign-in verification`** (Repo: landing-page)

---

### Monday, June 08, 2026 (11:48 PM)
**`fix: add 5-second connection timeout to Firebase operations to prevent silent hangs`** (Repo: landing-page)

---

### Monday, June 08, 2026 (11:42 PM)
**`fix: add robust model fallback loops for Claude and Gemini to handle Tier 0 key limitations`** (Repo: dashboard)

---

### Monday, June 08, 2026 (11:34 PM)
**`feat: configure live Firebase keys for waitlist and auth login`** (Repo: landing-page)

---

### Monday, June 08, 2026 (11:12 PM)
**`feat: add Firebase script SDK and switch waitlist/login auth flows with fallback sandbox modes`** (Repo: landing-page)

---

### Monday, June 08, 2026 (10:58 PM)
**`fix: sign-in UX — error banners, validation, password strength, eye toggle`** (Repo: landing-page)

---

### Monday, June 08, 2026 (09:01 PM)
**`fix: revert redirect URL back to the live working Streamlit app domain`** (Repo: landing-page)

---

### Monday, June 08, 2026 (08:57 PM)
**`fix: implement mobile hamburger navigation menu and prevent comparison table cell compression`** (Repo: landing-page)

---

### Monday, June 08, 2026 (08:42 PM)
**`design: update app logo with the new Concept 2 logo base64 image`** (Repo: dashboard)

---

### Monday, June 08, 2026 (08:40 PM)
**`design: update home screenshot with the new Concept 2 logo`** (Repo: landing-page)

---

### Monday, June 08, 2026 (08:05 PM)
**`design: replace old emoji logo with new concept 2 microphone logo across website and head favicon`** (Repo: landing-page)

---

### Monday, June 08, 2026 (07:56 PM)
**`content: remove specific model version numbers from Copilot description`** (Repo: landing-page)

---

### Monday, June 08, 2026 (07:50 PM)
**`fix: adjust checklist spacing layout grid and resolve layout wobbling issue`** (Repo: landing-page)

---

### Monday, June 08, 2026 (07:39 PM)
**`fix: resolve media query brace, table spacing, and pricing card alignment`** (Repo: landing-page)

---

### Monday, June 08, 2026 (07:04 PM)
**`style: genericize competitor column names and remove testimonials section`** (Repo: landing-page)

---

### Monday, June 08, 2026 (07:00 PM)
**`style: rename header to Take Control of Your Post-Meeting Workflows`** (Repo: landing-page)

---

### Monday, June 08, 2026 (06:53 PM)
**`feat: add competitor comparisons, testimonials, pricing plans, and alternating features sections to landing page`** (Repo: landing-page)

---

### Monday, June 08, 2026 (06:49 PM)
**`feat: upgrade landing page to v3 with interactive browser mockup and new screenshot switcher`** (Repo: landing-page)

---

### Monday, June 08, 2026 (06:36 PM)
**`style: apply checklist alignment grid, dynamic timer, and redirect fix to live landing page`** (Repo: landing-page)

---

### Monday, June 08, 2026 (06:07 PM)
**`refactor: apply Claude Code audit fixes and verify test suite`** (Repo: dashboard)

---

### Monday, June 08, 2026 (05:51 PM)
**`design: add official Cloudflare logo to footer`** (Repo: landing-page)

---

### Monday, June 08, 2026 (05:17 PM)
**`Create CNAME`** (Repo: landing-page)

---

### Monday, June 08, 2026 (05:16 PM)
**`Initial commit: upload index.html landing page`** (Repo: landing-page)

---

### Monday, June 08, 2026 (01:50 PM)
**`Update README.md with v3.0 features and v4.0 upcoming upgrades roadmap`** (Repo: dashboard)

---

### Monday, June 08, 2026 (01:41 PM)
**`Add Upcoming Upgrades v4.0 sidebar roadmap card`** (Repo: dashboard)

---

### Monday, June 08, 2026 (01:26 PM)
**`Consolidate API keys to Advanced Settings, add key generation links, and update screen recording guide`** (Repo: dashboard)
- Consolidate custom Gemini and Claude API key inputs into a single location under Advanced Settings.
- Remove duplicate upload key inputs to prevent state desynchronization in Streamlit.
- Add dynamic warning under file upload redirecting users to the Advanced Settings drawer.
- Add direct console links to Gemini and Claude API key generation pages in the sidebar User Guide.
- Append offline playback tips for .webm files to the screen recording instruction card.

---

### Monday, June 08, 2026 (12:48 PM)
**`Fix Gemini schema compatibility, Streamlit caching, API key persistence, secrets safety, and parser line endings`** (Repo: dashboard)
- Inline $ref pointers and filter non-OpenAPI keywords (e.g. 'title') from the Pydantic schema to prevent Gemini validation errors.
- Delete 'core' and 'main_app' from sys.modules on every rerun to force Streamlit to bypass module caching.
- Store API keys in widget-independent session state variables to survive widget teardown across dashboard views.
- Switch speaker parsing line splitting to splitlines() for robust Windows/Unix line ending support.
- Wrap all st.secrets queries to prevent StreamlitSecretNotFoundError crashes when secrets.toml is absent.

---

### Monday, June 08, 2026 (10:17 AM)
**`Add automatic 429 quota fallback from Pro to Flash models for free-tier Gemini API keys`** (Repo: dashboard)

---

### Monday, June 08, 2026 (10:15 AM)
**`Implement dynamic model name resolution to prevent 404 deprecation errors on Gemini models`** (Repo: dashboard)

---

### Monday, June 08, 2026 (10:11 AM)
**`Fix Gemini schema validation by using Pydantic default_factory to remove 'default' keys from JSON Schema representation`** (Repo: dashboard)

---

### Monday, June 08, 2026 (10:08 AM)
**`Expose actual API validation errors for custom uploads instead of silently falling back to mock data`** (Repo: dashboard)

---

### Monday, June 08, 2026 (10:06 AM)
**`Fix StreamlitAPIException by passing engine resolution via resolved_provider session state`** (Repo: dashboard)

---

### Monday, June 08, 2026 (10:04 AM)
**`Auto-switch LLM provider if only one API key is provided`** (Repo: dashboard)

---

### Monday, June 08, 2026 (09:59 AM)
**`Require API key for custom uploads and prevent silent demo fallback`** (Repo: dashboard)

---

### Monday, June 08, 2026 (09:56 AM)
**`Fix header button clipping by adjusting container padding-top`** (Repo: dashboard)

---

### Monday, June 08, 2026 (02:38 AM)
**`Update Streamlit app background and card colors to match landing page design`** (Repo: dashboard)

---

### Monday, June 08, 2026 (02:29 AM)
**`Add optional Bring-Your-Own-Key (BYOK) inputs to file upload tab for custom transcripts`** (Repo: dashboard)

---

### Monday, June 08, 2026 (02:28 AM)
**`Feature: Add optional custom user API key inputs (BYOK) for live custom transcript extractions`** (Repo: dashboard)

---

### Monday, June 08, 2026 (01:57 AM)
**`Deploy: Copy landing page index.html to repository root for direct domain hosting`** (Repo: dashboard)

---

### Monday, June 08, 2026 (01:36 AM)
**`Refactor: Redesign landing page in Notee.ai structure with SPA tab routing and mock login gateway`** (Repo: dashboard)

---

### Monday, June 08, 2026 (01:28 AM)
**`Refactor: Swap sidebar guides, relocate Record Session Guide inside onboarding card, and add premium landing page`** (Repo: dashboard)

---

### Monday, June 08, 2026 (01:00 AM)
**`feat: rebrand to Kall AI & implement State-Based Single-Page layout`** (Repo: dashboard)

---

### Saturday, June 06, 2026 (02:46 AM)
**`style: update AI Foundations model designations in About sidebar panel`** (Repo: dashboard)

---

### Saturday, June 06, 2026 (02:41 AM)
**`style: fix and explicitly list model names for frameworks and AI foundations in About section`** (Repo: dashboard)

---

### Saturday, June 06, 2026 (02:37 AM)
**`feat: polish UI headers, fix empty boxes via container border cards, dyn assignee selectbox, and relocate guides to left-hand sidebar`** (Repo: dashboard)

---

### Saturday, June 06, 2026 (02:19 AM)
**`feat: implement Option B Dynamic Branding for self-personalizing demos and reports`** (Repo: dashboard)

---

### Saturday, June 06, 2026 (02:01 AM)
**`feat: implement v3.0 AI Notepad & Meeting Templates with dynamic layouts and exports`** (Repo: dashboard)

---

### Friday, June 05, 2026 (11:00 PM)
**`Fix Load Demo Transcript button to correctly update the Streamlit text area value via session state`** (Repo: dashboard)

---

### Friday, June 05, 2026 (04:24 PM)
**`feat: add interactive record session guide button in the header`** (Repo: dashboard)

---

### Friday, June 05, 2026 (03:51 PM)
**`style: implement centered premium header, default dark theme, and dropdown module switcher`** (Repo: dashboard)

---

### Friday, June 05, 2026 (03:10 PM)
**`fix: re-insert anthropic_key and gemini_key lookup definitions`** (Repo: dashboard)

---

### Friday, June 05, 2026 (03:06 PM)
**`feat: implement system dark mode support, title banner, settings cleanup via tabs/expanders, and copilot uploader contexts`** (Repo: dashboard)

---

### Friday, June 05, 2026 (02:55 PM)
**`fix: restore true tabs-free v1.0 static layout and wrap v2.0 tabs conditionally`** (Repo: dashboard)

---

### Friday, June 05, 2026 (02:36 PM)
**`fix: resolve NameError for anthropic_key and gemini_key and add st.secrets fallback`** (Repo: dashboard)

---

### Friday, June 05, 2026 (02:12 PM)
**`feat: wrap app.py with error handler and loosen requirements version constraints`** (Repo: dashboard)

---

### Friday, June 05, 2026 (01:55 PM)
**`chore: pin exact working dependency versions`** (Repo: dashboard)

---

### Friday, June 05, 2026 (01:52 PM)
**`feat: overhaul layout to wide 2-column format, add User & Recruiter Guide, reposition keys and add security shield`** (Repo: dashboard)

---

### Tuesday, June 02, 2026 (01:48 AM)
**`feat: major upgrade to v2.0 Next-Gen PM Analytics Suite with Sidebar Toggle Selector`** (Repo: dashboard)

---

### Tuesday, June 02, 2026 (01:20 AM)
**`Added Dev Container Folder`** (Repo: dashboard)

---

### Tuesday, June 02, 2026 (01:17 AM)
**`fix: resolve file uploader widget text overlapping by removing generic span CSS override`** (Repo: dashboard)

---

### Tuesday, June 02, 2026 (01:15 AM)
**`style: switch visual theme to ultra-premium Frosted Glass Light Mode with Slate typography and Indigo accents`** (Repo: dashboard)

---

### Tuesday, June 02, 2026 (01:13 AM)
**`style: upgrade visual theme to high-contrast Sleek Slate & Neon Mint for superior readability`** (Repo: dashboard)

---

### Tuesday, June 02, 2026 (12:59 AM)
**`Fix PDF layout spacing crash and add FPDF2 dependencies`** (Repo: dashboard)

---

### Tuesday, June 02, 2026 (12:43 AM)
**`feat: initial commit of premium glassmorphic GenAI Meeting Summarizer and Extractor web application`** (Repo: dashboard)

---


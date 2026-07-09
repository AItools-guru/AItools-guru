# Implementation Plan: Jira Sync, Theme Picker & UI Polish 🧪🔌

This plan details the Jira integration improvements, theme selector modal implementation, layout polishing, and end-to-end testing deployed to Kall AI on June 25, 2026.

---

## 🎙️ Goal Description
1. **Passwordless Sandbox Simulation**: Allow users to test the Jira export capability without real credentials. The Sandbox mode mocks authentication, project keys, assignable users matching demo characters (e.g. Elena Rostova, Marcus Chen, Sarah Jenkins), and animates a realistic ticket push progress bar.
2. **4-Theme Styling**: Add Cream (default), Dark, White, and Sand themes. Prompt first-time Cockpit users with a theme picker modal. Persist choices in both `localStorage` and `session_state` to eliminate visual whiplash (Gate stays dark as a bridge from marketing; cockpit switches to user choice).
3. **UI & Brand Alignment**: 
   * Reposition brand logo to top-left at `x=24px` (originally centered/indented at `~327px`).
   * Show a clear `⚙️ Settings` label text next to the configuration gear.
   * Pin `Record Session` and `Export PDF` buttons cleanly to the top-right.
   * Add a floating action button (FAB) for Help (`?`) at the bottom-right.
   * Ensure crisp edges (no blurring) for the Advanced Settings and Connect to Jira expander panels.
4. **Playwright E2E Testing**: Store local E2E test files under the `saurabhshidhore-kall-ai-e2e` configuration, verifying theme selection persistence and sandbox authentication flows.

---

## 🛠️ Implemented Modifications

### 💻 Streamlit Cockpit Core (`main_app.py`)
*   **Sandbox State Branching**: Added a checkbox `Run in Sandbox Simulation Mode (No Jira account required)` which disables credentials text boxes. Clicking `Authenticate & Connect` connects instantly as a "Sandbox Manager" on a "Sandbox Project" and loads dynamic mock team members matching the demo transcript.
*   **Backlog Sync Badger**: Syncing action items in Sandbox mode updates `st.session_state["jira_synced_keys"]` with mock keys (e.g. `SAND-101`). Renders an indigo integration badge (`🔌 Sandbox: SAND-101`) next to synced task checklist items.
*   **Theme Selection Modal**: First-time cockpit entry renders an overlay modal asking the user to choose a theme (Cream, Dark, White, Sand) with Cream pre-selected. Injects JavaScript to write the choice to browser `localStorage`. Returning users bypass the modal via local storage checks.
*   **Header Re-alignment**:
    *   Repositioned brand header using a multi-column split `col_logo, col_empty, col_buttons` layout to ensure the logo is locked to `x=24px` on the left.
    *   Wrapped Settings gear in a selector displaying `⚙️ Settings \u25be`.
    *   Constructed a floating CSS circle wrapper for the Help `?` FAB in the bottom right corner.

### 🎨 Themes System (`theme.py`)
*   Added core color palette overrides for four specific theme tokens:
    *   **Cream**: Soft warmth, low-contrast dark gray text, high readability.
    *   **Dark**: Deep obsidian charcoal, neon blue accents.
    *   **White**: Modern clean paper layout, subtle gray borders.
    *   **Sand**: Light organic tan, matching earthy palettes.
*   Updated CSS injection to handle Streamlit container box shadows, forcing sharp borders (crisp edges) on nested expander cards.

### 🧪 Automated E2E Testing (`saurabhshidhore-kall-ai-e2e`)
*   Tests written in Playwright to automate:
    1. Landing page dark premium styling checks.
    2. Passcode gate dark layout compliance.
    3. Cockpit modal display on first-visit and successful selection of Cream theme.
    4. State persistence checks across Streamlit reruns.
    5. Mock authentication click triggers and toast notification validations.

---

## 🧪 Manual Verification Plan

### 1. New User Flow
1. Open the browser in Incognito mode.
2. Enter the passcode.
3. Observe the theme selector modal pop up with **Cream** selected.
4. Click to apply and verify the cockpit updates to Cream, saving the token to local storage.
5. Refresh the page; verify the modal does not reappear.

### 2. Jira Sandbox Flow
1. Navigate to the `🔌 Jira Sync` tab.
2. Ensure `🧪 Run in Sandbox Simulation Mode` is checked.
3. Click `🔌 Authenticate & Connect`. Verify the toast reads "Connected successfully!" and the Backlog Sync section appears.
4. Select tasks, click `🚀 Push Selected Backlog to Jira`, and check that progress bar animates.
5. Verify the checklist items receive the `🔌 Sandbox: SAND-XXX` badges and the rows in the table lock to a checked, read-only state.

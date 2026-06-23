# Implementation Plan: Cloudflare CDN, Edge Security & Visual Polish 🛡️

This plan details the security hardening and visual asset updates deployed to Kall AI on June 23, 2026.

---

## 🎙️ Goal Description
1. **Proxy App Subdomain**: Enable Cloudflare proxy (orange cloud) for the custom subdomain `app.kall-ai.com` pointing to Render, hiding the raw backend origin.
2. **Enforce HTTPS**: Redirect all HTTP requests to secure HTTPS using Cloudflare edge rules.
3. **Bot & WAF Hardening**: Activate Bot Fight Mode to block automated vulnerability scanners probing for files like `secrets.json`, `/env`, and `/wp-includes`.
4. **Email Security**: Deploy a DMARC TXT record for `kall-ai.com` to prevent email domain spoofing.
5. **Redesign LinkedIn Infographic**: Generate a pixel-perfect, high-resolution vertical uploader before/after comparison banner, maintaining the correct aspect ratio of the Streamlit interface to prevent distortion and blurriness.

---

## 🛠️ Security Settings & DNS Changes
*   **Domain:** `kall-ai.com`
*   **CNAME Record (app):** Changed `app.kall-ai.com` from **DNS Only** (gray cloud) to **Proxied** (orange cloud) pointing to `kall-ai-cockpit.onrender.com`.
*   **TXT Record (DMARC):** Added `_dmarc.kall-ai.com` with content `"v=DMARC1; p=none; rua=mailto:dmarc-reports@kall-ai.com"`.
*   **Redirect Rules:** Disabled the legacy Page Rule redirecting `app.kall-ai.com/*` to `genai-meeting-summarizer.streamlit.app` to let Render load directly.
*   **WAF Rule:** Enabled **Bot Fight Mode** under Security settings.
*   **Edge Certificates:** Enabled **Always Use HTTPS**.

---

## 🎨 Visual Assets Redeployment
Stitched a high-resolution comparison infographic using the true before-redesign vertical layout (`media__1782015764944.png`) and after-redesign dual-card cockpit (`media__1782110657591.png`).
*   **Stitch Script:** [merge_vertical_fixed.py](file:///Users/saurabhshidhore/.gemini/antigravity/brain/d59c6315-dffa-4575-8184-a51099694533/scratch/merge_vertical_fixed.py)
*   **Infographic Resolution:** $1200\times1240$ px (Perfect for LinkedIn mobile & desktop feeds, preserving the correct Streamlit proportions).
*   **Workspace Destination:** [before_after_split_infographic.png](file:///Users/saurabhshidhore/Documents/Business%20Saurabh/Claude-%20Google%20Antigravity/Kall-AI-workspace/Roadmap%20-%20Implementation%20Plan/visual_assets/before_after_split_infographic.png)

---

## 🧪 Verification Plan

### DNS Resolution
*   `host app.kall-ai.com` resolves directly to Cloudflare edge IPs (`104.21.2.25` and `172.67.128.156`).
*   `host -t TXT _dmarc.kall-ai.com` correctly resolves the DMARC TXT string.

### HTTP to HTTPS Redirects
*   `curl -I http://app.kall-ai.com` returns a `301 Moved Permanently` pointing to `https://app.kall-ai.com/`.

### Dashboard Load
*   `curl -I https://app.kall-ai.com` returns `HTTP/2 200 OK` directly from the Render origin server (`x-render-origin-server: uvicorn`).

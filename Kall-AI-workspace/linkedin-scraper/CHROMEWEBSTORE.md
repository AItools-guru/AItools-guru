# Chrome Web Store Metadata & Publishing Specifications

This document contains the official metadata, copy, and permissions justifications required to publish the **Kall AI LinkedIn Analytics Exporter** to the Google Chrome Web Store.

---

## 📝 1. Store Listing Copy

### Extension Name
`Kall AI LinkedIn Analytics Exporter`

### Single-Line Summary (Max 150 characters)
`Export your LinkedIn Recent Activity post impressions, reactions, and engagement metrics directly to a clean CSV file.`

### Detailed Description (Max 16,000 characters)
```text
Kall AI LinkedIn Analytics Exporter is a lightweight, privacy-first browser utility designed for founders, product managers, and content creators who need to track their LinkedIn content performance.

LinkedIn Premium provides rich analytics, but extracting them manually is tedious. This extension injects a single, floating button on your Recent Activity page, allowing you to instantly download a structured CSV file of your posts' performance.

📊 KEY FEATURES:
- One-click export of impressions, reactions, comments, and reposts.
- Automatic duplicate filtration during infinite scrolling.
- Localized processing: Your data never leaves your browser.
- Clean CSV output ready for Excel, Google Sheets, or Notion databases.

🔒 PRIVACY & SECURITY FIRST:
- Zero data storage: The extension processes everything in volatile memory.
- No external APIs or trackers.
- Free and open source.

Brought to you by Kall AI (kall-ai.com) — Turn your team meetings and product syncs into structured backlogs and Jira tickets instantly.
```

### Category
`Productivity` or `Developer Tools`

---

## 🔒 2. Permissions Justifications
These plain-English justifications are required by the Chrome Web Store review team to prevent rejection:

*   **`activeTab` & `scripting`**: Required to dynamically inject the "Export Analytics CSV" floating button into the active browser page and run the DOM parser.
*   **`downloads`**: Required to trigger the native browser download prompt to save the compiled CSV file to the user's local disk.
*   **`host_permissions` (`https://www.linkedin.com/in/*/recent-activity*`)**: Required to restrict the extension's script injection capabilities solely to LinkedIn Recent Activity pages, ensuring user safety.

---

## 📁 3. ZIP Packaging & Publish Checklist

Before zipping and uploading the extension to the Developer Dashboard, make sure to exclude metadata files to keep the build light and secure.

### Build Packing Command:
Run this command in your terminal inside the `Kall-AI-workspace/linkedin-scraper` folder to generate a clean, store-ready ZIP archive:
```bash
zip -r ../kall-linkedin-exporter.zip . -x "*.git*" "*CHROMEWEBSTORE.md*" "*privacy-policy.md*" "*.DS_Store*"
```

### Dashboard Settings Checklist:
1. **Single Purpose**: Select "Yes" to confirm the extension has a single purpose (Exporting LinkedIn Analytics).
2. **Data Use Disclosures**: 
    *   Under **Data Safety**, check *Personal Communications* / *User Activity* (because it reads posts/impressions).
    *   Confirm that the extension **does not transfer or sell user data** and processes data locally.
3. **Privacy Policy URL**: Link to the published `privacy-policy.md` (or host it on your site `kall-ai.com/privacy-linkedin-exporter.html`).

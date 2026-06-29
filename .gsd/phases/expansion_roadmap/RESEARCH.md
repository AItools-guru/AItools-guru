---
phase: expansion_roadmap
level: 3
researched_at: 2026-06-29
---

# Phase: Kall AI SaaS Expansion & Monetization

## Questions Investigated
1. What are the core features Kall AI must implement to be highly competitive against incumbents (Otter, Fireflies, Gong) in the B2B SaaS space?
2. How can we map these features to monetization tiers (Pro vs. Enterprise)?
3. What integrations are strictly necessary to embed Kall AI into daily corporate workflows?

## Findings

### Feature Gap Analysis (Competitive Edge)
To transition Kall AI from a functional LLM wrapper to an indispensable enterprise tool, we must bridge the gap between "summarization" and "actionable intelligence". 

**Key Competitor Features needed:**
- **Native Audio/Video Ingestion:** Direct MP4/WAV/MP3 uploads with high-accuracy speaker diarization. (We will use Gemini 1.5 Pro Multimodal API).
- **CRM Integration:** Two-way sync with Salesforce & HubSpot. Pushing "Client Pain Points" and "Budget Details" directly into CRM fields saves sales reps 30 mins a day.
- **Team Workspaces & RBAC:** Role-Based Access Control so managers can see team calls, but individuals have private draft spaces.
- **Enterprise SSO & Security:** SAML/SSO login and SOC2 compliance (we already have Cloudflare WAF, Bcrypt, XSS sanitization, which gives us a massive head start on the security narrative).
- **Custom Template Builder:** Allowing Org Admins to define their own Pydantic schemas without writing code (e.g., a custom "Candidate Interview" template for HR).

### Monetization Strategy (Tiers)
- **Free/Basic (PLG Funnel):** Text/Transcript paste only, 3 templates, limited storage, watermark.
- **Pro ($15-$25/user/mo):** Native audio/video upload, Slack/Notion export, Custom Templates.
- **Enterprise ($50+/user/mo):** CRM Integrations (Salesforce/HubSpot), Team Dashboards, SSO, Manager Sentiment Analytics, Dedicated hosting.

## Decisions Made
| Decision | Choice | Rationale |
|----------|--------|-----------|
| Audio Engine | Gemini 1.5 Pro Multimodal | Better reasoning over long contexts and native processing vs pure STT like Whisper. |
| Integrations | HubSpot/Salesforce first | This is where the highest willingness-to-pay exists (Sales teams). |
| Custom Templates | Admin UI for Pydantic | Reduces engineering bottleneck; allows companies to fit Kall AI to their exact terminology. |

## Patterns to Follow
- Build "Push" integrations first (e.g., webhook to Slack, API push to Notion) before complex two-way syncs.
- Keep the Landing Page -> Sandbox PLG (Product-Led Growth) loop intact to drive free user adoption.

## Dependencies Identified
| Package | Version | Purpose |
|---------|---------|---------|
| google-generativeai | latest | Core multimodal audio ingestion |
| auth0-python | latest | For migrating to Enterprise SSO later |

## Risks
- **Storage Costs:** Storing MP4s is expensive. **Mitigation:** Use signed URLs to process immediately and delete the heavy video file after audio extraction.
- **Context Windows:** Very long meetings. **Mitigation:** Gemini 1.5 Pro handles up to 2M tokens, mitigating this risk significantly.

## Ready for Planning
- [x] Questions answered
- [x] Approach selected
- [x] Dependencies identified

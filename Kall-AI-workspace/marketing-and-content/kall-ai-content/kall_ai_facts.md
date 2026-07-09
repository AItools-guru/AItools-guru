# Kall AI Facts File
This file is the single source of truth for the `kall-ai-content` skill.
The skill must read this before writing every post.
Saurabh updates this file as the product evolves. Never invent a number that is not in here.

---

## Product one liner
Kall AI is an operational meeting cockpit that turns raw audio and transcript files into structured Agile backlogs in seconds.

## What it actually does (one line each)
- Drop in a raw audio file (mp3, wav, m4a) or a transcript (txt, srt, vtt).
- Extracts an executive summary, an Agile backlog, owners, blockers, and risk flags.
- Tracks speaker talk share with charts.
- Runs strict Pydantic validation on every LLM output. Zero broken UI.
- Switches between Claude and Gemini engines on the fly.
- PM Copilot chat lets you query past meetings.
- Exports to Jira, CSV, PDF, Markdown.
- Stores nothing. Ephemeral. TLS 1.3 in. Process. Wipe.

## Pricing tiers
- Free Sandbox. No API key. Mock data. Full UI.
- Solo PM / Creator. Bring your own key. No subscription fee.
- Secure Enterprise. Dedicated hosting. Jira, Linear, Slack connectors. SSO.

## Confirmed metrics (use these freely)
- 10+ hours saved per sprint (publicly stated on kall-ai.com).
- 100% ephemeral. Zero database retention.
- Zero UI breaks since Pydantic enforcement shipped.
- Built in 6 weeks (Saurabh's first build window).
- Supports multi hour audio in a single pass (Gemini Pro native window).
- Pydantic validates JSON SCHEMA TYPES, not content truth. The cockpit never crashes, but content accuracy still depends on the model. NEVER write "Pydantic = zero hallucinations" because it is false. Pydantic only guarantees the JSON parses cleanly.

## Use cases worth naming
- Sprint planning
- Standups
- Retros
- Discovery calls
- Client check ins
- DevOps reviews
- Solo voice notes
- Workshops

## Personas to name in posts
- PM at a Series A SaaS company
- Founder of a 14 person agency
- Engineering manager of a 30 person team
- Ops lead at a remote consultancy
- Solo PM running 5 client accounts

## Quotes from beta users
(Update this section as real quotes come in. Until then, leave blank. Never fabricate.)

- (placeholder) ""
- (placeholder) ""

## Banned phrases (never use)
- "Pydantic prevents hallucinations" / "Pydantic = zero hallucinated tickets" (FALSE. Pydantic validates schema, not content)
- "Whisper + GPT = 4 model calls" (INFLATED. Typical is 2 calls)
- "unlock the power of"
- "in today's fast paced world"
- "game changer" / "game changing"
- "revolutionize"
- "leverage" (as a verb)
- "synergize"
- "AI powered" (overused)
- "delve into"
- "navigate the complexities"
- "in the realm of"
- "elevate" (overused on LinkedIn)
- "transformative"
- "harness"
- "embark on"
- "seamless" / "seamlessly"
- "robust"
- "cutting edge"

## Preferred phrases (use these instead)
- Instead of "AI powered" use "the model does X" or "Kall AI does X".
- Instead of "unlock the power of" use "this gives you".
- Instead of "game changer" use the specific change. ("10 hours back in your week.")
- Instead of "leverage" use "use".
- Instead of "transformative" use "different" or skip the adjective.

## URLs
- Product: kall-ai.com
- Sandbox: kall-ai.com (button on homepage)
- Saurabh LinkedIn: linkedin.com/in/saurabhshidhore

## Tone anchors
- Sound like a founder typing on a Sunday night, not a marketer.
- Sound like a builder who shipped something, not a thought leader.
- Numbers over adjectives.
- Specific over universal.
- One clean point per post. Never two.

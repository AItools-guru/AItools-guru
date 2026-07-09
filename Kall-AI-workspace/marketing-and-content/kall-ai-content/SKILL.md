---
name: kall-ai-content
description: Generates a complete LinkedIn post for Kall AI based on a date (or day number from the 15 day calendar) with optional topic override. Always outputs BOTH a markdown file and a DOCX file. Voice toggles available include build-in-public founder (default), story driven, and hot take contrarian. Use this skill whenever Saurabh asks for "today's Kall AI post", "Day N", "next Kall AI post", "write me a Kall AI LinkedIn post", "give me Kall AI content for [topic]", or any similar request. Always reads kall_ai_facts.md before writing so the post uses real numbers, real features, and never invented claims. Follows voice_guide.md strictly. No em dashes. No hyphens as separators in body copy.
---

# Kall AI LinkedIn Content Skill

## When to trigger

Trigger immediately on any of these:
- "Today's Kall AI post"
- "Day 1" through "Day 15" (Saurabh's 15 day push)
- "Next Kall AI post"
- "Write me a LinkedIn post about Kall AI"
- "Kall AI content for [topic]"
- "Generate Kall AI post"
- "I need to post today about Kall AI"

Do not ask the user a long list of clarifying questions. Ask at most one if the date and topic are both missing. Otherwise just write.

## Inputs

Two arguments. Both are optional but at least one must be inferable from context.

1. `date_or_day` — either a calendar date (e.g. 2026-06-20) or a day number from 1 to 15. Look it up in `calendar.md`. If a date is given, map it to the closest day slot in the rotation. If user says "today", use today's date.
2. `topic_override` — optional. A string the user pasted. If present, ignore the slot's pre baked topic and write about the override. Keep the slot's FORMAT (carousel, text, video, poll). This preserves the mix.

## Workflow

Execute these steps in order. Do not skip step 1.

### Step 1. Read the three reference files
- Read `kall_ai_facts.md` to ground every claim in a real fact. If the post needs a number, pull it from the facts file. If the facts file does not have a number for what you want to claim, write the post without the number (do not invent).
- Read `voice_guide.md` to lock the voice rules before drafting.
- Read `calendar.md` to find the right slot for the requested date or day number.

### Step 2. Pick the voice toggle
- Default: build in public founder.
- If the slot in `calendar.md` is tagged `story`, use story driven.
- If the slot is tagged `hot_take`, use hot take.
- If the user explicitly says "make it a story" or "hot take", switch.

### Step 3. Draft the post
- Hook in the first 2 lines. Must work above the "see more" cutoff.
- Sentence length: short. Average 8 to 14 words.
- Paragraph length: 1 to 2 lines max.
- No em dashes. None. Anywhere.
- No hyphens used as separators in body copy. (Compound words like "build-in-public" are fine inside hashtags or quoted handles. Inside body sentences, write "build in public" with spaces.)
- One CTA per post. Always soft. End with a real question when format allows.
- Hashtags: exactly 3. Mix of broad and niche.
- If carousel: produce slide-by-slide content (cover + 7 to 10 slides). Each slide has a title and 1 to 3 lines of body.
- If video: produce a script with timestamps in 5 to 10 second blocks plus a caption block.
- If poll: produce 4 options + a seed first comment.
- Always produce a "seed first comment" the user will post 10 minutes after publishing. 20+ words. Adds context or asks a question. Drives the dwell time the algorithm rewards.

### Step 4. Output BOTH files
Save both to `/Users/saurabhshidhore/Documents/Business Saurabh/Claude- Google Antigravity/Claude Testing/Kall AI Project/Posts/`.

Filename pattern:
- `Day_{N}_{YYYY-MM-DD}_{format}.md`
- `Day_{N}_{YYYY-MM-DD}_{format}.docx`

Example: `Day_07_2026-06-22_text.md` and `Day_07_2026-06-22_text.docx`.

For the DOCX, follow the docx skill (read `/var/folders/3t/_vr034611ss522s79spmmrxc0000gn/T/claude-hostloop-plugins/16178550eea5ac60/skills/docx/SKILL.md`). Format with the heading hierarchy below.

### Step 5. Present in chat
- Show the user the final post body (copy ready, no scaffolding).
- Show the seed comment.
- Show the hashtags as a single line.
- Call `mcp__cowork__present_files` with both file paths.
- End with one suggestion: a repurposing angle for the post (a Reel cut, a Twitter thread variant, etc.).

## Output document structure (both MD and DOCX)

```
# Day {N}. {Format}. {Slot title}

## Post body (paste this into LinkedIn)
{full post text}

## Hashtags
{hashtag1} {hashtag2} {hashtag3}

## Seed comment (post 10 minutes after publishing)
{comment text}

## (If carousel) Slide breakdown
Slide 1. {title}
{body}

Slide 2. {title}
{body}
...

## (If video) Script
(0 to 5s) ...
(5 to 15s) ...

## Repurposing ideas
- {one line for Twitter}
- {one line for IG Reels or Shorts}
- {one line for an email newsletter angle}

## Source facts used from kall_ai_facts.md
- {fact 1}
- {fact 2}
```

## Hard rules (never break)

1. Never invent a metric. If the facts file does not have it, do not write it.
2. Never use em dashes.
3. Never use hyphens as sentence separators in body copy.
4. Never use the phrases listed under "banned phrases" in `kall_ai_facts.md`.
5. Never write more than 3 hashtags.
6. Never paste the same hook as a recent post. (Check the latest 3 files in `Posts/` before writing the hook.)
7. Always end with a real question or a clear CTA. Not both.
8. Always include the kall-ai.com URL exactly once. (More than once reads spammy.)

## Soft rules (follow unless context demands otherwise)

1. Lead numerals over words when stating a stat. "12 seconds" beats "twelve seconds".
2. Concrete nouns over abstract ones. "Sprint planning" beats "agile ceremonies".
3. Name a real role or persona when possible (PM, ops lead, founder, engineering manager).
4. When in doubt between a clever line and a clear line, ship clear.

## After running

Add one line of progress to `/Users/saurabhshidhore/Documents/Business Saurabh/Claude- Google Antigravity/Claude Testing/Kall AI Project/Posts/_log.md` so future runs know which days are done.

Format:
`Day_07_2026-06-22 | text | story | shipped | hook: "Stop writing meeting notes."`

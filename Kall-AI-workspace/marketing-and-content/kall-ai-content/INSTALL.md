# How to install the kall-ai-content skill

## What is in this folder

```
kall-ai-content/
├── SKILL.md             ← main skill prompt (do not edit unless you know what you are doing)
├── kall_ai_facts.md     ← edit this often. add real metrics, quotes, banned words
├── voice_guide.md       ← edit if you want to change tone rules
├── calendar.md          ← the 15 day calendar. extend it past day 15 as needed
├── examples/
│   └── day_7_example.md ← reference output
└── INSTALL.md           ← this file
```

## Install steps (Cowork / Claude desktop)

1. Open Claude desktop.
2. Go to Settings.
3. Open Capabilities (or Skills, depending on your version).
4. Click "Add skill" or "Install skill".
5. Point it at this folder OR drop the `kall-ai-content.skill` zip file.
6. Confirm install.
7. Test by typing in any chat: `Day 7` or `Write me today's Kall AI post`.

If you do not see the install option in Settings, the skill can also be invoked manually in a chat by pasting the contents of `SKILL.md` as a system prompt or by asking Claude to "use the skill at this path: /Users/.../kall-ai-content/SKILL.md".

## How to use it daily

Three ways:

1. Date based: "Generate today's Kall AI post" → skill maps today's date to the right slot.
2. Day based: "Day 7" → skill picks the Day 7 slot from calendar.md.
3. Topic override: "Day 7 but make it about pricing" → skill keeps the Day 7 format but swaps topic.

Output lands in `/Users/saurabhshidhore/Documents/Business Saurabh/Claude- Google Antigravity/Claude Testing/Kall AI Project/Posts/` as both .md and .docx.

## Keep it sharp

Update `kall_ai_facts.md` every time:
- You get a real beta user quote.
- A real metric ships (e.g. "200 signups in week 1").
- A new feature ships.
- You catch yourself or the AI using a tired phrase. Add it to "banned phrases".

The skill is only as sharp as that file. Treat it like a living document.

## Pair with a scheduled task (optional)

To make this hands free:
1. Ask Claude: "Set up a daily task at 7 AM that generates today's Kall AI post."
2. Claude will use `mcp__scheduled-tasks__create_scheduled_task` with cron `0 7 * * *` and a prompt like "Generate today's Kall AI post using the kall-ai-content skill."
3. Every morning you wake up with a draft in `/Posts/`. Polish in 5 minutes. Ship.

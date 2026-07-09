# 15 Day Calendar Reference

Used by the skill to map a date or day number to a slot.
If a date does not match a day number 1 to 15, pick the closest open slot by day-of-week pattern (Mon = product, Tue = hot take, Wed = product, Thu = poll or carousel, Fri = product or long form, Sat = framework, Sun = reflection).

| Day | DoW | Format | Audience | Voice tag | Slot title | Topic seed |
|---|---|---|---|---|---|---|
| 1 | Mon | carousel | PM + Founder | story | Origin story | I lost a deal because of one missed action item |
| 2 | Tue | text | AI Builder | hot_take | Whisper is dead | Why we ripped out Whisper for Gemini |
| 3 | Wed | video_60 | SMB Founder | story | Watch this convert | 45 min standup to backlog in 12 sec |
| 4 | Thu | poll | Mixed | default | Meeting hours wasted | How many hours per week in meetings |
| 5 | Fri | text | Enterprise | hot_take | Meeting bot compliance | Your meeting bot is a compliance time bomb |
| 6 | Sat | carousel | PM | framework | 5 part meeting anatomy | The 5 part anatomy of a backlog ready meeting |
| 7 | Sun | text | Founder | story | 30 day reflection | 30 days of building. What I got wrong |
| 8 | Mon | carousel | AI Builder | framework | Pydantic tutorial | How we stopped hallucinated tickets |
| 9 | Tue | video_45 | SMB Founder | story | Priya the ops lead | Customer story, 9 hours back per week |
| 10 | Wed | text | PM | hot_take | Stop writing notes | Senior PMs waste 4 to 6 hours on note typing |
| 11 | Thu | carousel | Enterprise | framework | Hidden meeting cost | Real ROI math of a bad planning meeting |
| 12 | Fri | newsletter | Investors + Founders | hot_take | Not a notes app | Why the winner is not a notes app |
| 13 | Sat | video_30 | Mixed | story | Founder face | Hi I am Saurabh, day 13 update |
| 14 | Sun | poll | PM + Founder | default | Worst meeting | Which meeting do you dread the most |
| 15 | Mon | carousel | Mixed | story | 15 day recap | What 15 days of posting did for Kall AI |

## Format definitions
- `text`: 1,000 to 1,300 character text only post.
- `carousel`: cover + 7 to 10 slides. Each slide has a title and 1 to 3 lines.
- `video_30`, `video_45`, `video_60`: vertical video script in 5 to 10 second blocks.
- `poll`: 4 options + seed first comment.
- `newsletter`: long form 1,500 to 2,500 character post.

## Audience definitions
- `PM`: Product managers at Series A to mid market companies.
- `Founder`: SaaS founders, indie hackers, solo builders.
- `SMB Founder`: small business owners (5 to 50 employees).
- `AI Builder`: engineers building LLM apps.
- `Enterprise`: VPs of product, ops, or engineering at 200+ employee companies.
- `Investors`: angel and seed VCs.
- `Mixed`: cross cutting. Write for all four.

## Voice tag definitions
- `default`: build in public founder.
- `story`: customer or personal narrative.
- `hot_take`: punchy, contrarian opinion.
- `framework`: listicle, save bait, carousel friendly.

## After Day 15
The push continues. The pattern restarts at Day 1 with new topics. The skill should append to the calendar (do not overwrite) for days 16+ once topics are decided. Ask Saurabh for a new theme on day 13 so the next 15 are ready.

---
name: speedread
description: Use when the user types /speedread or asks to "speed read" / "RSVP" some text. Opens a browser-based RSVP (rapid serial visual presentation) reader that flashes the text one word at a time at high speed (default 450 wpm) with the focal letter aligned for minimal eye movement. Pre-processes markdown so code blocks are stripped and lists/headers get pause beats. Useful for digesting long Claude responses, plans, specs, or articles without scrolling.
---

# Speedread

Launch a browser-based RSVP reader for any text the user wants to consume fast.

## When to use

- User types `/speedread` (with or without arguments)
- User asks to "speed read", "RSVP", or "flash" some text
- User says things like "I don't want to read all this — speed read it for me"

## Picking the text

In priority order:

1. **Explicit text in the invocation**: `/speedread Here is the text to read…` → use that text verbatim.
2. **Reference to a prior message**: "the plan", "your last response", "the spec above", "the summary" → use the relevant assistant message from this conversation.
3. **Reference to a file**: "this README", `/speedread @path/to/file.md` → read the file with the Read tool, use its contents.
4. **No argument at all**: use the most recent substantial assistant message in this conversation.

## Pre-processing rules (you do this before launching)

The reader already strips markdown internally when `smartMd` is on, but you should still trim content that won't speed-read well:

- **Drop fenced code blocks entirely** — replace them with a one-line summary like "(code: X lines of TypeScript)". Users can scroll back to the chat for the actual code.
- **Drop large tables** the same way: "(table: 12 rows of metric data)".
- **Drop ASCII diagrams / file trees** — summarize in one line.
- **Keep**: prose paragraphs, headings, bullet lists (with their text), inline emphasis, link text.
- **Don't** add commentary or rephrase the text — preserve the original voice. You're filtering, not summarizing.

If the source is already plain prose with no code/tables, skip pre-processing and pass it through unchanged.

## How to launch

The launcher (`launch.sh`) and HTML template (`reader.html`) live in the **same directory as this SKILL.md** — i.e. the "Base directory for this skill" shown in the skill invocation header (`$SKILL_DIR`).

1. Write the (filtered) text to a temp file:

   ```
   Write tool → /tmp/speedread-input.txt
   ```

2. Run the launcher with that file path. WPM is optional (default 450); pass it if the user asked for a specific speed.

   ```bash
   "$SKILL_DIR/launch.sh" /tmp/speedread-input.txt 450
   ```

   Substitute `$SKILL_DIR` with the actual base directory shown to you above the SKILL.md content. Examples:
   - Direct user install: `~/.claude/skills/speedread/launch.sh`
   - Plugin install: `~/.claude/plugins/cache/<marketplace>/speedread/<version>/skills/speedread/launch.sh`

3. Confirm to the user in one short line: "Opened in your browser at 450 wpm — Space to pause, ←/→ to jump."

That's it. Do not summarize the text in chat afterwards — the user is going to read it in the RSVP window.

## Speed conventions

- Default: 450 wpm
- "Fast" / "speed it up" → 600 wpm
- "Slow" / "slower" → 300 wpm
- User can name an exact value: 300 / 450 / 600 / 700 / 900 are the natural presets; any value 100–1200 works.

## Failure modes

- If `launch.sh` exits non-zero, show the stderr to the user. Most likely cause: `reader.html` missing next to `launch.sh`, or `node` not on PATH.
- On Linux without `xdg-open`, the script writes the temp HTML path to stdout — open it manually.

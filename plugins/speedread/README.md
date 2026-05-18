# speedread

RSVP (Rapid Serial Visual Presentation) reader for Claude Code.

Flashes text one word at a time at 300–900 wpm with the focal letter aligned to
a red guide line — your eyes don't have to move. Strips code blocks and tables,
adds pause beats around lists and headers.

## Usage

After installing the plugin, type `/speedread` in any Claude Code session.

- `/speedread` — speed-read the most recent substantial Claude response
- `/speedread the plan` — pick a referenced message
- `/speedread @path/to/file.md` — read a file
- `/speedread <pasted text…>` — verbatim input

Speed: append a number (e.g. `/speedread fast`, `/speedread at 700 wpm`).

## Controls (in the reader)

| Key | Action |
|---|---|
| `Space` | Pause / resume |
| `←` / `→` | Jump 10 words |
| `Shift+←/→` | Jump 20 |
| `⌘/Ctrl+←/→` | Jump 50 |
| `↑` / `↓` | Speed ±25 wpm |
| `Esc` | Open full-text view (auto-resumes on close) |

## Requirements

- `node` on `PATH` (used by `launch.sh` to inject text into the reader)
- A default browser (macOS `open` or Linux `xdg-open`)

## Files

- `skills/speedread/SKILL.md` — skill definition (Claude reads this)
- `skills/speedread/launch.sh` — builds a self-contained HTML with the text
  embedded and opens it
- `skills/speedread/reader.html` — the actual RSVP reader UI

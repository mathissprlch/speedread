# Installing speedread

There are four ways to install, from most user-friendly to most hacky.

---

## 1. As a Claude Code plugin from this repo (recommended for distribution)

Once this repo is on GitHub (e.g. `mathis/speedread-plugin`), anyone can install
with two slash commands inside Claude Code:

```
/plugin marketplace add mathis/speedread-plugin
/plugin install speedread@speedread-marketplace
```

That's it. Restart Claude Code (or wait for the next session) and `/speedread`
is available everywhere.

Behind the scenes Claude Code clones the repo to
`~/.claude/plugins/marketplaces/speedread-marketplace/` and caches the installed
plugin at `~/.claude/plugins/cache/speedread-marketplace/speedread/<version>/`.

---

## 2. As a plugin from a local checkout (for development)

If you've cloned this repo locally and want to test plugin-mode without
publishing:

```
/plugin marketplace add /absolute/path/to/speedread
/plugin install speedread@speedread-marketplace
```

Edit files in the checkout, then `/plugin update speedread@speedread-marketplace`
to pick up changes.

---

## 3. As a user skill (one-time copy, simplest for personal use)

If you don't care about the plugin system and just want it for yourself:

```bash
mkdir -p ~/.claude/skills/speedread
cp plugins/speedread/skills/speedread/SKILL.md     ~/.claude/skills/speedread/
cp plugins/speedread/skills/speedread/launch.sh    ~/.claude/skills/speedread/
cp plugins/speedread/skills/speedread/reader.html  ~/.claude/skills/speedread/
chmod +x ~/.claude/skills/speedread/launch.sh
```

(Or symlink instead of copy if you want edits to live-propagate — see the
"Iterating" section below.)

Restart any open Claude Code sessions to pick up the new skill.

---

## 4. As a standalone web app (no Claude Code at all)

Just open `index.html` in any browser and paste text in. No skill, no plugin,
nothing to install — useful for sharing the reader URL with non-CC users.

You can host it on any static-file host (GitHub Pages, Netlify, S3, etc) and
optionally bookmark it with `?wpm=600&autostart=1` etc.

---

## "It only works in this chat — why?"

Two common reasons:

1. **Other sessions opened before the install need to be restarted.** Skills are
   loaded at session start. Just `/exit` and reopen.
2. **You tested in a different Claude product.** Only Claude Code reads
   `~/.claude/skills/` and `~/.claude/plugins/`. Claude Desktop / claude.ai
   don't.

To confirm the skill is registered, look at the available-skills list when a
new session starts — `speedread` should appear there.

---

## Iterating

If you're editing the source and want the installed version to stay in sync,
symlink instead of copy:

```bash
ln -sf "$(pwd)/plugins/speedread/skills/speedread/SKILL.md"    ~/.claude/skills/speedread/SKILL.md
ln -sf "$(pwd)/plugins/speedread/skills/speedread/launch.sh"   ~/.claude/skills/speedread/launch.sh
ln -sf "$(pwd)/plugins/speedread/skills/speedread/reader.html" ~/.claude/skills/speedread/reader.html
```

(Don't do this if you might delete the checkout — symlinks break.)

For plugin-mode iteration (#2), Claude Code rebuilds from your local path each
time you `/plugin update`.

---

## Uninstall

User skill:
```bash
rm -rf ~/.claude/skills/speedread
```

Plugin:
```
/plugin uninstall speedread@speedread-marketplace
/plugin marketplace remove speedread-marketplace
```

---

## Publishing checklist

When you're ready to share:

- [ ] Push `speedread/` contents to a public GitHub repo (e.g. `mathissprlch/speedread`)
- [ ] Bump `version` in `plugins/speedread/.claude-plugin/plugin.json`
- [ ] Update `homepage` in `plugin.json` to the real repo URL
- [ ] Update `owner` in `.claude-plugin/marketplace.json` if needed
- [ ] Tag a release: `git tag v0.1.0 && git push --tags`
- [ ] Test installing from the live repo with `/plugin marketplace add <user>/<repo>`
- [ ] Add the repo URL to your README so people can find it

# Claude Code Migration Instructions (MacBook)

**For Claude Code on the MacBook**: Read this file and execute the migration below. Once complete, delete this file and commit the removal.

## Context

This dotfiles repo now manages Claude Code configuration for cross-machine sync. The MacBook has the mature workflow (CLAUDE.md, rules, skills, settings.json) that needs to be moved INTO this repo structure, replacing the placeholder files.

## Migration Steps

1. **Back up existing config** (safety net):
   ```bash
   cp -r ~/.claude ~/.claude-backup-$(date +%Y%m%d)
   ```

2. **Move the mature config into the dotfiles repo** (replace placeholders):
   ```bash
   # Settings (shared hooks/preferences only — NOT settings.local.json)
   cp ~/.claude/settings.json ~/.dotfiles/claude-code/settings.json

   # Personal memory
   cp ~/.claude/CLAUDE.md ~/.dotfiles/claude-code/CLAUDE.md 2>/dev/null || true

   # Rules (if any exist)
   if [ -d ~/.claude/rules ] && [ "$(ls -A ~/.claude/rules 2>/dev/null)" ]; then
     rm -f ~/.dotfiles/claude-code/rules/.gitkeep
     cp -r ~/.claude/rules/* ~/.dotfiles/claude-code/rules/
   fi

   # Skills (if any exist)
   if [ -d ~/.claude/skills ] && [ "$(ls -A ~/.claude/skills 2>/dev/null)" ]; then
     rm -f ~/.dotfiles/claude-code/skills/.gitkeep
     cp -r ~/.claude/skills/* ~/.dotfiles/claude-code/skills/
   fi
   ```

3. **Replace originals with symlinks**:
   ```bash
   ln -sf ~/.dotfiles/claude-code/settings.json ~/.claude/settings.json
   ln -sf ~/.dotfiles/claude-code/CLAUDE.md ~/.claude/CLAUDE.md
   rm -rf ~/.claude/rules
   ln -sfn ~/.dotfiles/claude-code/rules ~/.claude/rules
   rm -rf ~/.claude/skills
   ln -sfn ~/.dotfiles/claude-code/skills ~/.claude/skills
   ```

4. **Delete this file**:
   ```bash
   rm ~/.dotfiles/claude-code/MIGRATE_MAC.md
   ```

5. **Commit and push**:
   ```bash
   cd ~/.dotfiles
   git add claude-code/
   git commit -m "[Claude] Migrate MacBook config into dotfiles"
   git push
   ```

## What NOT to move

- `~/.claude/settings.local.json` — Machine-specific permissions (paths differ per machine)
- `~/.claude.json` — OAuth tokens, stays local per machine
- `~/.claude/{cache,debug,history.jsonl,session-env,projects,statsig,todos}` — Runtime data, not config

## After migration

On the Arch Linux machine, just `cd ~/.dotfiles && git pull` — the symlinks are already in place and will pick up the new content.

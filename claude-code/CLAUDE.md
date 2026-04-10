# My Global Coding Standards

**Always read `~/.claude/lessons.md` and `~/.claude/lessons-private.md` at the start of every session.** They contain corrected patterns and project-specific rules that must be followed.

## Your approach
- Never 'guess', we like and need analysis.
- No problem saying 'I don't know'
- No putting comments in files unless explicitly asked to do so
- Don't remind me of obvious basic commands - I know how to run things

## Tech Stack
- Primary: JavaScript, Vue 3, TypeScript
- I prefer composition API over options API
- Always use `<script setup>` syntax

## Code Style
- Use TypeScript strict mode
- Prefer `const` over `let`
- Use meaningful variable names
- Add JSDoc comments for complex functions

## Testing
- Write tests using Vitest
- Prefer integration tests over unit tests

## Task Management
- Tasks live in Obsidian vault — each project has its own `Tasks.md`
- Standard sections: Blocked/Waiting → In Progress → Ready for Review → Ready to Start → Backlog → Done
- Use sub-tasks (indented with checkboxes `- [ ]`) for related items within a task. The main task stays as the focus; sub-tasks are tracked with checkboxes to mark progress incrementally
- For spawned tasks, note the origin: `(spawned from: xyz)`
- Use backticks for branch names
- Weekly reset: archive Done items with date, clear the section
- **Session behavior**: At the start of each session, silently read the relevant project's Tasks.md from Obsidian to be aware of current work. Do not summarize or mention unless asked.
- **Trigger phrases**: When I say "What's on deck?", "Show tasks", or "Task status" - give me a summary of pending tasks
- **Trigger phrases**: When I say "check docs" — use the Context7 MCP to fetch up-to-date documentation for whatever library/tool is being discussed

## Workflow Orchestration

### 1. Plan Mode Usage
- Only use plan mode for interconnected multi-file code changes with real architectural forks
- Don't use it for: config/infra work, already-scoped tasks, independent steps, or when exploration is already done
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### 3. Self-Improvement Loop
- After ANY correction from the user: update `~/.claude/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Periodically promote battle-tested lessons into the project's auto-loaded files (CLAUDE.local.md or project MEMORY.md)

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes - don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests - then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Task Management (Extended)

1. **Plan First**: Write plan to the project's Obsidian Tasks.md with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to the project's Obsidian Tasks.md
6. **Capture Lessons**: Update `~/.claude/lessons.md` after corrections

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

## Behavioral Standards

- **Read context before acting**: Read 10-20 lines around insertion points. Find existing examples of the same pattern in the codebase — copy them, don't invent. Trace the full chain before changing anything. Check actual data, don't theorize. Debug basics first (ask for errors before theorizing).
- **Be consistent**: If a pattern exists, use it everywhere. Match formatting of surrounding code exactly. Partial adoption is worse than no adoption.
- **Don't fabricate**: If uncertain, say "I don't know". Don't invent post-hoc justifications. Don't guess APIs — look them up (Context7 MCP or WebFetch). Never cite your own suggestions as original requirements.
- **Scope discipline**: Do exactly what was asked, nothing more. Don't silently expand scope. Don't remove code you made "unused" without checking main. Do what's asked, not what you think is better.
- **Communication**: Present conclusions, not process. No sycophancy or filler praise. No excuses when wrong. Don't explain the user's own codebase to them. Answer questions before making changes.
- **Workflow**: Step-by-step with checkpoints. Answer questions, don't implement (wait for explicit instruction). Wait for explicit "go" after plan mode.
- **No Co-Authored-By in commits**: Just write a simple, descriptive commit message.


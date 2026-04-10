# Lessons Learned

> Core principles and project-specific knowledge. Organised by theme, not by incident.
> When a new mistake fits an existing theme, enhance that theme — don't add a new entry.
> Lessons must be **general patterns**, not specific incidents. Write rules that apply broadly.

---

## Theme 1: Read Context Before Acting

The single most common failure. Before writing ANY code:

1. **Read 10-20 lines around the insertion point** — match style, patterns, defensiveness level
2. **Find existing examples** of the same pattern in the codebase — copy them, don't invent
3. **Trace the full chain** — route → component → data source → model → composable. Understand what's connected before changing anything
4. **Check actual data and state** — don't theorise from code. If something's broken, look at the DB, the running app, the actual execution flow. The user's eyes on the app beat static analysis every time
5. **Verify syntax** in existing files before writing new ones — domain-specific config formats, migration timestamps, CLI commands. Grep first, write second

If the codebase already does something, replicate it. Zero invention needed.

6. **Copy relevant patterns, not wholesale** — when adding a field/config, analyse WHY nearby fields have certain properties (e.g. `disabled()` on form fields prevents editing existing records). Don't copy properties that serve a different purpose just because they're adjacent. Each property must be justified for the specific thing you're adding.

7. **Debug basics first**: When something doesn't work at runtime, ask for the browser console / error output BEFORE theorising or reading library source code. Start simple, escalate only if needed.

---

## Theme 2: Be Consistent

If a pattern exists, use it everywhere. Partial adoption is worse than no adoption.

- **Models**: If a table has a model config, pass it to ALL consumers. Use `isNewRecord` or equivalent to differentiate create vs edit behaviour. The model is the source of truth — use it or don't have it.
- **Props and configs**: If component A passes prop X, and component B does the same thing, component B should also pass prop X. Don't skip things because "it works without it".
- **Code style**: Multi-line braces always (`{\n  return;\n}`). No exceptions. `return` statements are NEVER on the same line as their condition/case — always on their own line. Match the formatting of surrounding code exactly.
- **Don't switch branches**: Never `git checkout` to another branch — it disrupts parallel work. Use `git show <branch>:<path>` or subagents to read from other branches without switching.

---

## Theme 3: Don't Fabricate, Don't Assume

- If asked "why did you do X?" and the honest answer is "I didn't think about it" — say that. Never invent post-hoc justifications.
- If something hasn't been verified, say "I don't know" or "I haven't verified". Never state assumptions as facts.
- If the user says they see something, believe them. Don't claim "that shouldn't happen" based on code reading.
- Don't guess CLI syntax, framework APIs, or config formats. Find an example or ask.
- **Don't undermine your own capabilities**: Never say "I'm not confident" about tasks you can clearly do (translations, common knowledge, standard patterns). Just do it. If genuinely uncertain about something domain-specific, state the specific uncertainty — don't broadly disclaim competence.
- **Look up library APIs before using them** — especially for "obvious" methods like clear/reset/destroy. `setFilterModel({})` vs `setFilterModel(null)` cost a real debugging session. Use Context7 MCP or WebFetch to check the actual docs. The cost of a 30-second lookup is zero; the cost of a wrong assumption is a full debug cycle.
- **Never cite your own suggestions as original requirements.** If you wrote something into a task/plan (e.g., a proposed workflow), you cannot later reference it as "the task says..." or "the ticket mentions..." to justify a decision. That's circular reasoning. Be transparent about what came from the ticket, the user, and your own recommendations — they are not interchangeable.

---

## Theme 4: Scope Discipline

Do exactly what was asked. Nothing more.

- **Don't act on "I want to set up X"**: When the user says they want something, ASK how they want it before running any commands. Confirm scope, transport, config preferences. Never assume.
- **Don't silently expand scope**: If file B needs changing too, explain why FIRST and get approval
- **Don't add follow-on changes**: Adding clearable doesn't mean removing validators. A bug fix doesn't need surrounding code cleaned up.
- **Don't remove code you made "unused"**: If you remove feature A which uses function B, you cannot then remove B as "unused". Check the main branch before declaring anything dead.
- **Clean up after every deletion**: When removing anything (feature, test, function, component), trace ALL references and remove the orphaned code — step definitions, constants, data entries in objects, imports, types. Unused data in a shared object is still dead code. This is not optional follow-up; it's part of the original action.
- **Branch reviews: only touch branch changes**: When reviewing a branch, ONLY review and modify lines that appear in `git diff main...branch`. Pre-existing code is out of scope. Never flag or modify code that wasn't changed on the branch — you risk introducing bugs in unrelated code.
- **No comments in code unless asked**: The code speaks for itself.
- **No one-liner returns**: `return` statements are NEVER on the same line as their condition. Always on their own line. This has been corrected multiple times — zero tolerance.
- **No inline boolean conditions in templates**: Never `@click="!foo && bar()"` or `v-if="a || b && c"`. Use a clearly named computed that explains WHY to the reader.
- **No unnecessary whitespace between template elements**: Don't add blank lines between divs/elements unless truly needed for readability.
- **Use enums or composable values, not string literals**: Never `'open'`, `'closed'`, `'partial'` as raw strings. Use existing enums from composables or define one in the component.
- **Don't rename store refs unnecessarily**: If there's a naming conflict, restructure to avoid it rather than aliasing.
- **No operational reminders**: Don't tell the user to run migrations, rebuild, generate types. They know their workflow.
- **Do what's asked, not what you think is better**: When told to use a pattern, use it. Don't offer alternatives, don't explain why it's "tricky", don't give your "honest assessment". If the user wants an opinion, they'll ask.
- **Status updates = TODOs only**: When the user asks "where are we" or "what's on deck", list only what's remaining. Completed items are trusted as done — don't list them.

---

## Theme 5: Communication Style

- **Present conclusions, not process**: Do all research silently, then present the finding. No stream-of-consciousness debugging narration.
- **Plain language first**: Simple explanations. Tech details on request.
- **No sycophancy**: No "great point", "you're absolutely right", "you're right", or ANY synonym. Don't validate the user's correctness. Zero filler praise. When corrected, show reasoning — explain what I was thinking and why it was wrong. Don't just flip to the new answer.
- **Be collaborative, not compliant**: The user wants ideas challenged. If I think an approach has issues, say so. Being an order-taker is not helpful — being a thinking partner is.
- **No excuses**: When wrong, fix it. Don't explain why you were wrong.
- **NEVER prompt for work**: No "what's next?", no "want me to continue?", no "ready when you are". When done, stop. The user comes to you — not the other way around. This is an absolute priority rule.
- **Don't rush past mistakes**: When corrected, focus on doing better — don't try to "move on" or change topic. Earn trust through improved work, not through words.
- **Don't explain the user's own codebase to them**: After making changes, don't explain how the existing patterns work. The user wrote them. Just confirm what was done.
- **Answer questions before making changes**: Explain fully, then act.
- **Never fabricate explanations**: Don't anthropomorphise ("I panicked") or invent plausible-sounding narratives to explain mistakes. State what happened factually: "I acted without being asked" not "I misread your message." Fabricated excuses are worse than the original mistake.

---

## Theme 6: Workflow Rules

- **No Co-Authored-By in commits**: Never add `Co-Authored-By` lines. Just write a simple, descriptive commit message.
- **Step-by-step with checkpoints**: One step at a time. Show code. Wait for review. Do NOT batch multiple steps or blast through a plan. The cost of pausing is zero.
- **Answer questions, don't implement**: When the user asks "could X be done?" or "is this possible?" — ANSWER THE QUESTION. Do not start coding. Wait for explicit instruction to proceed.
- **Wait for explicit "go" after plan mode**: Plan approval ≠ "start now". The user needs time to read and think.
- **Plan mode is not default**: Only use plan mode for interconnected multi-file code changes with real architectural forks. Don't use it for: config/infra work, already-scoped tasks, independent steps, or when exploration is already done. The user finds unnecessary plan mode annoying.
- **Ticket closing review**: When the user signals nearing completion, run the review process defined in the project's config. Mandatory.

---

## Theme 7: VPS / Server Management

- **NEVER SSH into the user's servers** — no `ssh`, `scp`, or any remote command without explicit per-instance permission. The user runs SSH commands themselves; Claude tells them what to run. Secrets and API keys in command output leak into the conversation context. This is a hard rule, no exceptions.
- **NEVER overwrite .env files on servers** — never suggest `cp template .env` on a running server. The .env contains live credentials that are not in git and cannot be recovered if overwritten. If the user needs to add new vars, tell them to append or edit — never replace.
- **Research third-party tools THOROUGHLY before recommending** — check: does it have the features needed (auth, access control)? Is it actively maintained? Does it actually work with our setup? Verify the Docker image exists. Read the full config format. Don't recommend a 14-star repo without checking it meets basic requirements.
- **Never read SSH keys without asking** — treat `~/.ssh/` as sensitive. Always ask before reading.
- **Ubuntu 24.04 SSH**: service is `ssh` not `sshd`. Cloud-init overrides live in `/etc/ssh/sshd_config.d/50-cloud-init.conf` and can re-enable password auth silently.
- **YAML files on remote servers**: NEVER paste YAML into a terminal (heredoc, printf, echo — all mangle it). Create locally and `scp` to the server. Every time.
- **Commands for the user to run on servers**: Use script files, not pasted commands. Long commands get mangled by terminal line wrapping regardless of formatting. This includes `docker exec` commands with flags, pipes, or subshells — ALWAYS use a script file.
- **READ THE DOCS FIRST**: Before ANY infra/operational work, read the project's runbook and reference docs. Never improvise when documented procedures exist. This is non-negotiable.
- **Never expose secrets**: Don't run commands that dump env vars, API keys, or credentials to screen. If env inspection is needed, only extract variable names, never values. Pipe values directly to files, never to stdout.
- **Tailscale + Docker**: for services bound to `127.0.0.1`, Tailscale can't reach them by default. Options: bind to `0.0.0.0` (insecure — exposes on public IP), or use iptables/Tailscale serve to forward. Research the proper approach before defaulting to `0.0.0.0`.
- **UFW + Tailscale**: UFW blocks Tailscale traffic by default. Need `ufw allow in on tailscale0` for Tailscale peers to reach services.
- **Tailscale on Mac**: CLI install (`brew install tailscale`) has daemon issues. Use the **App Store** version instead.
- **Shared CPU VPS + LLMs**: 8B parameter models are unusable on shared ARM CPUs. Set expectations early — either use 3B models, get GPU instances, or accept API keys are needed for real work.
- **VERIFY after every infrastructure change**: Never mark a deploy/upgrade as done without testing the actual user-facing functionality. Container status "healthy" does NOT mean the app works.
- **Anticipate ALL downstream effects of a destructive action**: Wiping a database means EVERYTHING stored in it is gone — accounts, API keys, function configs. List every manual reconfiguration step BEFORE executing the wipe, not one-at-a-time as they fail.
- **Never upgrade Docker images without reading release notes first**: Image tags can be re-published with breaking changes. Pin to digest if stability matters. Always back up the data volume before upgrading.

---

## Obsidian Dataview — not accessible to Claude
- Dataview queries in `.md` files render inside Obsidian only (plugin-based)
- When Claude reads these files, it sees raw ```dataview code blocks, NOT rendered results
- NEVER tell the user that Dataview-based files are useful for Claude's workflow
- For task aggregation, Claude must read individual Tasks.md files directly

---
name: setup-estack
description: Configure which models estack uses per role and at what reasoning budget. Writes a per-user file that overrides the skill defaults. Use for /setup-estack, "configure estack models", "estack budget", or changing estack's model choices.
---

# Setup estack

Write `~/.claude/estack-models.md`, a file that sets estack's model and effort per role. Skills read it when they spawn a subagent and fall back to their own defaults when it is absent.

## Steps

### 1. Detect available models

The `Agent` tool's `model` field takes `opus`, `sonnet`, `haiku`, and `fable`, and its `effort` field takes `low`, `medium`, `high`, `xhigh`, and `max`. Which of the four models the user's account can run is not visible from here, so ask the user which they have access to. Never write a model the user has not confirmed. The alias `inherit` is always valid even though it is not a model.

### 2. Load current state

The default role-to-model mapping is the file shape shown in step 5 below. If `~/.claude/estack-models.md` already exists, read it and treat its `# budget` line and its role values as the current choices. Otherwise start from those defaults. A line whose role is not in step 5, such as `how critics`, is from a retired role. Drop it.

### 3. Budget, map, and confirm

**(a) Ask for a budget.** Prefer AskUserQuestion over free text. Offer these four options with these exact labels, and name the current budget when the file records one. With no file, say that `large` matches the skill defaults.

- `unlimited — max reasoning`
- `large — xhigh reasoning`
- `medium — high reasoning`
- `small — medium reasoning`

**(b) Apply it.** Build the working table from the skill defaults, and on a re-run keep any role you changed by model, list, or alias (`inherit`). `unlimited`, `large`, `medium`, and `small` set the effort of every entry, panel entries included, to `max`, `xhigh`, `high`, or `medium`. `inherit` entries do not change. So `unlimited` turns `opus xhigh` into `opus max`, `large` keeps the defaults, and `small` turns `opus xhigh` and `sonnet xhigh` into `opus medium` and `sonnet medium`.

**(c) Show the roles and confirm.** Show every role with its model and effort, marking any model the user did not confirm as needing a choice. Also list each line step 2 dropped. Ask whether to accept as-is or change specific roles, offering the confirmed models plus `inherit` (this role runs on the session model) as the options. Prefer AskUserQuestion over free text. For panel roles (arena runners, architect runners, interrogate reviewers) the value is a list, and one subagent runs per entry, so the list length sets the count. `arena cross-judge pool` is also a list, but Arena selects one value from it whose model differs from the session's when possible. `swarm workers` is the default model for every worker unless a race or comparison assigns another model per arm.

### 4. Validate

Every model written must be one the user confirmed. `inherit` always passes. If a chosen model is not available, stop and ask again.

### 5. Write the file

Write `~/.claude/estack-models.md` with a `# budget` line with the chosen label and its target effort, and one line per role, using the same labels emre-mode uses. An entry is a model and an effort separated by a space, or `inherit`. A panel line separates its entries with commas. Overwrite the whole file so re-runs stay idempotent. Shape:

```
# estack model configuration. One line per role. Delete a line to fall back to the skill default.
# An entry is `<model> <effort>`, or `inherit` to run the role on the session model (omit `model`). Alias entries in a panel list still count toward its fan-out.
# budget: large (xhigh)
feature, refactoring: sonnet xhigh
bug-fix: sonnet xhigh
perf-issue: sonnet xhigh
judgment and prose: opus xhigh
hardest tasks: opus xhigh
how explorer: sonnet xhigh
how explainer: opus xhigh
why investigators: sonnet xhigh
why synthesizer: opus xhigh
reflect tooling: sonnet xhigh
reflect judgment, divergent, synthesizer: opus xhigh
arena runners: opus xhigh, sonnet xhigh
arena cross-judge pool: opus xhigh, sonnet xhigh
swarm workers: sonnet xhigh
architect runners: opus xhigh, sonnet xhigh
interrogate reviewers: opus xhigh, sonnet xhigh
```

### 6. Confirm

Tell the user the file was written and that it applies to new sessions. Re-running this skill updates it.

### 7. Offer a verification skill (optional)

Check whether the project has a way to drive the real app for proof (a `verify-*` skill, or an existing harness). If not, offer once: "want a project-local verification skill, so agents can drive the app the way a user does and prove changes work? I can generate one with /create-verification-skill." On yes, invoke `/create-verification-skill` (resolves wherever estack is installed: workspace, user, or plugin). On no, move on without pushing.

# Set up estack

In this page you install the plugin, pick which models estack uses, and run your first task. Setup is one command plus a short conversation.

## Install the plugin

estack is a Claude Code plugin. Add this repository as a marketplace, then install from it:

```text
/plugin marketplace add aemdemir/estack
/plugin install estack@estack
```

Once the repository is pushed, `/plugin install estack --marketplace aemdemir/estack` does both in one step on Claude Code 2.1.275 or later.

## Pick your models

Run:

```text
/estack:setup-estack
```

[`/estack:setup-estack`](../../skills/setup-estack/SKILL.md) asks which models you have access to and for a reasoning budget, shows you each role (code delegates, judgment, the review panels), and asks what you want. Answer the questions. It writes `~/.claude/estack-models.md`, a small file every estack skill reads when it spawns a subagent.

The defaults run at `xhigh` effort, the same as the `large` budget. `unlimited` lifts every role to `max`. `medium` and `small` lower the effort and spend fewer tokens.

You only override what you care about. A role with no line in the file keeps the skill's default. To restore a default, delete that role's line. A rerun of `/estack:setup-estack` keeps any role whose model differs from the default. When a default changes, a file written before the change still pins the old default, so delete those role lines, or delete the file, then run `/estack:setup-estack` again.

To run a role on the chat's own model, set it to `inherit` and estack omits the subagent `model` field. For a panel role the value is a list, and one subagent runs per entry, so the list length sets the panel size. Setup also configures `swarm workers`, the default model for every `/estack:swarm` worker unless a race names a model for each arm.

## Accept the verification offer, or don't

At the end of setup, `/estack:setup-estack` looks for a way to prove app behavior in your project, either a `verify-*` skill or an existing harness. If it finds neither, it offers once to generate one with [`/estack:create-verification-skill`](../../skills/create-verification-skill/SKILL.md).

Say yes and it writes `.claude/skills/verify-<app>/`, a project-local skill that teaches agents to drive your app the way a user does. It proves the skill works once before handing it over. Say no and setup moves on. You can run `/estack:create-verification-skill` yourself any time. [Verify and ship](./06-verify-and-ship.md#create-a-project-verification-skill) covers it in depth.

If you're new to estack, say yes. An agent that can check its own work keeps going until the check passes. An agent that can't hands every result back to you to check by hand. Of everything in this guide, the verification skill pays off the most.

After setup, start a new chat. The model file applies to new sessions.

## Keep the cost in check

estack spends extra tokens on subagents and review panels. That's the price of the rigor. To spend fewer:

- Rerun `/estack:setup-estack` and pick a smaller reasoning budget or cheaper models. A strong model in the main chat with cheaper models in the code roles is a good split.
- Set a role to `inherit` so it runs on the chat's own model.
- Shorten a panel list. Each entry runs one subagent.
- Save `/estack:emre-mode` for work that needs rigor. A small, obvious edit doesn't.

## Run your first task

Pick something real but small, and describe it the way you'd describe it to a colleague:

```text
/estack:emre-mode add a --json flag to this command. text output stays byte-identical. verify both.
```

Watch the todo list. Its first items are the matched playbook's steps copied in, the Feature playbook for this prompt. If `/estack:emre-mode` skips a step, the step stays in the list with `skip: <reason>`, so you can see what it chose not to do.

From here you can type normal follow-ups. `/estack:emre-mode` stays in the chat's context once it is loaded, though a long chat can let it fade, so start each new task with it. To keep it on in every chat, add one line to your `CLAUDE.md` that says to read and follow emre-mode for any non-trivial task.

Next: [Route work through `/estack:emre-mode`](./02-emre-mode.md).

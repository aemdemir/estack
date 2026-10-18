# estack

estack is my fork of [pstack](https://github.com/cursor/plugins/tree/main/pstack) by [poteto](https://x.com/poteto) (Lauren Tan). pstack is the set of skills poteto uses every day to ship high quality code at Cursor, and its principles match how i want to work. estack keeps pstack's structure, skills, playbooks, and principles as they are. it renames the mode to `emre-mode` and drops the playbooks and skills i don't use. the ideas and the writing here are poteto's.

there's a growing sense that ai writes too much slop code. i agree. i don't want to ship like a team of twenty slop artists. throughput without quality is not a goal i aspire to. if you want to go fast, go deep first.

**estack keeps pstack's answer.** this turns claude code into a real engineering team. the goal is not to maximize loc, in fact it's the opposite. estack helps you write less, but higher quality code.

**estack gives you fearless parallelism.** when you can go deep on one agent and trust it to write good, verifiable code, you can truly parallelize with confidence. start multiple agents up with `emre-mode` and trust that they'll apply rigorous engineering principles to their work.

**claude code picks the model per job.** every model has its strengths and weaknesses. estack names a model and an effort for each role, and many of the skills use multi-model panels so one model checks another.

fork it. improve it. make it yours.

## install

estack is not in the cursor marketplace. clone this repository into `~/.cursor/plugins/local/estack`, or run `/add-plugin <this repository's git url>` once it is pushed.

## get started

two steps:

1. run [`/setup-estack`](./skills/setup-estack/SKILL.md), pick a reasoning budget, and choose which models you want.
2. use [`/emre-mode`](./skills/emre-mode/SKILL.md) whenever you're doing anything that requires rigor.

new here? the [estack guide](./docs/guide/README.md) walks you through a first real task, from setup and prompting through verification and overnight runs.

that's it. the other skills are situational; the mode skill uses them for you as needed. out of the box the mode splits work by model strength: code delegates (feature, refactoring, bug fix, perf) go to sonnet, while the hardest changes, prose, and judgment go to opus. the default panel is opus / sonnet. [`/setup-estack`](./skills/setup-estack/SKILL.md) changes any of it.

## usage

use [`/emre-mode`](./skills/emre-mode/SKILL.md) at the start of a task. it reads your request, picks from a set of playbooks, and runs the other skills as the steps need them.

type `/emre-mode` before your task, so claude code attaches the skill to the message.

### just use [`/emre-mode`](./skills/emre-mode/SKILL.md)

this skill is the main shortcut. use it whenever you need the agent to do rigorous engineering work. it comes with twelve playbooks:

```
/emre-mode this pr has a subtle bug where the scroll drifts every 750ms even when idle. repro
first, then fix and verify.
```

```
/emre-mode i'm going to bed. land the stack even if ci flakes. i want everything ready for me
to merge by morning.
```

<details>
<summary>the twelve playbooks</summary>

| playbook | for |
|---|---|
| [investigation](./skills/emre-mode/playbooks/investigation.md) | a read-only question. how does x work, why was y built this way, are we sure. |
| [bug fix](./skills/emre-mode/playbooks/bug-fix.md) | reproduce a defect, root-cause it, and fix with runtime evidence. |
| [perf](./skills/emre-mode/playbooks/perf-issue.md) | trace a measured slowness and improve it against a baseline. |
| [feature](./skills/emre-mode/playbooks/feature.md) | new or changed behavior, built from a named data shape. |
| [refactoring](./skills/emre-mode/playbooks/refactoring.md) | a behavior-preserving change to structure or shape. |
| [prototype](./skills/emre-mode/playbooks/prototype.md) | a throwaway sketch to make a design or behavioral decision cheaply, or to settle an empirical fork by observing it. |
| [authoring a skill](./skills/emre-mode/playbooks/authoring-a-skill.md) | writing or editing a SKILL.md. |
| [eval](./skills/emre-mode/playbooks/eval.md) | test how a skill or prompt change affects agent behavior, blinded. |
| [babysit](./skills/emre-mode/playbooks/babysit.md) | drive a pr or a stack to merge-ready: conflicts, review threads, ci. |
| [shipping](./skills/emre-mode/playbooks/shipping.md) | independently verify a green stack, then land the contiguous verified run bottom-up through gitlab, pausing for your confirmation before each merge. |
| [autonomous run](./skills/emre-mode/playbooks/autonomous-run.md) | drive a long task to completion without stopping. |
| [opening a pr](./skills/emre-mode/playbooks/opening-a-pr.md) | open a ready pr from small ordered commits with a conventional commits title and a briefing-style body. invoked at the end of every other playbook. |

</details>



when invoked it:

1. matches your task to a [playbook](./skills/emre-mode/playbooks/) and opens a todo list whose first items are its steps, copied in verbatim.
2. routes to the other skills as the steps fire.
3. writes unslopped replies framed for the consumer and the maintainer.

the full rules and playbooks live in [`skills/emre-mode/SKILL.md`](./skills/emre-mode/SKILL.md).

to keep [`/emre-mode`](./skills/emre-mode/SKILL.md) on across turns, add one line to your `CLAUDE.md` that says to read and follow emre-mode for any non-trivial task. it then applies itself when a playbook matches or the task needs rigor, and stays out of the way otherwise. without that line, type it at the start of each task. say so to opt out for a turn.

[`/emre-mode`](./skills/emre-mode/SKILL.md) works extremely well with claude code's `/loop` command. you can make claude code work for many hours without sacrificing rigor.

## skills

[`/emre-mode`](./skills/emre-mode/SKILL.md) runs most of these for you when a step needs them (`how`, `why`, `architect`, `arena`, `swarm`, `interrogate`, `unslop`, `no-comments`, `technical-writing`, `tdd`, and the principles). the table below is for when you want one directly:

```
/how do we cancel runs? do we have an n+1 when we look up every run to cancel?
```

```
/interrogate review this pr.
```

<details>
<summary>all skills</summary>

| skill | use it when |
|---|---|
| [`/emre-mode`](./skills/emre-mode/SKILL.md) | default entry point for any non-trivial task. |
| [`/in-your-own-words`](./skills/in-your-own-words/SKILL.md) | you want the agent to play back your goal and the problem before it starts. runs only when you type `/in-your-own-words`. |
| [`/sharpen`](./skills/sharpen/SKILL.md) | you want a task approached the way a top expert would, aimed at what you're really after, without overspecifying it or deciding your choices for you. |
| [`/how`](./skills/how/SKILL.md) | you want a walkthrough of how a subsystem works. |
| [`/why`](./skills/why/SKILL.md) | you want to know why something was built this way. discovers available MCPs at run time and queries each evidence category in parallel (source control, issue tracker, long-form docs, real-time chat, infra observability, error tracking, analytics warehouse). |
| [`/recall`](./skills/recall/SKILL.md) | you're starting or resuming work and want your recent context on a topic rebuilt from your own chat history and the shared record, handed back as a tight current-state brief. |
| [`/ketchup`](./skills/ketchup/SKILL.md) | you want what changed in this chat since your last message, in a few plain sentences and small visuals, with just enough context on each action item to make the call. |
| [`/blast-radius`](./skills/blast-radius/SKILL.md) | you have a small-looking change and want to know what else it could break, with the one fact it's safe because of proven by running code, not asserted. |
| [`/architect`](./skills/architect/SKILL.md) | you're about to write code that crosses a function boundary and want the caller's usage, types, and module shape settled first. |
| [`/arena`](./skills/arena/SKILL.md) | you want N parallel attempts at the same thing, then to grab the best parts of each. |
| [`/swarm`](./skills/swarm/SKILL.md) | you want N parallel workers across different slices or races, then one aggregated report. |
| [`/interrogate`](./skills/interrogate/SKILL.md) | you have a diff and want different models to try to break it, including a strict code-quality lens. |
| [`/automate-me`](./skills/automate-me/SKILL.md) | you want your own `-mode` skill, drafted from how you've actually worked. |
| [`/setup-estack`](./skills/setup-estack/SKILL.md) | you want to pick which models estack uses per role. detects your models and writes a config rule. |
| [`/reflect`](./skills/reflect/SKILL.md) | a long task landed and you want the recipe captured as a skill edit. |
| [`/correct`](./skills/correct/SKILL.md) | you keep correcting agents for the same mistakes. mines history for mistake classes, fixes each at the highest level that works (architecture, then types, lint, and ci, then tests, with docs last), and keeps a table pairing each rule with what enforces it. |
| [`/teach`](./skills/teach/SKILL.md) | you want to actually understand a change or subsystem, not just have it summarized. runs how + why and weaves one plain explanation, built up diagram by diagram. |
| [`/tdd`](./skills/tdd/SKILL.md) | you're fixing a bug and there's a cheap local test path. write the failing test first, then the fix. |
| [`/benchmark-checklist`](./skills/benchmark-checklist/SKILL.md) | you ran a benchmark or measured a speedup or regression. vets the number (limiter, tuning, errors, repeat runs, end-to-end relevance) before you report or act on it. |
| [`/no-comments`](./skills/no-comments/SKILL.md) | strip comments before review; spawns Comment Sicko, fixes accepted findings, offers encodings for claimed constraints. |
| [`/figure-it-out`](./skills/figure-it-out/SKILL.md) | no bundled playbook fits. designs a rigorous, auditable playbook for the task. |
| [`/show-me-your-work`](./skills/show-me-your-work/SKILL.md) | you want a reviewable decision trail. logs decisions to a tsv you can commit. |
| [`/create-verification-skill`](./skills/create-verification-skill/SKILL.md) | your project has no scripted way to prove app behavior. generates a project-local verify skill with a feature map, for any language or platform. |
| [`/maintain-verification-skill`](./skills/maintain-verification-skill/SKILL.md) | your verify skill's feature map has drifted from the app. source wave + one live pass, at most one PR of proven corrections. |
| [`/deslop`](./skills/deslop/SKILL.md) | you're cleaning up code. removes the AI slop a branch picks up: unnecessary comments, abnormal defensive checks, type-dodging casts, deep nesting. keeps behavior unchanged. |
| [`/unslop`](./skills/unslop/SKILL.md) | you're cleaning up writing. removes AI tells. |
| [`/technical-writing`](./skills/technical-writing/SKILL.md) | layered doc standard (Diátaxis + Google developer style + STE + Global English) for docs, RFCs, readmes, PR descriptions, commit messages. |

</details>



### examples

mostly you type [`/emre-mode`](./skills/emre-mode/SKILL.md) at the start of a task and let it route to a playbook. the other skills fire as the steps need them. a few you reach for directly.


<details>
<summary>all the examples</summary>

```
bug fix:           /emre-mode this pr has a subtle bug where the scroll drifts every 750ms even
                   when idle. repro first, then fix and verify.
perf:              /emre-mode a big list takes a second or two to load even though we virtualize.
                   run a cpu trace and tell me why.
feature:           /emre-mode build a small feature behind a feature flag. verify it really works.
prototype:         /emre-mode build two prototypes of the markdown renderer so we can compare.
                   spawn an agent for each.
overnight run:     /emre-mode i'm going to bed. land the stack even if ci flakes. i want
                   everything ready for me to merge by morning.
babysit:           /emre-mode check on pr 123. anything outstanding?
figure it out:     /emre-mode i'm stepping away. migrate every caller from the synchronous store
                   to the new async one, keeping behavior identical. i want to trust it was done
                   right when i'm back.
how:               /how do we cancel runs? do we have an n+1 when we look up every run to cancel?
why:               /why is this feature flag not on yet?
architect:         design this instrumentation to be high signal with no false positives. /architect
                   this first.
arena:             /arena take my prompt to the arena verbatim. i want to compare their proposals
                   with yours.
swarm:             /swarm check every package under packages/ against its check.sh. one worker per
                   package. one report.
interrogate:       /interrogate review this pr.
tdd:               /tdd implement
unslop:            can we unslop and tighten the new changes?
reflect:           /reflect that took too long. capture what we learned so the next run doesn't
                   repeat it.
correct:           /correct
show-me-your-work: /show-me-your-work keep a decision trail i can review when i'm back.
automate-me:       /automate-me
```

</details>

## the `emre-agent` and Comment Sicko subagents

[`/emre-mode`](./skills/emre-mode/SKILL.md) runs in the chat that receives it. that chat owns the playbook, the todo list, and every subagent spawn.

estack also ships [`subagent_type: "estack:emre-agent"`](./agents/emre-agent.md) as the wrapper for delegates spawned during a run. it reads `emre-mode` in full, including its inline principles index, before doing any work. substituting `general-purpose` skips that read and drifts. do not spawn `emre-agent` to run the playbook itself.

[`/emre-mode`](./skills/emre-mode/SKILL.md) and [`subagent_type: "estack:emre-agent"`](./agents/emre-agent.md) route through the same wrapper.

estack also ships [Comment Sicko](./agents/comment-sicko.md), a read-only comment reviewer available as `subagent_type: "estack:comment-sicko"`. usually invoke it through [`/no-comments`](./skills/no-comments/SKILL.md), not directly.

## principles

twenty-four short skills, one principle each. `emre-mode` indexes them inline and reads that index at task start. the standalone files are there so other skills can reference a principle by name, and so the index can point at the full rule for each.

<details>
<summary>all twenty-four principles</summary>

| principle | group | rule |
|---|---|---|
| [laziness-protocol](./skills/principle-laziness-protocol/SKILL.md) | core | Bias toward deletion and the smallest change that solves the problem. |
| [foundational-thinking](./skills/principle-foundational-thinking/SKILL.md) | core | Apply before writing logic: choosing core types and data structures, sequencing scaffold-vs-feature work, asking what concurrent actors share. Get the data structures right so downstream code becomes obvious. |
| [redesign-from-first-principles](./skills/principle-redesign-from-first-principles/SKILL.md) | core | Redesign as if the requirement had been a foundational assumption from day one, instead of bolting it on. |
| [attack-the-premise](./skills/principle-attack-the-premise/SKILL.md) | core | Apply when two or more fixes that share one premise have failed the same gate. Write the premise down and test it directly before you write another fix that assumes it. |
| [subtract-before-you-add](./skills/principle-subtract-before-you-add/SKILL.md) | core | Remove dead weight, redundant validators, and stub references first, then build on the simpler base. |
| [minimize-reader-load](./skills/principle-minimize-reader-load/SKILL.md) | core | Count layers between question and answer, and hidden state in the reader's head; collapse one-caller wrappers and shrink mutable scope. |
| [outcome-oriented-execution](./skills/principle-outcome-oriented-execution/SKILL.md) | core | Apply during planned rewrites and migrations with explicit phase boundaries. Converge on the target architecture; don't preserve smooth intermediate states with throwaway compatibility code. |
| [experience-first](./skills/principle-experience-first/SKILL.md) | core | Choose user delight over implementation convenience; ship fewer polished features over more rough ones. |
| [exhaust-the-design-space](./skills/principle-exhaust-the-design-space/SKILL.md) | core | Build 2-3 competing prototypes and compare side by side before committing. |
| [build-the-lever](./skills/principle-build-the-lever/SKILL.md) | core | Apply to any non-trivial work, not just bulk work: edits, migrations, analyses, checks. Build the tool that does it or proves it (codemod, script, generator, or a skill your subagents follow) instead of working by hand. The tool is the artifact a reviewer can rerun. |
| [model-the-domain](./skills/principle-model-the-domain/SKILL.md) | architecture | Encode the domain in a structure instead of scattered conditionals. |
| [boundary-discipline](./skills/principle-boundary-discipline/SKILL.md) | architecture | Concentrate guards at system boundaries (CLI, config, network, external APIs); trust internal types and keep business logic in pure functions. |
| [type-system-discipline](./skills/principle-type-system-discipline/SKILL.md) | architecture | Make illegal states unrepresentable, brand semantic primitives, parse external data at boundaries, exhaust variants, derive from authoritative schemas. |
| [make-operations-idempotent](./skills/principle-make-operations-idempotent/SKILL.md) | architecture | Converge to the same end state regardless of partial prior runs. |
| [migrate-callers-then-delete-legacy-apis](./skills/principle-migrate-callers-then-delete-legacy-apis/SKILL.md) | architecture | Migrate callers and delete the old API in the same wave instead of preserving compatibility layers. |
| [separate-before-serializing-shared-state](./skills/principle-separate-before-serializing-shared-state/SKILL.md) | architecture | Eliminate the sharing first; serialize structurally only when one shared writer is a real invariant. |
| [prove-it-works](./skills/principle-prove-it-works/SKILL.md) | verification | Apply after completing a task, before declaring done. Verify against the real artifact (run the feature, read the actual value, inspect the diff), not a proxy, self-report, or 'it compiles.'. |
| [fix-root-causes](./skills/principle-fix-root-causes/SKILL.md) | verification | Trace each symptom back to the first place the system went wrong and fix it there. A guard is a fix only when the state it handles is legitimate. |
| [sequence-verifiable-units](./skills/principle-sequence-verifiable-units/SKILL.md) | verification | Apply to multi-step work (sweeps, migrations, runs of similar edits) and to how you stack commits and PRs. Break work into small units that each end in a verifiable state, check each before the next, and order delivery so the sequence proves itself to a reviewer. |
| [test-behavior-not-implementation](./skills/principle-test-behavior-not-implementation/SKILL.md) | verification | Apply when you write, change, or keep a test. Assert what the code's users can observe, so the test fails when that behavior breaks and keeps passing when only the internals change. |
| [explain-the-number](./skills/principle-explain-the-number/SKILL.md) | verification | Apply before you trust, report, or act on a number you measured: a speedup, a regression, a throughput, a latency, or an eval result. Find what limits it, and rule out that it measured something other than the work you think. |
| [guard-the-context-window](./skills/principle-guard-the-context-window/SKILL.md) | delegation | Route bulk to subagents; keep summaries in the main thread, not raw payloads. |
| [never-block-on-the-human](./skills/principle-never-block-on-the-human/SKILL.md) | delegation | Proceed, present the result, let the human course-correct after the fact; reserve confirmation for irreversible actions. |
| [encode-lessons-in-structure](./skills/principle-encode-lessons-in-structure/SKILL.md) | meta | Encode the rule as a lint, metadata flag, runtime check, or script instead of more text. |

</details>

## not shipped here

a few things `emre-mode` references but doesn't bundle:

- `skill-creator`, which authors SKILL.md files, ships with claude code's bundled anthropic skills.
- `/loop` is a claude code built-in.
- a project's `verify-<app>` skill is the control surface for its app. [`/create-verification-skill`](./skills/create-verification-skill/SKILL.md) writes it.

## why are there no planning skills?

estack ships no planning playbook. claude code already has a great plan mode which works great with estack. the best spec is code.

## make it yours

`emre-mode` is pstack's `poteto-mode` with the playbooks i don't use removed. you may not want exactly that.

type [`/automate-me`](./skills/automate-me/SKILL.md). it mines your recent transcripts, drafts a `<your-name>-mode` skill from how you've actually worked, and routes through estack underneath. you keep estack as the base and end up with your own routing skill alongside `emre-mode`.

models are configurable too. type [`/setup-estack`](./skills/setup-estack/SKILL.md). it asks which models you have access to and writes a small per-user file mapping each role (code, judgment, the review panels) to a model and an effort. every skill reads it and falls back to sensible defaults when the file is absent, so you override only what you want.

when a default changes, a file written before the change still pins the old default. delete those role lines, or delete the file, then run `/setup-estack` again. a rerun keeps any role whose model differs from the default.

## license

MIT. pstack is copyright Lauren Tan, and the [LICENSE](./LICENSE) keeps that notice. the [`deslop`](./skills/deslop/SKILL.md) skill is ported from cursor's `cursor-team-kit` plugin, also MIT, copyright Cursor, and the LICENSE carries that notice too.

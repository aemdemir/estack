# Design before you write code

One attempt at a hard design locks in the first shape the model thought of. `/estack:architect` settles types and boundaries before implementation. `/estack:arena` runs several attempts at the same brief and merges the best parts. `/estack:interrogate` has other models try to break the result. When the job is coverage rather than design synthesis, `/estack:swarm` fans out slices or races and aggregates their results.

The two most common design mistakes are taking the agent's first design and polishing a plan that no code has tested. This page fixes both. You plan through code: prototypes answer the open questions, a README or tutorial sets the target, and the written plan comes last.

## Settle the shape with `/estack:architect`

```text
/estack:architect design the import pipeline before writing any code. i care most about how callers use it.
```

[`/estack:architect`](../../skills/architect/SKILL.md) grounds itself first, running `/estack:how` over the code the design touches and `/estack:why` when it moves ownership or layers. Then it runs `/estack:arena` to produce competing design sketches, with the caller's usage written first in each, followed by types, signatures, and a module map.

By default it proceeds straight from the synthesized design into implementation. If you want to see the design first, say so:

```text
/estack:architect with checkpoint. stop and show me before implementing.
```

The design isn't sacred once code starts. If implementation shows the same workaround in unrelated places, or types that only compile with `any` or forced casts, `/estack:architect` treats that as proof the design is wrong. It scraps the sketch and starts over instead of patching around it.

## Fan out attempts with `/estack:arena`

```text
/estack:arena take my prompt to the arena verbatim. i want to compare their proposals with yours.
```

[`/estack:arena`](../../skills/arena/SKILL.md) is the general tool underneath. N subagents attempt the same design or code brief in parallel, each writing to its own worktree or directory. A read-only judge, on a different model when your configuration allows one, scores every candidate against a rubric. The coordinator reads each candidate end to end, picks a base, grafts in the best ideas from the losers, and verifies the result.

```mermaid
flowchart LR
    A[One task] --> B[Configured panel]
    B --> C[Candidate 1]
    B --> D[Candidate 2]
    B --> E[Candidate N]
    C --> F[Cross-judge]
    D --> F
    E --> F
    F --> G[Pick a base]
    G --> H[Graft the best parts]
    H --> I[Verify]
```

The panel comes from your [`/estack:setup-estack`](../../skills/setup-estack/SKILL.md) configuration, and you can adjust it per task. Ask for more candidates when the decision matters, fewer when it doesn't:

```text
/estack:arena this, 5 candidates. the cache key format is expensive to change later.
```

## Cover slices and races with `/estack:swarm`

```text
/estack:swarm check every package under packages/ against its check.sh. one worker per package. one report.
```

[`/estack:swarm`](../../skills/swarm/SKILL.md) fans N workers across independent slices, coverage matrices, gauntlet lanes, exploration partitions, or declared race arms. Each worker gets its own scope and check, then reports `PASS`, `ISSUES`, or `BLOCKED`. The parent waits for the workers and returns one compact report with any gaps or dropouts.

Reach for it when parallelism buys coverage or lets independent checks race. `/estack:arena` gives every worker the same design or code brief, then picks a base and grafts the best parts. `/estack:swarm` covers slices or runs a race with a selection rule declared up front. It does not use the base-selection and grafting ceremony.

## Break it with `/estack:interrogate`

```text
/estack:interrogate the whole branch, but skeptically. no nitpicks unless it's an actual bug or regression.
```

[`/estack:interrogate`](../../skills/interrogate/SKILL.md) sends the same diff, intent, and rubric to reviewers on different models. Model diversity is the point. Different models have different blind spots, so a finding two models raise independently is high-confidence signal. The lead sorts everything into `Act on`, `Consider`, `Noted`, and `Dismissed`, with a reason for each dismissal, and applies nothing automatically.

Read the dismissals too. The lead is a pragmatic senior engineer, not an oracle, and you can override it.

## Prototype instead of debating

Never take the first design. Ask for a few, and pick from evidence you can see:

```text
/estack:emre-mode prototype a few options for the new dropdown menu. take screenshots or videos for me to compare.
```

The [Prototype playbook](../../skills/emre-mode/playbooks/prototype.md) builds throwaway sketches in a scratch directory, puts the variants behind one switcher, drives each one, and captures screenshots or timings. It also works for behavior and algorithms, not just UI. Prototypes are planning with code. They let the agent answer its own open questions by running something instead of asking you, and they leave room for an option you wouldn't have thought of.

The same idea scales up to a real design. Pair `/estack:architect` with prototypes and keep a review gate:

```text
/estack:emre-mode we need rate limiting for external webhooks. /estack:architect it first, and answer open questions with prototypes. let me review before proceeding.
```

Don't spend reviewers on an abstract plan. `/estack:interrogate` belongs on a diff. Point adversarial review at a plan with no code behind it and the reviewers invent theoretical risks and edge cases that will never happen. Let prototypes settle the questions, then review what got built.

## Write the README first for shared code

For a package or API that other code will use, start with the doc a user would read:

```text
/estack:emre-mode write a tutorial for how i would use the new config package first. then /estack:teach me why it beats the current one.
```

Writing the tutorial first forces the caller's view. You describe the API to a hypothetical user and work back to the implementation. The doc also becomes a concrete target the agent checks its own work against. Name [`/estack:technical-writing`](../../skills/technical-writing/SKILL.md) when the doc itself matters, so a tutorial stays a tutorial instead of drifting into reference and explanation at once.

## How much design work does a task deserve?

You might be wondering whether every change needs this. No. Most changes need none of it. A rough ladder:

- A small, finished change you're unsure about needs `/estack:interrogate` alone.
- A change that crosses function boundaries or moves ownership earns `/estack:architect`, which brings `/estack:arena` with it.
- A standalone decision where independent attempts would help, like naming, formats, or an algorithm, is `/estack:arena` directly.
- A coverage matrix, set of parallel checks, or race with declared arms is `/estack:swarm`.
- An open question you could answer by running something, like a layout, a timing, or an approach, gets a prototype, not a debate.
- A contested design that's expensive to reverse gets `/estack:architect`, then `/estack:interrogate` before shipping.

`/estack:emre-mode` already applies this ladder. Boundary-crossing work triggers `/estack:architect` on its own, so you reach for these directly mainly when you want more or less scrutiny than the default.

Next: [Build and clean the change](./05-build-and-clean.md).

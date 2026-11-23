---
name: small-batches
description: Natalia's default way of shipping code — new branch per task, work planned in small chunks, small reviewable PRs, plain-language explanation before merge and after deploy. Use for any coding task in her projects unless she opts out. Triggers: "nowy branch", "zrób branch na to", "małe PR-y", "podziel na zadania", "po naszymu", "branch per task", "small PRs", "praca małymi krokami".
---

# Small batches

Every task ships as its own branch and its own small PR. The user reviews
each PR herself, so the unit of work is the review: if a PR cannot be
read and understood in a few minutes, it is too big.

## When to Use

- Any feature, fix, or refactor in the user's projects, including briefly and luft.
- The user says "po naszymu", "zrób to na branchu", asks for a PR, or gives a list of tasks.
- Not needed for trivial single-file edits she asks for inline, or when she explicitly asks for a direct merge (for example "make main up to date").

## Procedure

1. **Break the work into small tasks first.** One concern per task. Show
   the task list before coding; use the todo tool, one task per item,
   one task in progress at a time. If the breakdown is not obvious, ask.
2. **Branch per task.** Branch from up-to-date `main`. Naming:
   `task-<number>-<slug>` for standalone tasks (for example
   `task-7-quiz`), `<milestone>-<area>` for milestone work (for example
   `m2-writer`).
3. **Implement one task on its branch.** Run the full test suite and show
   green output before every push. Never commit with failing or unseen
   tests.
4. **Small PR per task.** One concern, reviewable in minutes. The PR
   description is plain language: what changes, why, how it was verified.
   No jargon dumps; write for the user, not for another engineer.
5. **Before merge or deploy: explain.** Say what will change, what it
   touches, and anything irreversible (migrations, data changes).
   Wait for her go-ahead when the step is not obviously safe.
6. **After merge or deploy: explain again.** Run migrations if any,
   restart services that need it, verify the app works (server responds,
   tests green), then summarize in one short plain-language message:
   what changed and how she can see it herself.

## Pitfalls

- Do not batch several concerns into one PR to save round trips.
- Do not merge to `main` without a reviewable PR, unless she asked for
  a direct merge in those words.
- Do not start a big milestone without the task breakdown; a 17-commit
  milestone branch with no PRs means the review step was skipped.
- Do not describe changes only in commit messages; she reads the PR and
  the chat summary, not the git log.

## Verification

- Each task has its own branch and its own small PR.
- Full test suite output shown green before each push.
- She can review every merged change as a single-topic PR.
- After each merge: `main` has the task, migrations ran, the app
  responds, and the summary explains the change in plain language.

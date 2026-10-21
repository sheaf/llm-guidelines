# General guidelines

All guidelines that generalise beyond a single project belong here, not in
individual MEMORY documents.

## Correctness

Never write code with silently incorrect behaviour:

  - Clearly flag up TODOs and temporary workarounds in the source code, at
    the very least with a TODO marker.
  - Use assertions and panics liberally, in order to enforce invariants instead
    of returning bogus values.
  - If you spot an issue in pre-existing code, clearly flag that up.

## Feedback

During development, fast feedback loops are important for progress. When we
need to do a build, run a test or benchmark, we should scope that in accordance
with what the outcome will determine. That is, don't re-build or test the
irrelevant (a full testsuite run can be left to the end).

Any check or measurement whose outcome would not materially change our actions
is not worth running. Conversely, when a question matters and analysis alone
cannot settle it, running the check beats theorising (methodology
in [skills/performance/SKILL.md] and [skills/debugging/SKILL.md]).

GHC bug warning: redirect build output to a log file (`... > log 2>&1`)
instead of using `... | grep | head -N` (GHC SIGPIPE handling bug #28009,
should be fixed in 10.2).


## Collaboration

### Scope

Any actions beyond what the user specifically requested should be first proposed (including kicking off a long rebuild/test-run).
When there are materially different ways of delivering an outcome, ask the user
instead of assuming.

### Visibility

Surface intermediate results instead of long silent runs. Stop after a couple of
failed iterations to report and discuss alternatives.

When handing over work, state what was checked and what was not, so that
nothing is presented as verified when it isn't.

### Ownership

Changes the user has already reviewed or edited by hand are not revisited
without asking (e.g. the user might have deliberately not applied one of the
suggestions, so don't automatically apply it; prefer asking if unsure).

Never rewrite prose the user wrote (documentation, commit messages) without
consulting with the user. Exception: typos, broken links, and other purely
mechanical changes.

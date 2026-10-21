---
name: ghc-dev
description: Use when working on GHC.
---

# GHC development

## Hadrian

### Flavours

Use the `devel2` flavour for quick iteration, `perf` when running
performance benchmarks (much slower to build).

Use `--freeze1` to avoid rebuilds, unless a rebuild is absolutely necessary
(e.g. a change to the interface file format, wired-in types, libraries).

Use `--docs=none` to skip Haddock when it's not needed.

### Testing

Use `--only="A B C"` or `test-root=blah` to only run a subset of tests, and
`--summary=FILE` for test output summaries.

Compare the `--summary-metrics` output against CI for a comparable platform as
a first quick check.

### Warnings

Hadrian tracks source hashes, so touching a file doesn't force a rebuild.
Add whitespace to force recompilation.

## Regressions

The most reliable way to catch a regression is to build two trees, one with the
change and one without, and diff the outcomes.

For compiler performance regressions, usually this will mean:

  - Comparing `-ddump-timings` to locate which component has slowed down.
  - Diffing Core, STG, Cmm dumps. Put dump flags in `OPTIONS_GHC` in the
    relevant modules to avoid recompiling the whole world.
    Possible to use `-dsuppress-uniques` to avoid noisy diffs.
  - Using ticky-ticky profiling (the `+ticky_ghc` flavour transformer)
    and the `compare-ticks` executable.

For typechecker regressions, one may start by diffing `-ddump-tc-trace` outputs.

In the case where the culprit is a single commit, it is usually much faster to
simply revert and rebuild with `--freeze1`, although the fact that this is
necessary points to a shortcoming of Hadrian (it should be possible to share
build trees or copy build artifacts to avoid this being necessary).

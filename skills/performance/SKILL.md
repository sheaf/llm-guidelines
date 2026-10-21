---
name: performance
description: Use when investigating the performance of programs.
---

# Benchmarking and performance work methodology

## Evidence

A benchmark result must be accompanied by a (non-post-hoc) mechanism that
explains it, otherwise there is no sense in basing decisions on it.
This mechanism must make sense independently, e.g. "paper P doesn't apply because X",
so that when X changes we know to revisit.
Nothing is "settled" purely based on benchmark numbers without a proper
understanding of the mechanism. An unexpected outcome is a prompt to look for
a bug, not a verdict.

## Fair comparisons

When evaluating a prototyped alternative, do not prematurely dismiss the
prototype based on an initial round of poor benchmark results. Perhaps the
prototype is just missing a key optimisation that would make it work great.

Similarly, when evaluating an alternative design, make sure that it is a fair
comparison (it should solve the same problem, not an easier problem).

## Observability

Always prioritise setting up the appropriate framework to glean maximal insight
into the measurement. For example, instead of measuring timing, add various
counters or statistics that are tailored to the specific program.

Timings in particular can be unreliable, as they require a quiet machine and
can be skewed by various things (e.g. code alignment).

## Haskell specifics

Use `-ddump-simpl`, `-ddump-stg-final`, `-ddump-cmm` etc to confirm any theories
about the performance behaviour of Haskell code, strictness, specialisation etc.

Profiling adds an overhead and can also produce misleading Core (e.g.
inhibiting specialisation). Don't take profiling results at face value if they
directly contradict non-profiled evidence.

## Reporting

When a result is inconclusive, clearly state what the evidence can and cannot
support, always providing the context necessary to re-create the measurement
(so that it can be re-evaluated when relevant external factors change).

---
paths:
  - "**/*.hs"
  - "**/*.hs-boot"
---

# Haskell-specific guidelines

## Strengths

Play to Haskell's strengths.

### Data structures

Use the right data structures for the task.
Use the `containers` library liberally, in particular `IntMap` when applicable
(significantly faster than `Map`).
Use unboxed vectors from `vector` (without bounds checking), or directly use
primitive arrays with the `primitive` package.

Generally, use lists as control structures, not as data structures.

### Types model the domain

Model the problem domain using types, in particular algebraic data types.

Avoid "Boolean blindness": instead of returning the result of a check as
a boolean value, return the evidence itself. (Common misconception: this does NOT
mean replacing `Bool` with `data Flag = FlagOn | FlagOff`.)

Similarly, "Parse, Don't Validate": use appropriate data representation that
reflects our knowledge about the possible range of values.

### Simple Haskell

Use advanced features such as `TypeFamilies` or `GADT` in a targeted manner,
when they clearly solve a problem or allow enforcing an invariant that would
be error-prone to maintain otherwise.

### Refactoring

Keep refactoring the codebase, e.g. to make the integration of new features
go more smoothly. It is easy to perform ambitious refactors in Haskell:
leverage this to keep the codebase healthy and the clarity high, instead of
piling on large amounts of one-off code.

### Pattern-match warnings

Rely on pattern match warnings. Avoid wildcard matches whenever possible, so
that we get good pattern match warnings e.g. when adding new datatype
constructors.

A good example of explicit pattern matching, with `val :: ABC`:

```hs
case val of
  A -> ...
  _ -> do         -- wildcard OK here as we match again below
    ...
    case val of
      B -> ...
      C -> ...    -- NB: NOT a wildcard match!
```

Any code that discards data is potentially suspicious: are we discarding
important information? If not, we probably shouldn't see that data in the
first place!

## Optimising Haskell code

With regards to performance optimisation, default to trusting GHC:

  - Trust GHC's strictness analyser and demand analysis. Many performance
    issues can be solved by adding strictness annotations without completely
    rewriting the code.
  - Make sure typeclass specialisation can happen where important, e.g. by
    adding `INLINABLE` pragmas to overloaded functions that it is important to
    specialise.
  - If you suspect there is a potential performance pitfall, confirm your
    hypothesis first, either by direct benchmarking or by looking at
    intermediate compilation output (GHC Core, STG, Cmm, assembly).

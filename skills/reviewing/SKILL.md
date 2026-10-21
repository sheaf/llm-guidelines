---
name: reviewing
description: Use when reviewing a change, diff, commit or merge request.
---

# Review guidelines

## Assessing a change

When reviewing a change (or set of changes), three perspectives are important
to consider:

### Maintainability

Is the end result measurably better? Is the code clearer? Easier to understand?
Is it easier to write the correct code and harder to write buggy code now,
or does it rely on keeping discipline (bad, maintainability hazard)?

### Design

Is the overall design good or is it papering over a pre-existing flaw that
it would be better to address at the source? See [../../rules/design.md#Generality].

### Documentation

Is it properly documented, by the standards of [../../rules/docs.md]?

## Standards

For auxiliary code (internal testing code etc) the standards can be a bit lower,
yet we should try as much as possible to make the code idiomatic and clean so
that anyone cargo-culting from that auxiliary code doesn't propagate poor code.

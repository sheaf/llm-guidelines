---
name: debugging
description: Use when investigating a bug.
---

# Debugging guidelines

## Observability

When debugging, observability is key. If it is unclear where the bug is, add
necessary instrumentation to figure out what is happening. This may involve
passing debug flags, adding logging or one-off traces in the code, etc. This
creates tight feedback loops that allow us to quickly narrow down the source of
the bug, instead of spending hours theorising about the possible causes and
going around in circles harbouring incorrect assumptions about the code.
